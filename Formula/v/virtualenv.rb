class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https:virtualenv.pypa.io"
  url "https:files.pythonhosted.orgpackagesbf4c66ce54c8736ff164e85117ca36b02a1e14c042a6963f85eeda82664fda4evirtualenv-20.26.5.tar.gz"
  sha256 "ce489cac131aa58f4b25e321d6d186171f78e6cb13fafbf32a840cee67733ff4"
  license "MIT"
  head "https:github.compypavirtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d0b8098bba05840995c83981b5a832582545b0977bcc2899f86c5be715b3c27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d0b8098bba05840995c83981b5a832582545b0977bcc2899f86c5be715b3c27"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1d0b8098bba05840995c83981b5a832582545b0977bcc2899f86c5be715b3c27"
    sha256 cellar: :any_skip_relocation, sonoma:        "65e9b0118f897feb4df9817a4bf7fcfa7b034a39c9fc67686e87733fe3c3a5fd"
    sha256 cellar: :any_skip_relocation, ventura:       "65e9b0118f897feb4df9817a4bf7fcfa7b034a39c9fc67686e87733fe3c3a5fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d00162780cb94c82744f33ec7e27e40c2a83c5f7a436e6b8a58d78e6e9ccd29d"
  end

  depends_on "python@3.12"

  resource "distlib" do
    url "https:files.pythonhosted.orgpackagesc491e2df406fb4efacdf46871c25cde65d3c6ee5e173b7e5a4547a47bae91920distlib-0.3.8.tar.gz"
    sha256 "1530ea13e350031b6312d8580ddb6b27a104275a31106523b8f123787f494f64"
  end

  resource "filelock" do
    url "https:files.pythonhosted.orgpackages9ddb3ef5bb276dae18d6ec2124224403d1d67bccdbefc17af4cc8f553e341ab1filelock-3.16.1.tar.gz"
    sha256 "c249fbfcd5db47e5e2d6d62198e565475ee65e4831e2561c8e313fa7eb961435"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackages13fc128cc9cb8f03208bdbf93d3aa862e16d376844a14f9a0ce5cf4507372de4platformdirs-4.3.6.tar.gz"
    sha256 "357fb2acbc885b0419afd3ce3ed34564c13c9b95c89360cd9563f73aa5e2b907"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin"virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dirbinpython -c 'import sys; print(sys.prefix)'")
  end
end