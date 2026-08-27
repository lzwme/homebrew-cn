class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/1d/60/fc54e876e34f94dd0cf0185aaecfd4bfa906653f003d9b2fb21428642fca/virtualenv-21.7.5.tar.gz"
  sha256 "a73c4246fba3c8901ff9717399f466e00eeca5a3834981f1a6ebb4f1e94de2f8"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "16b230d0b546592a8d7ff12e5b2c29e6c45a56fec75660a0ada8c0ceb003424e"
  end

  depends_on "python@3.14"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/c9/02/bd72be9134d25ed783ecbbc38a539ffaefbf90c78418c7fb7229600dbac7/distlib-0.4.3.tar.gz"
    sha256 "f152097224a0ae24be5a0f6bae1b9359af82133bce63f98a95f86cae1aede9ed"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/6d/30/03b03951873a1a0ffc7e8ca0e10c15597b59e8d0e39260704cd2ea087bc4/filelock-3.32.4.tar.gz"
    sha256 "2bde2e4cf732e0153406d8a7bc80620ecf5e621fe0d25e41143c4e3b4733ff30"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/50/bb/ebc6636e1ae41314f796ebb7215fd28febb45f9aac72f2b04cb74b5071dc/platformdirs-4.11.4.tar.gz"
    sha256 "f3373be828247211d0febabea97e238c3dfde8a60b3c90c32756fb52cb21556d"
  end

  resource "python-discovery" do
    url "https://files.pythonhosted.org/packages/b2/8f/3c92c45737f654f2488ab3662b7604a55d3d35146d37c9ce80f5c95b95a6/python_discovery-1.5.3.tar.gz"
    sha256 "e500eb24025fb7c4876c1fdcfbafd9028a10c71b661aee38cb6fb0de594518c1"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end