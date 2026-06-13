class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/4b/50/7564c805bb8966d9771caaba8a143fa5e57c848ce4e7fdf2d55a1feb2ead/virtualenv-21.4.3.tar.gz"
  sha256 "938ff0fd3f4e0f0d3a025f67a3d2f25e3c3aabbcd5857ea6170619138d72d141"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2c8b0aa5d52e23d4d93f5b35573b6590aa2ec1456f45c31816bcaf2730bb5c6b"
  end

  depends_on "python@3.14"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/46/8d/873e9252ea2c0e0c857884e0a2899ec43ade132345df1925ef24cbe64f18/distlib-0.4.2.tar.gz"
    sha256 "baeb401c90f27acd15c4861ae0847d1e731c27ac3dbf4210643ba61fa1e813db"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/91/f5/3557bf28e0f1943e4849154c821533706e6dea010f96fb6aa0b6949037d1/filelock-3.29.3.tar.gz"
    sha256 "7fc1b3f39cf172fd8203812043c57b8a65aef9969f38b6704f628b881f761a84"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d7/47/e4501f49c178ae1d9f4a75073fda4204f52647993f075a9db4d14930e0c5/platformdirs-4.10.0.tar.gz"
    sha256 "31e761a6a0ca04faf7353ea759bdba55652be214725111e5aac52dfa29d4bef7"
  end

  resource "python-discovery" do
    url "https://files.pythonhosted.org/packages/0b/1a/cbbaf13b730abb0a16b964d984e19f2fe520c21a4dc664051359a3f5a9e7/python_discovery-1.4.2.tar.gz"
    sha256 "8f3746c4b4968d22afbb97d36e1a0e5b66e6c0f297290f2e95f05b9b8bf18690"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end