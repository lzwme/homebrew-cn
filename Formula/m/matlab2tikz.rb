class Matlab2tikz < Formula
  desc "Convert MATLAB(R) figures into TikZPgfplots figures"
  homepage "https:github.commatlab2tikzmatlab2tikz"
  url "https:github.commatlab2tikzmatlab2tikzarchiverefstagsv1.1.0.tar.gz"
  sha256 "4e6fe80ebe4c8729650eb00679f97398c2696fd9399c17f9c5b60a1a6cf23a19"
  license "BSD-2-Clause"
  head "https:github.commatlab2tikzmatlab2tikz.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e798fd3ffe10d075bc3d1c25838630d2cac7cea104eac0af823b5d91c8c50854"
  end

  def install
    pkgshare.install Dir["src*"]
  end
end