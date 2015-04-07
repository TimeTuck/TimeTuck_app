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
			function fullSceenStart() {
				$("#hiddenField").append("<iframe src=\"mobile-event://fullscreenimage\"></iframe>");
				$("#hiddenField").html('');
			}

			function fullScreenEnd() {
				$("#hiddenField").append("<iframe src=\"mobile-event://fullscreenend\"></iframe>");
				$("#hiddenField").html('');
			}

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
				$scope.displayInfo = null;
				$scope.closeImg = function (id) {
					fullScreenEnd();
					var speed = 500;
					var $overlay = $("#overlay");
					var $exit = $("#" + id + "_exit");
					var $wrap = $("#" + id);
					var $holder = $("#" + id + "_holder");
					var $feedItem = $wrap.closest(".feedItem");
					var $image = $wrap.children("img");
					var $date = $("#" + id + "_date");

					$image.removeClass("downloadImage");

					$exit.css('display', '');
					$overlay.animate({opacity: 0}, speed, function () {
						$(this).css({"height": "", "display": ""});
						$exit.css('display', '');
					});

					$image.animate({width: $holder.width() , height: $holder.height(),
									'margin-left': 0, 'margin-top': 0}, function () {
						$(this).css({'margin-left': '', 'margin-top': '', position: '', height: '', width: ''})
					});
					$wrap.css({position: 'absolute', top: $($window).scrollTop(), left: $($window).scrollLeft(),
							   overflow: ''});
					$wrap.animate({width: $holder.width(), height: $holder.height(), top: $holder.offset().top,
								  left: $holder.offset().left}, function () {
						$(this).css({left: '', top: '', position: '', width: '', height: '', 'z-index': '', margin: '',
									 padding: ''});
						$holder.css({width: '', height: ''});
						$('body').css('overflow', '');
						$feedItem.css({width: '', height: ''});
					});
					$date.fadeIn(speed, function () {
						$(this).css({'z-index': '', display: ''});
					});

					$scope.displayInfo = null;
				}
				$scope.focusImg = function (id) {
					fullSceenStart()
					var speed = 500;
					var $wrap = $("#" + id);
					var $holder = $("#" + id + "_holder");
					var $image = $wrap.children("img");
					var $date = $("#" + id + "_date");
					var $feedItem = $wrap.closest(".feedItem");
					var $overlay = $("#overlay");
					var $exit = $("#" + id + "_exit");
					var imgWidth = $wrap.width();
					var imgHeight = $wrap.height();
					var imgAspect = imgWidth / imgHeight;
					var winAspect = $($window).width() / $($window).height();
					$scope.displayInfo = {id: id}
					$overlay.css({height: $(document).height()})
					$feedItem.css({width: $feedItem.width(), height: $feedItem.height()});
					$date.css('z-index', 150);
					$holder.css({width: imgWidth, height: imgHeight});
					$wrap.css({position: "absolute", width: imgWidth, height: imgHeight,
						       left: $wrap.offset().left,
					           top: $wrap.offset().top,
							   padding: 0, margin: 0, zIndex: 100});

					var finalize = function () {
						$('body').css({overflow: 'hidden'});
						$wrap.css({overflow: 'scroll'})
						$image.width($image.width());
						$image.height($image.height());
						$image.css({'margin-left': ($($window).width() - $image.width()) / 2,
								    'margin-top': ($($window).height() - $image.height()) / 2, 'position': 'absolute'})
						$wrap.css({width: "100%", height: "100%", left: 0, top: 0, position: "fixed"})
						$exit.css('display', 'block');
						$scope.displayInfo.width =  $image.width();
						$scope.displayInfo.height = $image.height();
						$scope.displayInfo.newWidth = $image.width();
						$scope.displayInfo.newHeight = $image.height();
						$image.addClass("downloadImage");
					}

					if (imgAspect < winAspect) {
						var newWidth = $($window).height() * imgWidth / imgHeight;
						$wrap.animate({height: $($window).height(),
									   width: newWidth,
							           left: ($($window).width() - newWidth) / 2 + $($window).scrollLeft(),
									   top: $($window).scrollTop()}, speed, finalize);
					} else {
						var newHeight = $($window).width() * imgHeight / imgWidth;
						$wrap.animate({height: newHeight, width: $($window).width(),
									   left: $($window).scrollLeft(),
							           top: ($($window).height() - newHeight) / 2 + $($window).scrollTop()}, speed,
							           finalize);
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

				var returningSize = false;

				$('body')[0].addEventListener('gesturechange', function (e) {
					if ($scope.displayInfo) {
						if (returningSize)
							return;

						var $wrap = $("#" + $scope.displayInfo.id);
						var $image = $wrap.children("img");
						var newWidth = $scope.displayInfo.newWidth * e.scale;
						var newHeight = $scope.displayInfo.newHeight * e.scale;
						var windowWidth = $($window).width();
						var windowHeight = $($window).height();
						var orgImgWidth = $image.width();
						var orgImgHeight = $image.height();

						$image.width(newWidth);
						$image.height(newHeight);

						if (newWidth <= windowWidth) {
							$image.css({'margin-left': (windowWidth - newWidth) / 2});
						} else {
							$image.css({'margin-left': 0});
							var anchorX = (windowWidth / 2) + $wrap.scrollLeft();
							var xPercent = anchorX / orgImgWidth;
							var anchNewX = newWidth * xPercent;
							var newScrollLeft = $wrap.scrollLeft() + (anchNewX - anchorX);
							$wrap.scrollLeft(newScrollLeft);
						}

						if (newHeight <= windowHeight) {
							$image.css({'margin-top': (windowHeight - newHeight) / 2});
						} else {
							$image.css({'margin-top': 0});
							var anchorY = (windowHeight / 2) + $wrap.scrollTop();
							var yPercent = anchorY / orgImgHeight;
							var anchNewY = newHeight * yPercent;
							var newScrollTop = $wrap.scrollTop() + (anchNewY - anchorY);
							$wrap.scrollTop(newScrollTop);
						}
					}
				});

				$('body')[0].addEventListener('gestureend', function (e) {
					if ($scope.displayInfo) {
						var $image = $("#" + $scope.displayInfo.id).children("img");
						var windowWidth = $($window).width();
						var windowHeight = $($window).height();
						if ($image.width() < $scope.displayInfo.width) {
							returningSize = true;
							$image.animate({width: $scope.displayInfo.width, height: $scope.displayInfo.height,
										    'margin-left': (windowWidth - $scope.displayInfo.width ) / 2,
										    'margin-top': (windowHeight - $scope.displayInfo.height) / 2}, 500,
											function () {
												$scope.displayInfo.newWidth = $scope.displayInfo.width;
												$scope.displayInfo.newHeight = $scope.displayInfo.height;
												returningSize = false;
											});
						} else {
							$scope.displayInfo.newWidth = $image.width();
							$scope.displayInfo.newHeight = $image.height();
						}
					}
				});
			}]);

			function downLoadImage(x, y) {
				var element = document.elementFromPoint(x, y);
				if (element == null)
					return null;
				if ((' ' + element.className + ' ').indexOf(' downloadImage ') > -1)
					return element.src;
				else
					return null;
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
				-webkit-touch-callout: none;
				-webkit-user-select: none;
				-khtml-user-select: none;
				-moz-user-select: none;
				-ms-user-select: none;
				user-select: none;
			}
			h1 {
				font-size: 1.4em;
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
			.imageHolder {
				margin: 0;
				padding: 0;
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
			#hiddenField {
				display: none;
			}
			.nothingFeed {
				text-align: center;
				padding: 20px;
			}
		</style>
	</head>
	<body ng-controller="timeFeedCtrl" ng-init="">
		<div id="overlay">
		</div>
		<div id="wrapper">
			<div ng-show="feedItems.length == 0" class="nothingFeed">
				<h1>There's nothing in your feed yet!</h1>
			</div>
			<div id="feed">
				<div class='feedItem' ng-repeat="item in feedItems | orderBy: '-orderdate'">
					<div class="dateWrapper" id="{{item.id}}_date">
						<div class="dateFeed">
							{{item.capsuledate}}
						</div>
					</div>
					<div class="upperFeed">
						<div class="imageHolder" id="{{item.id}}_holder">
							<div class="imageWrapper" id="{{item.id}}">
								<div id="{{item.id}}_exit" class="exit">
									<span ng-click="closeImg(item.id)" class="closeButton">close</span>
								</div>
								<img ng-src="<?= $this->config->base_url() ?>static/images/live/{{item.owner}}/{{item.image}}"
									 title="{{item.capsuledate}}" class="feedImage" ng-click="focusImg(item.id)" />
							</div>
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
		<div id="hiddenField">
		</div>
	</body>
</html>