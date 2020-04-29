$(window).scroll(function(){
    var distanceFromTop = $(document).scrollTop();    
    if(distanceFromTop < 84 )
    {
        $('.navbar').css('height', '220px');
        $('.navbar').css('padding-bottom', '20px');
        // navbar div
        $('.navbar div').css('transform','scale(1.0)');
        $('.navbar div').css('margin-top','0px');
    }
    else if(distanceFromTop > 200)
    {
        // navbar
        $('.navbar').css('height', '50px');
        //$('.navbar').css('padding-top', '30px');
        $('.navbar').css('padding-bottom', '50px');
        // navbar div
        $('.navbar div').css('transform','scale(0.5)');
        $('.navbar div').css('margin-top','-70px');
    }   
});