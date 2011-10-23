###
Renders a 3 column list of recently published libraries
and binds to search queries to api
###
root = exports ? window
$ = jQuery
$ ->
  ls = root.ls()
  self = this
  flatten = (arys) ->
    buf = (buf ?= []).concat(a) for a in arys
    buf

  li = (l) ->
    "<li>
      <h3>
        <a href='/#{l.ghuser}/#{l.ghrepo}\##{l.name}'>#{l.name}<span class='v'>@#{l.versions[0].version}</span></a>
      </h3>
      <div>#{l.description}</div>
     </li>"

  display = (libs) ->
    # produce n lists of of n elements
    # god I <3 coffeescript
    if libs.length
      [c, r] = [2, 3]
      columns = [0..c].map (i) ->
        flatten ['<ul>', (libs[i*r...i*r+r].map (l) -> li l), '</ul>']
      row = flatten(columns)
      $("#libraries").html(row.join(''))
    else
      $("#libraries").html("<div class='none-found'>No published libraries found. You should start one.</div>")


  if window.location.hash.length
    term = window.location.hash.substring(1)
    $("#q").val(term)
    ls.search term, display
  else
    ls.libraries display

  # search box
  $("#q").keyup (e) ->
    q = $.trim($(this).val())
    if q.length > 3
      ls.search q, display
    else if q.length is 0
      ls.libraries display