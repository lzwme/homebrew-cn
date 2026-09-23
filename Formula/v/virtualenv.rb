class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/76/87/5d3963c31de2d19adce4c14c611279eb8a724fb43eb29338b1a437693508/virtualenv-21.9.1.tar.gz"
  sha256 "4d2256a16b2c99cb30e58abe96d009a4328e215d64f229c7738fc5adad83cd1a"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3b4e6cc0a7b2a7830ce71c46a3b068ea4f59784e83dbdd4b55af07b44496e5fa"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "caea3b0bc607627fcfaf96f7362fd98c24088e123cb37959800293ce96603144"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8d0f494e82b348d3f0bb4a586f3e9f9f64deec8a8e660405e604c4c36887d8ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b7c55fbe6fa54b9821f64c4a2f1732302178cf54ffd5df1ba6228b46bac4bad1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "8d947f5690be7d512e06b9706cb2b7d177b35c6fc3dce02fed6f2906ef373147"
  end

  depends_on "python@3.14"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/c9/02/bd72be9134d25ed783ecbbc38a539ffaefbf90c78418c7fb7229600dbac7/distlib-0.4.3.tar.gz"
    sha256 "f152097224a0ae24be5a0f6bae1b9359af82133bce63f98a95f86cae1aede9ed"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/0f/59/e19834834cb01a32febfbb0f8a23a9088088f5d45991824ff2bc3b5e8acb/filelock-3.32.7.tar.gz"
    sha256 "37b8a3d9811b0f9aef7e5ec5c71bb320de52df51e6ca9bcd6f5ad81187660da7"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/ea/dd/65804b0c2925a1c821a05502ea57517b69a073ff400d25ab9faa3a2cf012/platformdirs-4.11.12.tar.gz"
    sha256 "e8dc1cb58f1153fd7f61db1374317770baababec2480b37b8f01c6cc25b45267"
  end

  resource "python-discovery" do
    url "https://files.pythonhosted.org/packages/0c/57/250bd238b966cece44328235eb85290045d059265fdaf7527a3a958123db/python_discovery-1.6.1.tar.gz"
    sha256 "cf87d3627dfb4412437fdd5b13eae402607722998d21567993aedbc59b23c15e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end