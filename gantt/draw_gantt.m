function draw_gantt (filename)

height_step = 1;
line_width = 1;

if (! ischar (filename))
  error ("draw_gantt: you should provide a filename as input");
else
  # Here I assume the structure of my gantt.csv, I don't like it
  # very much, but otherwise it's a mess
  [phases, ~, nodes, start, finish] = ...
    textread (filename, "%s %s %s %d %d", "delimiter", ",", "headerlines", 1);
  
  figure;
  phase_names = unique (phases);
  half = ceil (numel (phase_names) / 2);
  colors = lines (half);
  colors = [colors; (1 - colors)];
  idx = zeros (1, 2 * half);
  for (ii = 1:half)
    idx(2 * ii - 1) = ii;
    idx(2 * ii) = half + ii;
  endfor
  colors = colors(idx, :);
  
  already_in_legend = zeros (size (phase_names));
  
  # This is to avoid warnings for horizontal lines
  axis ([0 10 0 5]);
  max_height = 0;
  heights = struct ();
  hold on;
  for (ii = 1:numel (start))
    node = nodes{ii};
    if (isfield (heights, node))
      height = heights.(node);
    else
      height = max_height + height_step;
      max_height = height;
      heights.(node) = height;
    endif
    
    x = [start(ii) finish(ii)];
    y = height * ones (size (x));
    
    idx = find (strcmp (phase_names, phases{ii}));
    if (already_in_legend(idx))
      plot (x, y, "color", colors(idx, :), "linewidth", line_width);
    else
      plot (x, y, "color", colors(idx, :), "linewidth", line_width , "DisplayName", phase_names{idx});
      already_in_legend(idx) = true;
    endif
  endfor
  grid on;
  axis ("tight");
  
  # This to workaround a bug
  legend (phase_names{1}, "location", "northwest");
  hold off;
endif

endfunction
