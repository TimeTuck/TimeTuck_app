<?php
defined('BASEPATH') OR exit('No direct script access allowed');
?>
<!DOCTYPE html>
<html ng-app="timeFeed">
	<head>
		<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
		<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
		<script src="http://ajax.googleapis.com/ajax/libs/angularjs/1.3.14/angular.min.js"></script>
		<script type="application/javascript">
			var timeFeed = angular.module('timeFeed', []);
			timeFeed.controller("timeFeedCtrl", ['$scope', '$window', '$document', '$http', function ($scope, $window, $document, $http) {
				$scope.feedItems = <?= json_encode($results) ?>;
				$scope.count = <?= $count ?>;
				$scope.user = {key: '<?= $_GET['key'] ?>', secret: '<?= $_GET['secret'] ?>'};
				$scope.loadMore = function () {
					var key = $scope.user.key;
					var sec = $scope.user.secret;
					var count = $scope.count + 3;
					return $http.get("<?= $this->config->item('service_url') ?>/get_feed?key=" + key + "&secret=" + sec + "&count=" + count);
				}
				$($window).scroll(function () {
					if ($($window).scrollTop() + $($window).height() >= $($document).height()) {
						var promise = $scope.loadMore();
						$scope.$apply(function () {
							promise.success(function (data) {
								if (typeof data.images != 'undefined') {
									$scope.count = data.images.length;
									$scope.feedItems = data.images;
								}
							});
						});
					}
				});
			}]);
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
				padding: 0px 0px 30px 0px;
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
			.imageWrapper {
				margin: 0;
				padding: 0;
			}
			.feedImage {
				width: 100%;
				height: auto;
				width: auto\9;
			}
		</style>
	</head>
	<body ng-controller="timeFeedCtrl">
		<div id="wrapper">
			<div id="feed">
				<div class='feedItem' ng-repeat="item in feedItems">
					<div class="dateWrapper">
						<div class="dateFeed">
							{{item.capsuledate}}
						</div>
					</div>
					<div class="upperFeed">
						<div class="imageWrapper">
							<img ng-src="<?= $this->config->base_url() ?>static/images/live/{{item.owner}}/{{item.image}}"
								 title="{{item.capsuledate}}" class="feedImage" />
						</div>
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