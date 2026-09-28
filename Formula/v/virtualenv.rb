class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/31/0b/825cbfd46beb2cc96c46403141081190c1afd1a348d0232a4ebcb6dcd362/virtualenv-21.13.0.tar.gz"
  sha256 "e8aa144aabba43ffd9058e1fd1a02012b1915f8cb915acc16ad50aba9c13bfdc"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "408bda603e08703531f0f4c55e8815b77db467b41d4a676a98a43eb6612a8940"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "408bda603e08703531f0f4c55e8815b77db467b41d4a676a98a43eb6612a8940"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "408bda603e08703531f0f4c55e8815b77db467b41d4a676a98a43eb6612a8940"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "591560458b0be968c50fab8db25ef15eae8dd9923e37c50388abd1b0ad7d34a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "591560458b0be968c50fab8db25ef15eae8dd9923e37c50388abd1b0ad7d34a7"
  end

  depends_on "python@3.14"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/c9/02/bd72be9134d25ed783ecbbc38a539ffaefbf90c78418c7fb7229600dbac7/distlib-0.4.3.tar.gz"
    sha256 "f152097224a0ae24be5a0f6bae1b9359af82133bce63f98a95f86cae1aede9ed"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/c8/d7/37691dc5063438a448b646f6f2442b4beebf16cc0e18d8cdfa7aeec60b8c/filelock-4.0.4.tar.gz"
    sha256 "90999ed63a26ccf86b93b959ab10cf1017f422d816be454ed54cbed263e71ab5"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/23/4d/e78afe1b449720c481884ca0a2f960f85f9ffdaa34b2d127b5427422c564/platformdirs-4.12.0.tar.gz"
    sha256 "095be5c143382b1bee917c4f3e9987a0d8d6a582261f1d061ad0c403b7695b5b"
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