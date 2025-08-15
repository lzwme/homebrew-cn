class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/11/7f/29c9c3fe4246f6ad96fee52b88d0dc3a863c7563b0afc959e36d78b965dc/fonttools-4.59.1.tar.gz"
  sha256 "74995b402ad09822a4c8002438e54940d9f1ecda898d2bb057729d7da983e4cb"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "736e0b2037f328d31f6493e06df6716c096938870d9fd64a35b37910ae76e6b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59577bf0e8cd3787e6a56e9a171c4a4202329230c7e8bb2bb9b2e07f8d8e7bee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3e62cc92cbada24759bd351b4efc53f79abf1c8a34945c20ab7a474c56b07277"
    sha256 cellar: :any_skip_relocation, sonoma:        "24321c00a96cc9f702eef14284d08bee320ff791ca9620890005e4e7723f3489"
    sha256 cellar: :any_skip_relocation, ventura:       "465cdbe060902ff8cc683f859e505efe1433df5f50806393b4d9b76b12d8fb6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d14ac5bcdbcdab296a76bfc642d237bb6c839d42b74886b9ec996a920f61c6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a2693680d882308db31710f7e3c0d87e8db8eaa7909033ab7f5c4a53bdf1ca6"
  end

  depends_on "python@3.13"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/2f/c2/f9e977608bdf958650638c3f1e28f85a1b075f075ebbe77db8555463787b/Brotli-1.1.0.tar.gz"
    sha256 "81de08ac11bcb85841e440c13611c00b67d3bf82698314928d0b676362546724"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/c5/ed/60eb6fa2923602fba988d9ca7c5cdbd7cf25faa795162ed538b527a35411/lxml-6.0.0.tar.gz"
    sha256 "032e65120339d44cdc3efc326c9f660f5f7205f3a535c1fdbf898b29ea01fb72"
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