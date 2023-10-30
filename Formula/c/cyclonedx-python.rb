class CyclonedxPython < Formula
  include Language::Python::Virtualenv

  desc "Creates CycloneDX Software Bill of Materials (SBOM) from Python projects"
  homepage "https://cyclonedx.org/"
  url "https://files.pythonhosted.org/packages/42/16/18cc08428819ac1dfe462fb38c4d431298e4940edb23c8b4d468833f7919/cyclonedx_bom-3.11.5.tar.gz"
  sha256 "65589a061be98233fcffcdd2dad70e99999a5ecef6cecff049e2d77f35bb95a1"
  license "Apache-2.0"
  head "https://github.com/CycloneDX/cyclonedx-python.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "160ddc2542877001202fe0e1fedadf4e74f89cdd1ee7dd3eb13326ca0491c5a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f14bc9e204bdc217bb444968ac2aec148f0c19063dad0962394cde47348b7e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d639932d214bf07f06537024c235fbd0206235c119193eeeca6be4c713b1925c"
    sha256 cellar: :any_skip_relocation, sonoma:         "eaa8f9542a4401deaa0a6df9cecb316ceae72f101146cee14b0f1126a102b4fb"
    sha256 cellar: :any_skip_relocation, ventura:        "128a6c5872dbd7c5d542d047fe6b3b6651ae06e7d6dfde8eed132e71e653082e"
    sha256 cellar: :any_skip_relocation, monterey:       "dbb5844ecccdd194e20f0111723003cb4530a2c7cfc5d3c3aad2d5d974cf8913"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5204a8c62b905e9b91dba7ca28abf696819cbdf8b91ae121ffdc9764106e6e90"
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