class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/ad/3b/02608bb39c6b6f7d59ca62b04d704cf61e85361a7123b6394bca275661e1/virtualenv-21.12.1.tar.gz"
  sha256 "be5a0a62cb2d1529ff6999652e2e7826f95bf7faa9b96b88cc39847c023d90a0"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "776be5998ac3ccab1f0b4938bee797a6084428f54a6c91e073fdfd9e1ca128e6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "776be5998ac3ccab1f0b4938bee797a6084428f54a6c91e073fdfd9e1ca128e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "776be5998ac3ccab1f0b4938bee797a6084428f54a6c91e073fdfd9e1ca128e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e5b0f535c949b12b4ff58fe920e6e7e46817b6cf526f1cb68765cb7b50f11681"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "e5b0f535c949b12b4ff58fe920e6e7e46817b6cf526f1cb68765cb7b50f11681"
  end

  depends_on "python@3.14"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/c9/02/bd72be9134d25ed783ecbbc38a539ffaefbf90c78418c7fb7229600dbac7/distlib-0.4.3.tar.gz"
    sha256 "f152097224a0ae24be5a0f6bae1b9359af82133bce63f98a95f86cae1aede9ed"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/4f/b8/9ba8f569df649beb7058db5eb392a5f779bdbc3b82cf3942f0be439fb99e/filelock-4.0.3.tar.gz"
    sha256 "87296d60478e14204fd9406e79831400fef76693bae2895deec236c98e87a8aa"
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