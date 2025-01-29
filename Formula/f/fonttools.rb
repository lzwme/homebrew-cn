class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https:github.comfonttoolsfonttools"
  url "https:files.pythonhosted.orgpackages55553b1566c6186a5e58a17a19ad63195f87c6ca4039ef10ff5318a1b9fc5639fonttools-4.55.7.tar.gz"
  sha256 "6899e3d97225a8218f525e9754da0376e1c62953a0d57a76c5abaada51e0d140"
  license "MIT"
  head "https:github.comfonttoolsfonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c69c558a079e16a00f8321a563324784db2f4ef89322de833e7054081858e8a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df17d0bc7a1b8763bbb58b046bab027ddf5054d8a388ba00b853163257e837a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "14b44f3bc6d13d3546fc80f010b74397719e2da43bc39d7ace92e9c33bec3f64"
    sha256 cellar: :any_skip_relocation, sonoma:        "799be2a60fe0be404a3014db714ae4e3265d973efdd42f6aaa01057035262b64"
    sha256 cellar: :any_skip_relocation, ventura:       "bd2b4c6622709f2007bb26da16bb2f06a801803fb477daafe83bd0294f97a346"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3db1f3601d5d206ba22e660ccbfb50bc81368b795e9c160816484b561de4d608"
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