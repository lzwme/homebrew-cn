class PythonBuild < Formula
  include Language::Python::Virtualenv

  desc "Simple, correct PEP 517 build frontend"
  homepage "https://github.com/pypa/build"
  url "https://files.pythonhosted.org/packages/a7/12/fa7bd9f677a2dcc58a395217c221e2a5e5cebd59ddc9756bc4f5fede8719/build-1.4.1.tar.gz"
  sha256 "30adeb28821e573a49b556030d8c84186d112f6a38b12fa5476092c4544ae55a"
  license "MIT"
  head "https://github.com/pypa/build.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "367448fa08fab1c551cf881d38ca672bff3e0ce6fb0949cab8474fa98e289083"
  end

  depends_on "python@3.14"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/65/ee/299d360cdc32edc7d2cf530f3accf79c4fca01e96ffc950d8a52213bd8e4/packaging-26.0.tar.gz"
    sha256 "00243ae351a257117b6a241061796684b084ed1c516a08c48a3f7e147a9d80b4"
  end

  resource "pyproject-hooks" do
    url "https://files.pythonhosted.org/packages/e7/82/28175b2414effca1cdac8dc99f76d660e7a4fb0ceefa4b4ab8f5f6742925/pyproject_hooks-1.2.0.tar.gz"
    sha256 "1e859bd5c40fae9448642dd871adf459e5e2084186e8d2c2a79a824c970da1f8"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    stable.stage do
      system bin/"pyproject-build"
      assert_path_exists Pathname.pwd/"dist/build-#{stable.version}.tar.gz"
      assert_path_exists Pathname.pwd/"dist/build-#{stable.version}-py3-none-any.whl"
    end
  end
end