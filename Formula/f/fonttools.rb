class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https:github.comfonttoolsfonttools"
  url "https:files.pythonhosted.orgpackagesa45361dee750e9652ee0e00384351432adaa871a74fd16eea0038bbc7ed0565cfonttools-4.55.1.tar.gz"
  sha256 "85bb2e985718b0df96afc659abfe194c171726054314b019dbbfed31581673c7"
  license "MIT"
  head "https:github.comfonttoolsfonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eee7791b0eba68bc792de5b30f707f1484fb2e49352fdf20daa59720dc8a808a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1c9989ade45cbdfa988b662961b256dfec2ff8336a024e0032cf93cccc3511d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7895c7ed031da9098ee3a914fa182bbee12397254f118ebfa7a5d1c38146087d"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c51538a2bc4aeb02e8a41005cea60d9d76b5011bb40061cee99701dcabe4029"
    sha256 cellar: :any_skip_relocation, ventura:       "48a1296d79b0080398fd86d7dd515424035ec5fccc245fa046e8a906ef0e4cbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf70cd89e79b4c1a5d28f6c8589573fba5d1e30d40aafba3af915da55c051472"
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