/**
 * @author Redais
 */


$(document).ready(function() {
		//if (!$("#mySelect option:selected").length)
		
    	function donnerstag(datum) { // Anm. 5
		  var Do=new Date();
		  Do.setTime(datum.getTime() + (3-((datum.getDay()+6) % 7)) * 86400000); // Anm. 3
		  return Do;
		}
		function kalenderwoche(){
			var datum = new Date();
			var DoDat=donnerstag(datum);
			var kwjahr=DoDat.getFullYear();
			var DoKW1=donnerstag(new Date(kwjahr,0,4)); // Anm. 2
			var kw=Math.floor(1.5+(DoDat.getTime()-DoKW1.getTime())/86400000/7); // Anm. 3, 4
			return kw-11;
		};
		c=kalenderwoche();
		//selector fuer das select-tag
		var sel="#exercise_ex_number option[value='"+ c +"']";
		$(sel).attr('selected', 'selected');
		
		
		
		
});

