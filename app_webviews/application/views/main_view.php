<?php
defined('BASEPATH') OR exit('No direct script access allowed');
?>
<!DOCTYPE html>
<html ng-app="timeFeed">
	<head>
		<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
		<script src="http://ajax.googleapis.com/ajax/libs/angularjs/1.3.14/angular.min.js"></script>
		<script type="application/javascript">
			var timeFeed = angular.module('timeFeed', []);
			timeFeed.controller("timeFeedCtrl", function ($scope) {
				$scope.feedItems = <?= json_encode($results) ?>;
				$scope.feedItemsResize = function () {
					for (var i = 0; i < $scope.feedItems.length; ++i) {
						$scope.feedItems[i] = $scope.resizeImage($scope.feedItems[i]);
					}
					return $scope.feedItems;
				}
				$scope.resizeImage = function (item) {
					resizeItem(item);
					return item
				}
			});

			timeFeed.directive('loadResize', function($window) {
				return function(scope, element) {
					var win = angular.element($window);
					win.bind('resize', function() {
						scope.$apply(resizeItem(scope.item))
					});
				}
			});

			function resizeItem(item) {
				var imageWidth = $(window).width() - 80;
				var imageHeight = Math.round(item.height * imageWidth / item.width);
				item.height = imageHeight;
				item.width = imageWidth;
			}
		</script>
		<style type="text/css">
			@font-face {
				font-family: CampBold;
				src: url('static/fonts/Rene.Bieder_Campton.Bold.otf');
			}
			@font-face {
				font-family: CampLight;
				src: url('static/fonts/Rene.Bieder_Campton.Light.otf');
			}
			html, body {
				margin: 0px;
				padding 0px;
				background-color: #97d461;
				width 100%;
				font-family: CampLight;
			}
			#wrapper {
				margin: 10px 0px 0px 0px;
				padding: 0px;
				width: 100%;
			}
			#feed {
				margin: 0px 10px;
				padding: 0px;
			}
			.feedItem {
				margin-bottom: 10px;
				background-color: #deeed1;
			}
			.upperFeed {
				margin: 0px;
				padding: 20px 20px 0px 20px;
				display: block;
				text-align: right;
			}
			.lowerFeed {
				margin: 0px;
				padding: 20px 20px 10px 20px;
				display: block;
			}
			.dateWrapper {
				width: 0px;
				height: 0px;
				position: relative;
			}
			.dateFeed {
				padding: 10px;
				color: #FFFFFF;
				float: left;
				top: 30px;
				background-color: #555555;
				position: absolute;
			}
			.username {
				font-family: CampBold;
				color: #555555;
				display: block;
			}
			.timeInfo {
				font-size: 10px;
			}
		</style>
	</head>
	<body ng-controller="timeFeedCtrl">
		<div id="wrapper">
			<div id="feed">
				<div id="find">

				</div>
				<div class='feedItem' ng-repeat="item in feedItemsResize()">
					<div class="dateWrapper">
						<div class="dateFeed">
							{{item.capsuledate}}
						</div>
					</div>
					<div class="upperFeed">
							<img ng-src="<?= $this->config->base_url() ?>static/images/live/{{item.owner}}/{{item.image}}"
								 title="{{item.capsuledate}}" width="{{item.width}}" height="{{item.height}}" load-resize />
					</div>
					<div class="lowerFeed">
						<span class="username">{{item.username}}</span>
						<span class="timeInfo">
							tucked <strong>{{item.capsuledate}}</strong> untucked <strong>{{item.uncapsuledate}}</strong>
						</span>
					</div>
				</div>
			</div>
		</div>
	</body>
</html>