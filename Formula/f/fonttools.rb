class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https:github.comfonttoolsfonttools"
  url "https:files.pythonhosted.orgpackagesb6a93319c6ae07fd9dde51064ddc6d82a2b707efad8ed407d700a01091121bbcfonttools-4.58.2.tar.gz"
  sha256 "4b491ddbfd50b856e84b0648b5f7941af918f6d32f938f18e62b58426a8d50e2"
  license "MIT"
  head "https:github.comfonttoolsfonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "784ae3d6aaab125ecac9976e4fcd69a3233aa6d1c1e8992d2cb35a12c9169a12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c34c91facf3b6af85a7cadba224d621b5d4c7af3c83e5becee7b252cfb82a94f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2562cf70b7cf4ac4039fc5c2dca977ffdd19a7cb1dd6b92b4f727e6b2c910b3d"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a46dcfb6516a582ee720c97f60a8b883d597e4a77ecf51f12b71f9ae6818a8f"
    sha256 cellar: :any_skip_relocation, ventura:       "2c59c11bb76149872015795e280811ca04369ebae949aa45941d1faff3d6a233"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b30378e8e16e6ba77db859c1b6cfa406292bbaf5dcfa368265fb3c990ffd7a88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3599c8ab5b7c4044c9a2864955f7132c7dc7aed8278463e964692dcb3b1139e5"
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
      assert_path_exists testpath"ZapfDingbats.ttx"
      system bin"fonttools", "ttLib.woff2", "compress", "ZapfDingbats.ttf"
      assert_path_exists testpath"ZapfDingbats.woff2"
    else
      assert_match "usage", shell_output("#{bin}ttx -h")
    end
  end
end