class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https:github.comfonttoolsfonttools"
  url "https:files.pythonhosted.orgpackages111d70b58e342e129f9c0ce030029fb4b2b0670084bbbfe1121d008f6a1e361cfonttools-4.54.1.tar.gz"
  sha256 "957f669d4922f92c171ba01bef7f29410668db09f6c02111e22b2bce446f3285"
  license "MIT"
  head "https:github.comfonttoolsfonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "547cc7fa352c17eaf56b471cb6d8017e42c374ccf194e34832153384f6f41b8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81ecdfabd98cfd41453c5e4d413e2cc0b531c36f3ede68dcb62291c2b90d32da"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "261ee9640f02c3e0ab908dbc9dc64e7368142f213a51e2529f0e886af5093a43"
    sha256 cellar: :any_skip_relocation, sonoma:        "542f3fb9fc5d65f6188b1cc4eafb3fe2430b8d1257dd44ac11d24e81102cb2cd"
    sha256 cellar: :any_skip_relocation, ventura:       "a7a4fcb65cbc9bd024b712ebc11b4ced3bed1eb94b59dd545a6964f05dd6d363"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d6473b1ce2ae00ef7427679b108fb339ddf90e4795910a75fbaf7e60cd461f1"
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