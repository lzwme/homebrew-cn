class Inputsourceselector < Formula
  desc "Utility program to manipulate Input Sources on Mac OS X"
  homepage "https://github.com/minoki/InputSourceSelector"
  url "https://ghfast.top/https://github.com/minoki/InputSourceSelector/archive/7f655017d16ad9f345d36ccaeec11e0a607cb6a1.tar.gz"
  version "2014-12-30"
  sha256 "d09e398ba9758dc8adcf60b47742e706773561ade0af211dc9ad9f7f943340c0"
  license ""

  def install
    system "make"
    bin.install "InputSourceSelector"
  end

  test do
    system bin/"InputSourceSelector", "current"
  end
end