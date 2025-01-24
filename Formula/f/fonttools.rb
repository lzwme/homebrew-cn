class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https:github.comfonttoolsfonttools"
  url "https:files.pythonhosted.orgpackages8bd06a515b1587f2fe3540429120b20c674687e6f5fdd7dbd114f0fca224294bfonttools-4.55.5.tar.gz"
  sha256 "87afe2a1e81a55131bbae66f3f1718b1faee3218b1261abce036d7d189094c36"
  license "MIT"
  head "https:github.comfonttoolsfonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aaf7f2f85868231d9f6677b7d78f5b5af3770790f5e006d55b4b879086f1fb96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72be4e4d43f5ac2268c22e7da33af9c3121ed46e9a28579be7f086d236f21eeb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e1ddc60e59d162578575c8a1960d5285d909e6294910fbab3a612bddbf3ebdfd"
    sha256 cellar: :any_skip_relocation, sonoma:        "b62724aad93acd7b4a4ad94babc8f4056be58025e8b1190c03287596884e695d"
    sha256 cellar: :any_skip_relocation, ventura:       "4f0aedb4696440934450c1a11eb242d94099b9e81f322835c654733035b9ac16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d688c8f39af03ccf66639e79b77ebda10edbef0b7ea3d137c27b1444872a7805"
  end

  depends_on "python@3.13"

  resource "brotli" do
    url "https:files.pythonhosted.orgpackages2fc2f9e977608bdf958650638c3f1e28f85a1b075f075ebbe77db8555463787bBrotli-1.1.0.tar.gz"
    sha256 "81de08ac11bcb85841e440c13611c00b67d3bf82698314928d0b676362546724"
  end

  resource "zopfli" do
    url "https:files.pythonhosted.orgpackages5e7ca8f6696e694709e2abcbccd27d05ef761e9b6efae217e11d977471555b62zopfli-0.2.3.post1.tar.gz"
    sha256 "96484dc0f48be1c5d7ae9f38ed1ce41e3675fd506b27c11a6607f14b49101e99"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    if OS.mac?
      cp "SystemLibraryFontsZapfDingbats.ttf", testpath

      system bin"ttx", "ZapfDingbats.ttf"
      assert_predicate testpath"ZapfDingbats.ttx", :exist?
      system bin"fonttools", "ttLib.woff2", "compress", "ZapfDingbats.ttf"
      assert_predicate testpath"ZapfDingbats.woff2", :exist?
    else
      assert_match "usage", shell_output("#{bin}ttx -h")
    end
  end
end