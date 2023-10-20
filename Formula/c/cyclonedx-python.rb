class CyclonedxPython < Formula
  include Language::Python::Virtualenv

  desc "Creates CycloneDX Software Bill of Materials (SBOM) from Python projects"
  homepage "https://cyclonedx.org/"
  url "https://files.pythonhosted.org/packages/06/b1/0f1757cf1e790d5af7dab11360de661b17ff57dfe15874970991062011e5/cyclonedx_bom-3.11.4.tar.gz"
  sha256 "c3f129674a96975058ae5ae3010ed136514d40a7f1d0372909d696ebb80b813c"
  license "Apache-2.0"
  head "https://github.com/CycloneDX/cyclonedx-python.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9cd3d725903a4eb61aaff2c96af2b3bfce95384d4ad7513506541ba71b4cf1ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "42802c3890a07cb7a6ab67e4813526b9bff5c50b2052bb281d4468120d84311e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd0a1008f4f173f2abf0001ce9b740ec3089745ea23f3b5612bf1796a3db95b1"
    sha256 cellar: :any_skip_relocation, sonoma:         "1839ae7dfe47fb4ff1ada0c2873ba7cc80edfdf096976de104b0883cf75fbf7e"
    sha256 cellar: :any_skip_relocation, ventura:        "d4a8420abd124cab261d7f5084b224f76fb99f16e0f26bc3bf0813ca1484659b"
    sha256 cellar: :any_skip_relocation, monterey:       "6fcb4204bc12b4aad0818aca79c80f9aa7dfb921e79621d954a521925c684328"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fc39f34061f9cf4947075cfe1b200dff1d1cdcd64d49ee126689b6056bd59b8"
  end

  depends_on "python-packaging"
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

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/37/fe/65c989f70bd630b589adfbbcd6ed238af22319e90f059946c26b4835e44b/pyparsing-3.1.1.tar.gz"
    sha256 "ede28a1a32462f5a9705e07aea48001a08f7cf81a021585011deba701581a0db"
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