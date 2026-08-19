class Nift < Formula
  desc "Fast dependency-aware website generator"
  homepage "https://nift.dev/"
  url "https://ghfast.top/https://github.com/nift-dev/nift/archive/refs/tags/v4.0.2.tar.gz"
  sha256 "fe462915db41574a58236c028c34561596751a8e91e868726a18e57210450b14"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f95f70c47075863d33290efbd305d43234a25cbd9c4a40a4af85ead53f62ba2c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b24d66270e4fb8488185d898820ed014ef821def4a245f3a17c67cc2d3f7a545"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "782180da526cd0c4713e4afc675438ba70afe1b9df331527a0ab10d3dce37ad4"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ed63737427ac423a0cfa0a3a4b7df5396d5dbd18e944634027ec3f85c0858ce"
    sha256 cellar: :any,                 arm64_linux:   "9b2690fa780488c1b9445ec52829766bf2cdfd4c4b4693bace21e64ef636c428"
    sha256 cellar: :any,                 x86_64_linux:  "e84cdf62c83d807e48289d6b8bac2b955b1a25be8b2cff69917f48d90920c302"
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