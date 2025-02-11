class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https:virtualenv.pypa.io"
  url "https:files.pythonhosted.orgpackagesf188dacc875dd54a8acadb4bcbfd4e3e86df8be75527116c91d8f9784f5e9cabvirtualenv-20.29.2.tar.gz"
  sha256 "fdaabebf6d03b5ba83ae0a02cfe96f48a716f4fae556461d180825866f75b728"
  license "MIT"
  head "https:github.compypavirtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6cc974e506610e8f9be4f08735ca5e2a93968b9552b500ed9e1fc26cad4468b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6cc974e506610e8f9be4f08735ca5e2a93968b9552b500ed9e1fc26cad4468b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6cc974e506610e8f9be4f08735ca5e2a93968b9552b500ed9e1fc26cad4468b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9df836255af453b6249cc72e8fd7e326be7114043b7280f30cf91ac38f20706"
    sha256 cellar: :any_skip_relocation, ventura:       "c9df836255af453b6249cc72e8fd7e326be7114043b7280f30cf91ac38f20706"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2558af06383e70c528eba40ea120ed3149f313e969f7603682ae26859bc6ad5d"
  end

  depends_on "python@3.13"

  resource "distlib" do
    url "https:files.pythonhosted.orgpackages0ddd1bec4c5ddb504ca60fc29472f3d27e8d4da1257a854e1d96742f15c1d02ddistlib-0.3.9.tar.gz"
    sha256 "a60f20dea646b8a33f3e7772f74dc0b2d0772d2837ee1342a00645c81edf9403"
  end

  resource "filelock" do
    url "https:files.pythonhosted.orgpackagesdc9c0b15fb47b464e1b663b1acd1253a062aa5feecb07d4e597daea542ebd2b5filelock-3.17.0.tar.gz"
    sha256 "ee4e77401ef576ebb38cd7f13b9b28893194acc20a8e68e18730ba9c0e54660e"
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