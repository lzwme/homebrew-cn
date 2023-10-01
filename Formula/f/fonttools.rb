class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/8e/97/b285eefe8dd4b030a7e8d216debd4c447110fae7f3934cc0fa999cd93bd5/fonttools-4.43.0.tar.gz"
  sha256 "b62a53a4ca83c32c6b78cac64464f88d02929779373c716f738af6968c8c821e"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bb7864c1bd80e2f7373c9827c23fd8e6619dcd20330fa07b049a312adf50e6b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c987a268e6f3c92880898af1155007bd1221de5061a88c784df488090c3477d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc63d5955e528e4fc79221efd6d504236b64be459fdd08b4e5703306682b4069"
    sha256 cellar: :any_skip_relocation, sonoma:         "d718a0a3347eeab7ef663f646c1f7c57c9131e480421b7986d7d284ee2ca0e36"
    sha256 cellar: :any_skip_relocation, ventura:        "32cafd1b80faf99dbab96b4c18783c06c4e077c350c895d630af480ac409dd4f"
    sha256 cellar: :any_skip_relocation, monterey:       "8c45e9f222428374b6534abca8c7e51e5a45771bac6c96332a6ca7b1b733c13c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1d4b988a05507ded00a9226d410128c3fa3c698b406eeb27c87014e81f723b7"
  end

  depends_on "python@3.11"

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