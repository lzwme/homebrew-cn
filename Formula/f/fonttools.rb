class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/5e/a0/0f43f43d4ed5b6d0f2b9d79efe15135b5e0f2f628decf6c72fe5710d7af6/fonttools-4.44.1.tar.gz"
  sha256 "0d8ed83815a125b25c10404736a2cd43d60eb6479fe2d68373418cd1822ec330"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "35d19ac41152d0f95214f02cbe67c0707f8bd91b9f0b287f7e45b17e3e30331d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "64f7ac359cf6c306b09dad484b5627f5b9cdec7dd8996a88f83040b1a72763e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7efedc6c9ed3718cfd48d4c5e59cb41df7de1fa71de3afdf836a6e44e57c605"
    sha256 cellar: :any_skip_relocation, sonoma:         "a5449264955836de138435a2f0c2decd016429cb07375e48075bc855b7b71924"
    sha256 cellar: :any_skip_relocation, ventura:        "6df3a3b8e2f4ba6498ffcc8fababa02bdbedccb9872903d6fd2c54e9e2416723"
    sha256 cellar: :any_skip_relocation, monterey:       "23c7104e5ccc610facf22129d28abbb133a155a72fb455b4dae28a6e4e3da8d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4071f43162251cefb77a972e0e57b2da3e381c8a2940edee3e4ed5b198badd05"
  end

  depends_on "python@3.12"

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/2f/c2/f9e977608bdf958650638c3f1e28f85a1b075f075ebbe77db8555463787b/Brotli-1.1.0.tar.gz"
    sha256 "81de08ac11bcb85841e440c13611c00b67d3bf82698314928d0b676362546724"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    if OS.mac?
      cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath
      system bin/"ttx", "ZapfDingbats.ttf"
      system bin/"fonttools", "ttLib.woff2", "compress", "ZapfDingbats.ttf"
    else
      assert_match "usage", shell_output("#{bin}/ttx -h")
    end
  end
end