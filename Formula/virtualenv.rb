class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/7c/08/cc69e4b3d499ee9570c4c57f23d5e71ed814fcf03988a4edd3081cb74577/virtualenv-20.24.1.tar.gz"
  sha256 "2ef6a237c31629da6442b0bcaa3999748108c7166318d1f55cc9f8d7294e97bd"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c88460c120d65949a8f6f15c8a5e001bb0f34c34f24e912a2f2487e0df06d80e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6e710c269fee656d4a17a293c7348d19ceb7b50b207f4e2f357599cb3ad7dcb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9038ce8c11b3c15ef6156ac06ae015748aef2aa6659d97f839a599a34ee24bce"
    sha256 cellar: :any_skip_relocation, ventura:        "8215a131e3daf5baaea05e5bf940a704be22c28511bc983c8dd52453a4466551"
    sha256 cellar: :any_skip_relocation, monterey:       "77b4111abfacad4718f723982268ce80c59dd7ab6d01b8788f006059de69aead"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6771553b6351f04c118afaef8584370cf69d3ca0c1ab13dc0e6e4f7a309ac51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1af74840d63fed3bbced741ecee14c2e177358f8e410dc0d9a804365dfc3d762"
  end

  depends_on "python@3.11"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/29/34/63be59bdf57b3a8a8dcc252ef45c40f3c018777dc8843d45dd9b869868f0/distlib-0.3.7.tar.gz"
    sha256 "9dafe54b34a028eafd95039d5e5d4851a13734540f1331060d31c9916e7147a8"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/00/0b/c506e9e44e4c4b6c89fcecda23dc115bf8e7ff7eb127e0cb9c114cbc9a15/filelock-3.12.2.tar.gz"
    sha256 "002740518d8aa59a26b0c76e10fb8c6e15eae825d34b6fdf670333fd7b938d81"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/a1/70/c1d14c0c58d975f06a449a403fac69d3c9c6e8ae2a529f387d77c29c2e56/platformdirs-3.9.1.tar.gz"
    sha256 "1b42b450ad933e981d56e59f1b97495428c9bd60698baab9f3eb3d00d5822421"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end