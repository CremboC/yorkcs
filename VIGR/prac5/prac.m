s = [0 0 1]'

for i = 1 : size(NM, 1)
    for j = 1 : size(NM, 2)
        shaded(i, j) = dot(s, squeeze(NM(i, j, : )));
    end
end

figure; image(uint8(shaded.*255)); colormap gray(256); axis equal; axis off;