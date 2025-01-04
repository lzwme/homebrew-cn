class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https:virtualenv.pypa.io"
  url "https:files.pythonhosted.orgpackages5039689abee4adc85aad2af8174bb195a819d0be064bf55fcc73b49d2b28ae77virtualenv-20.28.1.tar.gz"
  sha256 "5d34ab240fdb5d21549b76f9e8ff3af28252f5499fb6d6f031adac4e5a8c5329"
  license "MIT"
  head "https:github.compypavirtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5da5ecb8a36ef4688c8fad55d008f585cd0763193636f32a58f5e9b3f426243"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5da5ecb8a36ef4688c8fad55d008f585cd0763193636f32a58f5e9b3f426243"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e5da5ecb8a36ef4688c8fad55d008f585cd0763193636f32a58f5e9b3f426243"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea4ba9ed52c7e9198284b91f065b407693a116e6e94f6e507a7abdfa009bfc3a"
    sha256 cellar: :any_skip_relocation, ventura:       "ea4ba9ed52c7e9198284b91f065b407693a116e6e94f6e507a7abdfa009bfc3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f972aaf8bfc0d758cbc12bcb78ea5379e77d322cda3529625b5c1bf159ea776"
  end

  depends_on "python@3.13"

  resource "distlib" do
    url "https:files.pythonhosted.orgpackages0ddd1bec4c5ddb504ca60fc29472f3d27e8d4da1257a854e1d96742f15c1d02ddistlib-0.3.9.tar.gz"
    sha256 "a60f20dea646b8a33f3e7772f74dc0b2d0772d2837ee1342a00645c81edf9403"
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