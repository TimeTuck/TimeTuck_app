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
				$scope.isDisplaying = null;
				$scope.previousScale = null;
				$scope.focusImg = function (id) {
					var speed = 500;
					var $wrap = $("#" + id);
					var $image = $wrap.children("img");
					var $date = $("#" + id + "_date");
					var $feedItem = $wrap.closest(".feedItem");
					var $overlay = $("#overlay");
					var $exit = $("#" + id + "_exit");
					var imgWidth = $wrap.width();
					var imgHeight = $wrap.height();
					var imgAspect = imgWidth / imgHeight;
					var winAspect = $($window).width() / $($window).height();
					$scope.isDisplaying = id;
					$overlay.css({height: $(document).height()})
					$feedItem.css({width: $feedItem.width(), height: $feedItem.height()});
					$date.css('z-index', 150);
					$wrap.css({position: "fixed", width: imgWidth, height: imgHeight,
						       left: $wrap.offset().left - $($window).scrollLeft(),
					           top: $wrap.offset().top - $($window).scrollTop(),
							   padding: 0, margin: 0, zIndex: 100});

					var finalize = function () {
						$('body').css({overflow: 'hidden'});
						$image.width($image.width());
						$image.height($image.height());
						$image.css({'padding-left': ($($window).width() - $image.width()) / 2,
								    'padding-top': ($($window).height() - $image.height()) / 2})
						$wrap.css({width: "100%", height: "100%", left: 0, top: 0})
						$exit.css('display', 'block');
						$scope.previousScale = {width: $image.width(), height: $image.height()}
					}

					if (imgAspect < winAspect) {
						var newWidth = $($window).height() * imgWidth / imgHeight;
						$wrap.animate({height: $($window).height(),
									   width: newWidth,
							           left: ($($window).width() - newWidth) / 2,
									   top: 0}, speed, finalize)
					} else {
						var newHeight = $($window).width() * imgHeight / imgWidth;
						$wrap.animate({height: newHeight, width: $($window).width(),
							left: 0, top: ($($window).height() - newHeight) / 2 }, speed, finalize)
					}

					$date.fadeOut(speed);
					$overlay.css({display: 'block'});
					$overlay.animate({opacity: 1}, speed);
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

				$('body').on('mousewheel', function (e) {
					if ($scope.isDisplaying) {
						e.preventDefault();
						e.stopPropagation();
					}
				});

				$('body')[0].addEventListener('gesturechange', function (e) {
					if ($scope.isDisplaying) {
						var $image = $("#" + $scope.isDisplaying).children("img");
						$image.width($scope.previousScale.width * e.scale);
						$image.height($scope.previousScale.height * e.scale);
					}
				});

				$('body')[0].addEventListener('gestureend', function (e) {
					if ($scope.isDisplaying) {
						var $image = $("#" + $scope.isDisplaying).children("img");
						if ($image.width() < $scope.previousScale.width)
							$image.animate({width: $scope.previousScale.width, height: $scope.previousScale.height}, 500);
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
			#overlay {
				margin: 0px;
				padding: 0px;
				left: 0px;
				top: 0px;
				position: absolute;
				background-color: #000;
				height: 100%;
				width: 100%;
				z-index: 80;
				opacity: 0;
				display: none;
			}
			.exit {
				margin: 20px;
				z-index: 300;
				position: fixed;
				right: 0px;
				display: none;
			}
			.closeButton {
				color: #FFF;
				cursor: pointer;
			}
			.feedItem {
				margin-bottom: 10px;
				background-color: #deeed1;
			}
			.upperFeed {
				margin: 0px;
				padding: 20px 20px 0px 20px;
				display: block;
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
				z-index: 10;
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
		<div id="overlay">
		</div>
		<div id="wrapper">
			<div id="feed">
				<div class='feedItem' ng-repeat="item in feedItems | orderBy: '-orderdate'">
					<div class="dateWrapper" id="{{item.id}}_date">
						<div class="dateFeed">
							{{item.capsuledate}}
						</div>
					</div>
					<div class="upperFeed">
						<div class="imageWrapper" id="{{item.id}}">
							<div id="{{item.id}}_exit" class="exit">
								<span ng-click="closeImg(item.id)" class="closeButton">close</span>
							</div>
							<img ng-src="<?= $this->config->base_url() ?>static/images/live/{{item.owner}}/{{item.image}}"
								 title="{{item.capsuledate}}" class="feedImage" ng-click="focusImg(item.id)" />
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