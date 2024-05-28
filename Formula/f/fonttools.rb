class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https:github.comfonttoolsfonttools"
  url "https:files.pythonhosted.orgpackages091ffdc581253a630bf72ea3b031533864e72b66236722eb4f310fdcb6ff386bfonttools-4.52.4.tar.gz"
  sha256 "859399b7adc8ac067be8e5c80ef4bb2faddff97e9b40896a9de75606a43d0469"
  license "MIT"
  head "https:github.comfonttoolsfonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1b4ae5dda5caa078fc0603f2f20adcf1a808cafc02e60c6d8d842182829189e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac96dff538386a12651a3c8bbeb698539f9eeb4df704dfe05d98e2fe8fd6f3c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd7c04a28282cbfe3519a441685cf45f86fc00845fa755c81cf22956ed23af21"
    sha256 cellar: :any_skip_relocation, sonoma:         "d1d4920fa92e3ecd91f62e148595ff1940c454f133c178a5f64cbecb7892a4a0"
    sha256 cellar: :any_skip_relocation, ventura:        "32431368560d9f9406718abf81670b32c53ab13ba430c990d281b4dfa85dad5b"
    sha256 cellar: :any_skip_relocation, monterey:       "b9d2eb13bc7fff58f16c6787623e21656d1ac41bff0c34028b869f65083613e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b5685c3f165df2255dfa4f092b0abcca6e9e8cc0d9e2a5c267928df31e36951"
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