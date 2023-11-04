class CyclonedxPython < Formula
  include Language::Python::Virtualenv

  desc "Creates CycloneDX Software Bill of Materials (SBOM) from Python projects"
  homepage "https://cyclonedx.org/"
  url "https://files.pythonhosted.org/packages/df/f5/6057f76ca661ec89d14241a3181ec85d2c46bb47f7996298d04857b919b2/cyclonedx_bom-3.11.7.tar.gz"
  sha256 "656a6df47511abff82c159dfa947a6f881ec971d1b9861ec14802bc50bc29e05"
  license "Apache-2.0"
  head "https://github.com/CycloneDX/cyclonedx-python.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "31a8b997e812f5e465106af492237848a31b7d467342489898d0fce442d5ca51"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79332f5e089da9655f5a8463193d101c3d9773fd0c0fb80ababbae5f277e8a4a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70e80bd4018d958ba3fe0f5de84c077d939bcc26e8d427822b06dcd8f8b8c855"
    sha256 cellar: :any_skip_relocation, sonoma:         "b063b3f7bc844df99e2b8a443a3c99b93531b3b143f0c03a4678d84a9c204788"
    sha256 cellar: :any_skip_relocation, ventura:        "9c2e2dad3ab2ef5cb5fd43f4eef77d09e1ff7836d727c8148b3222902697470c"
    sha256 cellar: :any_skip_relocation, monterey:       "7150c6c84fbf72e06e33095592318052e7cb4a16e812fb483003dbe8c4452591"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f1f1e3a4e87a04f77551c5d05b68816c4ca9af26ea49577a9ea84a6c9ff13fe"
  end

  depends_on "python-packaging"
  depends_on "python-pyparsing"
  depends_on "python-setuptools"
  depends_on "python-toml"
  depends_on "python@3.12"

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "cyclonedx-python-lib" do
    url "https://files.pythonhosted.org/packages/dd/0d/2d77978ff3ebe445c00ffc209eb205d126ef7a8ece69e7f3d014e561bada/cyclonedx_python_lib-3.1.5.tar.gz"
    sha256 "1ccd482024a30b95c4fffb3fe567a9df97b705f34c1075f8abde8537867600c3"
  end

  resource "packageurl-python" do
    url "https://files.pythonhosted.org/packages/33/34/a7843f732e1e0b01e961f6ae835b3fd6bd4e361c1a3a72debd31244cb718/packageurl-python-0.11.2.tar.gz"
    sha256 "01fbf74a41ef85cf413f1ede529a1411f658bda66ed22d45d27280ad9ceba471"
  end

  resource "pip-requirements-parser" do
    url "https://files.pythonhosted.org/packages/5e/2a/63b574101850e7f7b306ddbdb02cb294380d37948140eecd468fae392b54/pip-requirements-parser-32.0.1.tar.gz"
    sha256 "b4fa3a7a0be38243123cf9d1f3518da10c51bdb165a2b2985566247f9155a7d3"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/e8/c4/ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111/sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"requirements.txt").write <<~EOS
      requests==2.31.0
    EOS
    system bin/"cyclonedx-py", "-r", "-i", testpath/"requirements.txt"
    assert_match "pkg:pypi/requests@2.31.0", (testpath/"cyclonedx.xml").read
  end
end