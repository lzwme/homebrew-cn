class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/8a/27/ec3c723bfdf86f34c5c82bf6305df3e0f0d8ea798d2d3a7cb0c0a866d286/fonttools-4.59.0.tar.gz"
  sha256 "be392ec3529e2f57faa28709d60723a763904f71a2b63aabe14fee6648fe3b14"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "730dd45f621a79d6d618875807196eb53a99c0cb1c5de5de0cdc1e36e1fa52fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99f3624462aa2f63d08a5bed43735269095f622c198e97af27b456a56ff82f4d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dcbb429c3aa8813876e66c6f164fbaf6a77c103481c2d59521f90bcdbae7257a"
    sha256 cellar: :any_skip_relocation, sonoma:        "82377dbee95736437b0ebb4d5f12617109b37e5f410ea4ab9beb70bde6e6b463"
    sha256 cellar: :any_skip_relocation, ventura:       "2254acb738f2c83f6fc96db75c217785eaac550a2fe7ca0bb12d4940baab862b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc590050f61f7de17e25c6ff945eedf803de9d15d095225be324bbc01dd131c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fa38bc2e58b59c174ec579c91336d8882bb6b90683922b977469d05a4cb1394"
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