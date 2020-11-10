class RadarTemplateContainer < ApplicationRecord
  CANNOT_HAVE_MORE_THAN_ONE_ACTIVE_VOTING_ERROR_MESSAGE = "No puede haber mas de una votación activa al mismo tiempo"

  include Ownerable
  has_many :radar_templates, -> { order(created_at: :asc) }
  belongs_to :owner, :class_name => 'User', :foreign_key => 'owner_id', :validate => true
  has_many :votings
  validates_uniqueness_of :name

  def clone_container!(owner, name, description, share: false)
    validate_ownership! owner
    transaction do
      cloned_container = RadarTemplateContainer.create!(owner: owner, description: description,
                                                        name: name, users: share ? users : [])
      radar_templates.each do |radar_template|
        # Clones template
        cloned_template = RadarTemplate.create!(radar_template_container: cloned_container, name: radar_template.name, owner: owner,
                              description: radar_template.description)
        # Clones axes
        radar_template.axes.each do |axis|
          Axis.create!(name: axis.name, description: axis.description, radar_template: cloned_template)
        end
      end
      cloned_container
    end
  end

  def active_voting
    votings.all.select{ |voting| voting.active? }.first
  end

  def active_voting_code
    active_voting && active_voting.code
  end

  def validate_no_active_votings!
    raise RuntimeError.new(CANNOT_HAVE_MORE_THAN_ONE_ACTIVE_VOTING_ERROR_MESSAGE) if active_voting.present?
  end

  def close(owner)
    validate_ownership! owner
    update!(active: false)
    radar_templates.each { |rt| rt.close owner }
  end
end