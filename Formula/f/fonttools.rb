class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https:github.comfonttoolsfonttools"
  url "https:files.pythonhosted.orgpackagesf43a6ab28db8f90c99e6b502436fb642912b590c352d5ba83e0b22b46db209dafonttools-4.55.2.tar.gz"
  sha256 "45947e7b3f9673f91df125d375eb57b9a23f2a603f438a1aebf3171bffa7a205"
  license "MIT"
  head "https:github.comfonttoolsfonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94bac5532b2f4f8778a097d82f7e979bd728014842dda53ee70d92fab86e1dbb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb2bc6efd0e08e454c1d88fc24a28b1f2d3f0f9da4cdd147ad7389e8208c82e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "34ea197e4e97243114d37525eb66d796df29f68ba30865c0753870079ecb1f57"
    sha256 cellar: :any_skip_relocation, sonoma:        "b548fb7208f87379c92324fac1b281365ba0b6cce387d2b0d646c1d662a9ce67"
    sha256 cellar: :any_skip_relocation, ventura:       "52d26210f294192328e5ef1650af51bf5e3c26fff358d6b959bbaf3954b577a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f03b99218cb50cc0a520f9a1860ba7a15e208773262b2f3b8f48d356ac6de8db"
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