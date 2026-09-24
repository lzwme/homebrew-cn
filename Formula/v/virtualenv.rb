class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/cd/ea/0221ff416c626986b0f6784d001818540ce645795606f3ff6b6758f033eb/virtualenv-21.10.0.tar.gz"
  sha256 "7416cbc176d8a06b0c71e2bf65745b00822a5c204df9a2473b91d8fd06e4f6fd"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "05d8a82c4e295e987f146b1d736211ce68ca9b9a5d7e99efb90ed93d9ced7714"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "27a029c4ecf5e20ada01f994ab8fb7e2fbe58adf074ca36e4d8c266d340c7d21"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5629aebdec94537c08f2e51eb90dfce1e42436c4a5c05ba671e20d8c50b97ee0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "009c1449fa330e389b6760c2ed4209480ea20ac8fc2832eb0dc3a1cc21a993f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "9f570a1bff89d353378c990cb512391994c3bbf84657374b4a63bccce4e7f4c8"
  end

  depends_on "python@3.14"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/c9/02/bd72be9134d25ed783ecbbc38a539ffaefbf90c78418c7fb7229600dbac7/distlib-0.4.3.tar.gz"
    sha256 "f152097224a0ae24be5a0f6bae1b9359af82133bce63f98a95f86cae1aede9ed"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/6f/38/88cd6eda96c40594a1e3da7d8b40f04bc40ace5a6aef9ac5cb407540f173/filelock-4.0.1.tar.gz"
    sha256 "fdefc3f3e87716d855ae2b732c1cfd521dd99799ef2b4d00e8c0d4dcdc7cc94b"
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