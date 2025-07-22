class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/a9/96/0834f30fa08dca3738614e6a9d42752b6420ee94e58971d702118f7cfd30/virtualenv-20.32.0.tar.gz"
  sha256 "886bf75cadfdc964674e6e33eb74d787dff31ca314ceace03ca5810620f4ecf0"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b160a493635e85c78293094b71401d1d82bd5367d5c74ecd785797e51df187ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b160a493635e85c78293094b71401d1d82bd5367d5c74ecd785797e51df187ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b160a493635e85c78293094b71401d1d82bd5367d5c74ecd785797e51df187ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1b64bce8101e3bd848511c9a560f333b60a2f3bf742f884aa4f66c8496c0a5f"
    sha256 cellar: :any_skip_relocation, ventura:       "c1b64bce8101e3bd848511c9a560f333b60a2f3bf742f884aa4f66c8496c0a5f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1837ab8bc753c1110bf9c912c605317ff955d9649ee86fe288f14baee8760b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1837ab8bc753c1110bf9c912c605317ff955d9649ee86fe288f14baee8760b8"
  end

  depends_on "python@3.13"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/96/8e/709914eb2b5749865801041647dc7f4e6d00b549cfe88b65ca192995f07c/distlib-0.4.0.tar.gz"
    sha256 "feec40075be03a04501a973d81f633735b4b69f98b05450592310c0f401a4e0d"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/0a/10/c23352565a6544bdc5353e0b15fc1c563352101f30e24bf500207a54df9a/filelock-3.18.0.tar.gz"
    sha256 "adbc88eabb99d2fec8c9c1b229b171f18afa655400173ddc653d5d01501fb9f2"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/fe/8b/3c73abc9c759ecd3f1f7ceff6685840859e8070c4d947c93fae71f6a0bf2/platformdirs-4.3.8.tar.gz"
    sha256 "3d512d96e16bcb959a814c9f348431070822a6496326a4be0911c40b5a74c2bc"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end