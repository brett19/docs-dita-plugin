(function(H){H.className=H.className.replace(/\bno-js\b/,'js')})(document.documentElement);

/* Added placeholder for GCSE */
window.__gcse = {
	callback: function() {
		var gcse_el = document.getElementById('gsc-i-id1');
		gcse_el.setAttribute('placeholder', 'Search Documentation');
	}
};

/* Load Vendor Things */
(function(d,t) {
	if ('querySelector' in d && 'addEventListener' in window) {
		r=d.createElement(t);s=d.querySelector(t);
		r.src='../assets/javascripts/vendor/require.js';
		r.setAttribute('data-main', '../assets/javascripts/application');
		s.parentNode.insertBefore(r,s);
	}
})(document,'script');
