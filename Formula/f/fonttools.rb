class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/0d/a5/fba25f9fbdab96e26dedcaeeba125e5f05a09043bf888e0305326e55685b/fonttools-4.59.2.tar.gz"
  sha256 "e72c0749b06113f50bcb80332364c6be83a9582d6e3db3fe0b280f996dc2ef22"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ef2d329ebe6b954a67e1d7d8c94f1695c139f3889e2c0881b7a053a3a686c7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0beb7bb33e0e16ea366002ae97a733ac0dbeb6e3a4561c8e60d41a3c3354780c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3552dd3680945c10807aa4bad4b340bb9a9a5001b762cd868d37a95f6c436942"
    sha256 cellar: :any_skip_relocation, sonoma:        "105e29f487373e8ba751a56530aa4c8cabcd7a1718c83b57621d5e62b5b00568"
    sha256 cellar: :any_skip_relocation, ventura:       "2234c8d457afbb9d36e6aff013362ea2f674af704ffc3f56fa6e987cf9197b24"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ade496b500cb9064faf0888bbc01750a6b67144adf46f733c7c9fbab757a4dbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21bf8c84ebe14d74fe195150be90ceca99b8d486738bab3332eb542f98042db0"
  end

  depends_on "python@3.13"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/2f/c2/f9e977608bdf958650638c3f1e28f85a1b075f075ebbe77db8555463787b/Brotli-1.1.0.tar.gz"
    sha256 "81de08ac11bcb85841e440c13611c00b67d3bf82698314928d0b676362546724"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/8f/bd/f9d01fd4132d81c6f43ab01983caea69ec9614b913c290a26738431a015d/lxml-6.0.1.tar.gz"
    sha256 "2b3a882ebf27dd026df3801a87cf49ff791336e0f94b0fad195db77e01240690"
  end

  resource "zopfli" do
    url "https://files.pythonhosted.org/packages/5e/7c/a8f6696e694709e2abcbccd27d05ef761e9b6efae217e11d977471555b62/zopfli-0.2.3.post1.tar.gz"
    sha256 "96484dc0f48be1c5d7ae9f38ed1ce41e3675fd506b27c11a6607f14b49101e99"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    if OS.mac?
      cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath

      system bin/"ttx", "ZapfDingbats.ttf"
      assert_path_exists testpath/"ZapfDingbats.ttx"
      system bin/"fonttools", "ttLib.woff2", "compress", "ZapfDingbats.ttf"
      assert_path_exists testpath/"ZapfDingbats.woff2"
    else
      assert_match "usage", shell_output("#{bin}/ttx -h")
    end
  end
end