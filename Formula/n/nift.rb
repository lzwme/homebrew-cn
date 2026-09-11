class Nift < Formula
  desc "Fast dependency-aware website generator"
  homepage "https://nift.dev/"
  url "https://ghfast.top/https://github.com/nift-dev/nift/archive/refs/tags/v4.0.12.tar.gz"
  sha256 "04ce19498fd3e5da8c7e065082065508f3c9b4d486ad1d808dcc33671c74c6ab"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8144a357699454dcf55e96b6dab3429ca774d0fcacd028732bea15f5ec162fc0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d19982657045331e263e7acfcfaf558cb5b51929d523dca77c3170a092e9a418"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0277470eb634d36d78f605a4529b4e39e2c246d3e57a41d11814648d785d14f1"
    sha256 cellar: :any,                 arm64_linux:   "625dda734ffe23a88311af70e2222049f35ad2491393d15a003afa7167f690f0"
    sha256 cellar: :any,                 x86_64_linux:  "f4b38bf3fb2d506579079ded3ba16030dbd04dc0919ce4f1e3e762e2bfa34853"
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"nift", "init", "--ext=.html"
    assert_path_exists testpath/"public/index.html"
  end
end