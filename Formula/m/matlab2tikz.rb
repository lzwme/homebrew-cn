class Matlab2tikz < Formula
  desc "Convert MATLAB(R) figures into TikZPgfplots figures"
  homepage "https:github.commatlab2tikzmatlab2tikz"
  url "https:github.commatlab2tikzmatlab2tikzarchiverefstagsv1.1.0.tar.gz"
  sha256 "4e6fe80ebe4c8729650eb00679f97398c2696fd9399c17f9c5b60a1a6cf23a19"
  license "BSD-2-Clause"
  head "https:github.commatlab2tikzmatlab2tikz.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "f76f11ee806e2256f088b5dd34b534e94e8bfd48f495152bb623d7519dc2b893"
  end

  def install
    pkgshare.install Dir["src*"]
  end
end