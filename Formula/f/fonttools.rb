class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https:github.comfonttoolsfonttools"
  url "https:files.pythonhosted.orgpackages515438a74ffda513f6bc3d642dc4fbeeccbd21c2fe4db637b47dd2d1c1bd43bffonttools-4.54.0.tar.gz"
  sha256 "9f3482ff1189668fa9f8eafe8ff8541fb154b6f0170f8477889c028eb893c6ee"
  license "MIT"
  head "https:github.comfonttoolsfonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "513e95668613a05777b8c585987e2d666da15d46a094fb1cb49f524314526008"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5f601aaa6f2beb584f88668a39c16a7d27ef03e6c5c7d292dbd1d85fe4146e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "28f3ad7a7d365a590b62547f506382770f0042741800421e78dbb799ec974584"
    sha256 cellar: :any_skip_relocation, sonoma:        "c68833d51efe8aa480c06114cc19973922c387c82527c80dc69e06a0870a29cb"
    sha256 cellar: :any_skip_relocation, ventura:       "389c6a1307875b82258607d9ab6b9864cfd7cf6bb875a3f3da69a3f7bcb4154b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba1c3afa0c35ccd96f7a62cc88584f94b4e632ad06477c020e17ed444ffa0805"
  end

  depends_on "python@3.12"

  resource "brotli" do
    url "https:files.pythonhosted.orgpackages2fc2f9e977608bdf958650638c3f1e28f85a1b075f075ebbe77db8555463787bBrotli-1.1.0.tar.gz"
    sha256 "81de08ac11bcb85841e440c13611c00b67d3bf82698314928d0b676362546724"
  end

  resource "zopfli" do
    url "https:files.pythonhosted.orgpackages92d871230eb25ede499401a9a39ddf66fab4e4dab149bf75ed2ecea51a662d9ezopfli-0.2.3.zip"
    sha256 "dbc9841bedd736041eb5e6982cd92da93bee145745f5422f3795f6f258cdc6ef"
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