/*
 *  inlineDisqussions
 *  By Tsachi Shlidor ( @shlidor )
 *  Inspired by http://mystrd.at/articles/multiple-disqus-threads-on-one-page/
 *
 *  USAGE:
 *
 *       disqus_shortname = 'your_disqus_shortname';
 *       $(document).ready(function() {
 *         $("p").inlineDisqussions(options);
 *       });
 *
 *  See https://github.com/tsi/inlineDisqussions for more info.
 */

// Disqus global vars.
var disqus_shortname;
var disqus_identifier;
var disqus_url;

(function($) {

  var settings = {};

  $.fn.extend({
    inlineDisqussions: function(options) {

      // Set up defaults
      var defaults = {
        identifier: 'disqussion',
        displayCount: true,
        highlighted: false,
        position: 'right',
        linkPosition: 'outside',
        margin: 0,
        background: 'white',
        minWidth: 300,
        maxWidth: 9999,
        path: window.location.pathname,
        permalink: [location.protocol, '//', location.host, location.pathname].join('')
      };

      // Overwrite default options with user provided ones.
      settings = $.extend({}, defaults, options);

      // Append #disqus_thread to body if it doesn't exist yet.
      if ($('#disqussions_wrapper').length === 0) {
        $('<div id="disqussions_wrapper"></div>').appendTo($('body'));
      }
      if ($('#disqus_thread').length === 0) {
        $('<div id="disqus_thread"></div>').appendTo('#disqussions_wrapper');
      }
      else {
        mainThreadHandler();
      }
      if (settings.highlighted) {
        $('<div id="disqussions_overlay"></div>').appendTo($('body'));
      }

      // Attach a discussion to each paragraph.
      $(this).each(function(i) {
        disqussionNotesHandler(i, $(this));
      });

      // Display comments count.
      if (settings.displayCount) {
        loadDisqusCounter();
      }

      // Hide the discussion.
      $('html').click(function(event) {
        if($(event.target).parents('#disqussions_wrapper, .main-disqussion-link-wrp, .disqussion').length === 0) {
          if (!$('.main-disqussion-link').is('.active')) {
            hideDisqussion();
          }
        }
      });

    }
  });

  var disqussionNotesHandler = function(i, node) {

    var identifier;
    // You can force a specific identifier by adding an attribute to the paragraph.
    if (node.attr('data-disqus-identifier')) {
      identifier = node.attr('data-disqus-identifier');
    }
    else {
      while ($('[data-disqus-identifier="' + settings.path + settings.identifier + '-' + i + '"]').length > 0) {
        i++;
      }
      identifier = settings.path + settings.identifier + '-' + i;
    }

    // Create the discussion note.
    var cls = settings.highlighted ? 'disqussion-link disqussion-highlight' : 'disqussion-link';
    var a = $('<a class="' + cls + '" />')
      .attr('href', settings.permalink + '?' + settings.identifier + '='  + i + '#disqus_thread')
      .attr('data-disqus-identifier', identifier)
      .attr('data-disqus-url', settings.permalink + '?' +  settings.identifier + '=' + i)
      .attr('data-disqus-position', settings.position)
      .text('+')
      .wrap('<div class="disqussion" />')
      .parent();
    if (settings.linkPosition == 'inline') {
      a.css({
        'float': settings.position,
        })
       .addClass("inline")
       .insertAfter(node);
    } else { // outside (classic)
      a.appendTo('#disqussions_wrapper')
       .css({
          'top': getBetterTopOffset(node),
          'left': (settings.position == 'right' ?
                                        getBetterLeftOffset(node) + node.outerWidth()
                                      : getBetterLeftOffset(node) - a.outerWidth())
        });
     }

    node.attr('data-disqus-identifier', identifier).mouseover(function() {
        a.addClass("hovered");
    }).mouseout(function() {
        a.removeClass("hovered");
    });

    // Load the relative discussion.
    a.delegate('a.disqussion-link', "click", function(e) {
      e.preventDefault();

      if ($(this).is('.active')) {
        e.stopPropagation();
        hideDisqussion();
      }
      else {
        loadDisqus($(this), function(source) {
          relocateDisqussion(source);
        });
      }

    });

  };

  var mainThreadHandler = function() {

    // Create the discussion note.
    if ($('a.main-disqussion-link').length === 0) {

      var a = $('<a class="main-disqussion-link" />')
        .attr('href', settings.permalink + '#disqus_thread')
        .attr('data-disqus-identifier', disqus_identifier)
        .attr('data-disqus-url', disqus_url)
        .text('Comments')
        .wrap('<h2 class="main-disqussion-link-wrp" />')
        .parent()
        .insertBefore('#disqus_thread');

      // Load the relative discussion.
      a.delegate('a.main-disqussion-link', "click", function(e) {
        e.preventDefault();

        if ($(this).is('.active')) {
          e.stopPropagation();
        }
        else {
          loadDisqus($(this), function(source) {
            relocateDisqussion(source, true);
          });
        }

      });

    }

  };

  var loadDisqus = function(source, callback) {

    disqus_identifier = source.attr('data-disqus-identifier');
    disqus_url = source.attr('data-disqus-url');

    if (window.DISQUS) {
      // If Disqus exists, call it's reset method with new parameters.
      DISQUS.reset({
        reload: true,
        config: function () {
          this.page.identifier = disqus_identifier;
          this.page.url = disqus_url;
        }
      });

    } else {

      // Append the Disqus embed script to <head>.
      var s = document.createElement('script');
      s.type = 'text/javascript';
      s.async = true;
      s.src = '//' + disqus_shortname + '.disqus.com/embed.js';
      $('head').append(s);

    }

    // Add 'active' class.
    $('a.disqussion-link, a.main-disqussion-link').removeClass('active').filter(source).addClass('active');

    // Highlight
    if (source.is('.disqussion-highlight')) {
      highlightDisqussion(disqus_identifier);
    }

    callback(source);

  };

  var loadDisqusCounter = function() {

    // Append the Disqus count script to <head>.
    if (!$('script[src*="disqus.com/count.js"]').length) {
      var s = document.createElement('script');
      s.type = 'text/javascript';
      s.async = true;
      s.src = '//' + disqus_shortname + '.disqus.com/count.js';

      $('head').append(s);

      var limit = 0;
      var timer = setInterval(function() {
        limit++;
        // After script is loaded, show bubles with numbers.
        if (typeof(DISQUSWIDGETS) === 'object') {
          $('.disqussion-link').filter(function() {
            return $(this).text().match(/[1-9]/g);
          }).addClass("has-comments");
          clearInterval(timer);
        }
        // Don't run forever.
        if (limit > 10) {
          clearInterval(timer);
        }
      }, 1000)

    }

  };

  var relocateDisqussion = function(el, main) {

    // Move the discussion to the right position.
    var css = {};
    if (main === true) {
      $('#disqus_thread').removeClass("positioned");
      css = {
        'position': 'static',
        'width': 'auto'
      };
    }
    else {
      $('#disqus_thread').addClass("positioned");
      css = {
        'position': 'absolute'
      };
    }
    css.backgroundColor = settings.background;

    var animate = {};
    if (el.attr('data-disqus-position') == 'right') {
      animate = {
        "top": getBetterTopOffset(el),
        "left": getBetterLeftOffset(el) + el.outerWidth() + settings.margin,
        "width": Math.max(Math.min(parseInt($(window).width() - (el.offset().left + el.outerWidth()), 10),
                                   settings.maxWidth),
                          settings.minWidth)
      };
    }
    else if (el.attr('data-disqus-position') == 'left') {
      animate = {
        "top": getBetterTopOffset(el),
        "left": getBetterLeftOffset(el) - Math.min(parseInt(getBetterLeftOffset(el), 10), settings.maxWidth) - settings.margin,
        "width": Math.max(Math.min(parseInt(el.offset().left, 10), settings.maxWidth),
                          settings.minWidth)
      };
    }

    $('#disqus_thread').stop().fadeIn('fast').animate(animate, "fast").css(css);

    if ($(window).width() <= (animate.left + parseFloat($("body").css("margin-left"))
                                          + $("body").offset().left)) {
        setTimeout(function () {
          $("html, body").animate({
            scrollLeft: animate.left
          }, 'fast');
        }, 200);
    }

  };

  var hideDisqussion = function() {

    $('#disqus_thread').stop().fadeOut('fast');
    $('a.disqussion-link').removeClass('active');
    $('a.main-disqussion-link').removeClass('active');

    // settings.highlighted
    $('#disqussions_overlay').fadeOut('fast');
    $('body').removeClass('disqussion-highlight');
    $('[data-disqus-identifier]').removeClass('disqussion-highlighted');

  };

  var highlightDisqussion = function(identifier) {

    $('body').addClass('disqussion-highlight');
    $('#disqussions_overlay').fadeIn('fast');
    $('[data-disqus-identifier]')
      .removeClass('disqussion-highlighted')
      .filter('[data-disqus-identifier="' + identifier + '"]:not(".disqussion-link")')
      .addClass('disqussion-highlighted');

  };

  var getBetterLeftOffset = function(el) {
    return $(el).offset().left - $('body').offset().left;
  };

  var getBetterTopOffset = function(el) {
    return $(el).offset().top - $('body').offset().top - parseFloat($('body').css('margin-top'));
  };

})(jQuery);
