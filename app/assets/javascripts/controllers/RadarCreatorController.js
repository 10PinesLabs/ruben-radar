angular.module('ruben-radar')
    .controller('RadarCreatorController', function ($scope, _, radarFactory, RadarService, ngToast) {
        $scope.radar = radarFactory.newRadar();
        $scope.axisInput = '';
        $scope.actionIcon = 'images/delete.png';

        $scope.isAxisEmpty = function isAxisEmpty() {
            return _.isEmpty($scope.axisInput);
        };

        $scope.addAxis = function addAxis() {
            $scope.radar.addAxis($scope.axisInput);
            $scope.axisInput = '';
        };

        $scope.removeAxis =  function removeAxis(axis){
            $scope.radar.removeAxis(axis);
        };

        $scope.radarIsInvalid = function radarIsInvalid() {
            return this.radarDescriptionIsEmpty() || this.radarAxisIsEmpty();
        };

        $scope.radarAxisIsEmpty = function radarAxisIsEmpty() {
            return _.isEmpty($scope.radar.axes);
        };

        $scope.radarDescriptionIsEmpty = function radarDescriptionIsEmpty() {
            return _.isEmpty($scope.radar.description);
        };

        $scope.createRadar = function createRadar() {
            RadarService.createRadar($scope.radar).then(function () {
                ngToast.create({
                    className: 'success',
                    content:'Se ha creado el radar con éxito.'
                });
            });
            $scope.radar = radarFactory.newRadar();
        };
    });