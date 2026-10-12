class Py7zr < Formula
  include Language::Python::Virtualenv

  desc "7-zip in Python"
  homepage "https://github.com/miurahr/py7zr"
  url "https://files.pythonhosted.org/packages/59/3f/ac248f25f3901d3d6cf80ac99d5bac6fd1e5e6543c1812c79b02b6074c60/py7zr-1.1.3.tar.gz"
  sha256 "8d51894abb38355bf14881088bb97f01fe4cb5b14ebe22f66d6297668c7e1a74"
  license "LGPL-2.1-or-later"
  head "https://github.com/miurahr/py7zr.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5b8acf0d36338f192a0a9c3ef1a4e46d3aee1df3c3a9998f1bb268f391548ef8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "713463cbf015aca58057cbc94c2c655da7cd80610574d894da6f77fd17769f13"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e34f3fc7e8dc45dcd03fcfa89b71973401f0d415a8344cf8318b6de97299887c"
    sha256 cellar: :any,                 arm64_linux:       "605e1b0c0dd4846a85a7b1c90726e3e0c0f4f92afd9c6f1a03617fb69883a197"
    sha256 cellar: :any,                 x86_64_linux:      "0256a847dc6be97d5888db3fd42f4600f5276c4a300c9b6082562cb4a6889995"
  end

  depends_on "python@3.15"

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/f7/16/c92ca344d646e71a43b8bb353f0a6490d7f6e06210f8554c8f874e454285/brotli-1.2.0.tar.gz"
    sha256 "e310f77e41941c13340a95976fe66a8a95b01e783d430eeaf7a2f87e0a57dd0a"
  end

  resource "inflate64" do
    url "https://files.pythonhosted.org/packages/3e/f3/41bb2901543abe7aad0b0b0284ae5854bb75f848cf406bf8a046bf525f67/inflate64-1.0.4.tar.gz"
    sha256 "b398c686960c029777afc0ed281a86f66adb956cfc3fbf6667cc6453f7b407ce"
  end

  resource "multivolumefile" do
    url "https://files.pythonhosted.org/packages/50/f0/a7786212b5a4cb9ba05ae84a2bbd11d1d0279523aea0424b6d981d652a14/multivolumefile-0.2.3.tar.gz"
    sha256 "a0648d0aafbc96e59198d5c17e9acad7eb531abea51035d08ce8060dcad709d6"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  resource "pybcj" do
    url "https://files.pythonhosted.org/packages/14/c9/e2de4f98c21f2ff9e58047395b6a8e17701a0f2977f0e63f80948f61647f/pybcj-1.0.8.tar.gz"
    sha256 "6818270692912d47e81ccd777b7d0ed2ad3a19ef7aaead3735b38048c80bf368"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/4c/25/214ea825a9031f5af2c8b2506ee16701a2560d4712165dd00098dd527bcb/pycryptodomex-3.24.0.tar.gz"
    sha256 "0428f19f13452c6b89bbaf2c530f84f369873811dfa77f0cee0da4f40fb0474f"
  end

  resource "pyppmd" do
    url "https://files.pythonhosted.org/packages/81/d7/803232913cab9163a1a97ecf2236cd7135903c46ac8d49613448d88e8759/pyppmd-1.3.1.tar.gz"
    sha256 "ced527f08ade4408c1bfc5264e9f97ffac8d221c9d13eca4f35ec1ec0c7b6b2e"
  end

  resource "texttable" do
    url "https://files.pythonhosted.org/packages/1c/dc/0aff23d6036a4d3bf4f1d8c8204c5c79c4437e25e0ae94ffe4bbb55ee3c2/texttable-1.7.0.tar.gz"
    sha256 "2d2068fb55115807d3ac77a4ca68fa48803e84ebb0ee2340f858107a36522638"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/py7zr --version")

    (testpath/"test.txt").write("Homebrew")
    system bin/"py7zr", "c", "test.7z", "test.txt"
    rm testpath/"test.txt"
    assert_match "Everything is Ok", shell_output("#{bin}/py7zr t test.7z")
    system bin/"py7zr", "x", "test.7z"
    assert_path_exists testpath/"test.txt"
  end
end