// Methods

{
  rect(width, height):: {
    width: width,
    height: height,
    area(): self.width * self.height,
    perim(): 2 * self.width + 2 * self.height,
  },

  local rectangle = self.rect(10, 5),

  area: rectangle.area(),
  perim: rectangle.perim(),
}
