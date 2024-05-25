class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https:github.comfonttoolsfonttools"
  url "https:files.pythonhosted.orgpackages50039ed44d1844d60f8c923840aab8fb2ef769ba7e11deb25e0f91803f63a385fonttools-4.52.1.tar.gz"
  sha256 "8c9204435aa6e5e9479a5ba4e669f05dea28b0c61958e0c0923cb164296d9329"
  license "MIT"
  head "https:github.comfonttoolsfonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "08c23a4f8ca27475ac88da70515d5d62ca12c0e458d9ad14a18c4ce79e1b001b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "49bacdeca53405f0823443a5941f54871f83173a5686d5cb5ec8c84eb839f1e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6eeadb61344c60328d29e0206823db81609a27a30f340147d59b0bb7a8871ea"
    sha256 cellar: :any_skip_relocation, sonoma:         "06381f7115783134cfdf55527a00b9b3a63c54a6e384329b49c8ca199f0f6860"
    sha256 cellar: :any_skip_relocation, ventura:        "d6dc5232486460944ef99e20fd414a27a748c05082a1609e8ab2227b2f0fe2b1"
    sha256 cellar: :any_skip_relocation, monterey:       "be3efad84ca3ffba43a4ca934f48116be7167f27bd8974776f162723530d6264"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4556251169af13bb7f9057105885e5fc0ce4039349623dd9be806ad073ae3765"
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