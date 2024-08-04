class Gimme < Formula
  desc "Shell script to install any Go version"
  homepage "https:github.comtravis-cigimme"
  url "https:github.comtravis-cigimmearchiverefstagsv1.5.5.tar.gz"
  sha256 "7854c3f90c2274e14041138f53c9c0bf671be86e49dfb4a61b024270a514fb40"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "915831c18b1257af25c9bfdac53e7ecc2a71de4cec44eaad8fa7f1766d6f45f5"
  end

  def install
    bin.install "gimme"
  end

  test do
    system bin"gimme", "-l"
  end
end