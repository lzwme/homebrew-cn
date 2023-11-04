class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/6d/f8/d3116b436553856df4ed9094584ac55c5e99ee9d9f3369f2912bbb8d0b90/fonttools-4.44.0.tar.gz"
  sha256 "4e90dd81b6e0d97ebfe52c0d12a17a9ef7f305d6bfbb93081265057d6092f252"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "842c223b25b0a051350cf6d066582f524794eb620e3dd9caa870d746f470182f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85260c0a1df1fbfb6a602599b43a8c22037102ae04ae4ff130c265e7fc70d4cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "405ee1ad6c2c0e49ab70b5366d469404b261a5738a758965b026e1ab46f25a64"
    sha256 cellar: :any_skip_relocation, sonoma:         "53c6220bae481004cd03a4dfefb63b3b20db134467e0fcb86889cf2935dcb1b5"
    sha256 cellar: :any_skip_relocation, ventura:        "2a4256dc08cc27441b06e13ee294ff3b95d0ab5534895d7246004e04bcd52e66"
    sha256 cellar: :any_skip_relocation, monterey:       "4d82429b4781dfb5b562b40f5cb5cafc96fdc04f14a48cbec5ea954cf706739d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2361c6e2e7afb032c75abc8769dec03dd8e337b811d96b4f15f721603b18591"
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