class Nift < Formula
  desc "Fast dependency-aware website generator"
  homepage "https://nift.dev/"
  url "https://ghfast.top/https://github.com/nift-dev/nift/archive/refs/tags/v4.0.1.tar.gz"
  sha256 "0724c8e6518ea9ace4275e8f96da39680916d157df1afb4bfbb003678bcdfb52"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "90590e45d95cc349fcfa513c0b3a0b13e04cace7270c4100743767bdfc1633b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6f9aad83143eb3b250b7234ad6007a6e4e98c11fe19f24ffb5470cac79d38e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e54d756c2ff0a7c16551ab862e8b7502b713bde516213ad04416c8e8a302c1f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f8e50fde2e1bf8d6091dfa4e8ebb195952e3606d4039c72efceb98046415c27"
    sha256 cellar: :any,                 arm64_linux:   "06bf69b0f3c5d5ce64f8f9bbbbed0a5b71c44f6924c4e04f25e81b900970db30"
    sha256 cellar: :any,                 x86_64_linux:  "6535c5f0d97d700b982c690ed46ccfedf05ac68748e40a9e76e679dd4bbe780c"
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"nift", "init", ".html"
    assert_path_exists testpath/"public/index.html"
  end
end