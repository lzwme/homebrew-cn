class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https:github.comfonttoolsfonttools"
  url "https:files.pythonhosted.orgpackagesd74e053fe1b5c0ce346c0a9d0557492c654362bafb14f026eae0d3ee98009152fonttools-4.55.0.tar.gz"
  sha256 "7636acc6ab733572d5e7eec922b254ead611f1cdad17be3f0be7418e8bfaca71"
  license "MIT"
  head "https:github.comfonttoolsfonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f50fef0097b88448238b719a3a757f5a6323ae7b693548f0f3bd4f9f12f7c4da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89e85345c7f90070806c541350fd92ac7ebd1b2cdc59b3dcc3434bde2f905c9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "78a1e9a87205b1298d60d7b441a093fffbe222c9709ee84821a03d06b7e0ebd0"
    sha256 cellar: :any_skip_relocation, sonoma:        "c64956fa85b8d64ea978bdb5691dc9bc89a0ab98826391f22e6bb984beea9b61"
    sha256 cellar: :any_skip_relocation, ventura:       "52540c8cf734b631313e3f23bf10189a5d088f0d2a9332dd1eb10f5f2ba69df5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7ed247ba4a323f732577bff21176d1ca3e593c87f9f617d0cfd209e5b0374b6"
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