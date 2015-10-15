// Foundation JavaScript
// Documentation can be found at: http://foundation.zurb.com/docs
$(document).foundation();



$(document).ready(function() {

	$('body').on ('click','.module-search-button',function(e) {
		e.preventDefault();
		$('.module-search').toggle();
		$(this).toggleClass('active');
		
	})	


	$('body').on ('click','.module-icon',function(e){
		e.preventDefault();
		$('.module-actions').toggleClass('active');
	})

	$('.module-views').on ('click','.module-view-map', function(e){
		console.log('map view');
		e.preventDefault();
		$('.module-grid').hide();
		$('.module-map').show();
		$('.module-view-map').addClass('active');
		$('.module-view-grid').removeClass('active');
	})

	$('.module-views').on ('click','.module-view-grid', function(e){
		e.preventDefault();
		$('.module-grid').show();
		$('.module-map').hide();
		$('.module-view-grid').addClass('active');
		$('.module-view-map').removeClass('active');		
	})	
});