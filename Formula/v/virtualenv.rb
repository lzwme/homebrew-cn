class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/3f/8b/6331f7a7fe70131c301106ec1e7cf23e2501bf7d4ca3636805801ca191bb/virtualenv-21.3.0.tar.gz"
  sha256 "733750db978ec95c2d8eb4feadaa57091002bce404cb39ba69899cf7bd28944e"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8849a09dd8eb7c3085799da62fb05eafc69c85f6473b3a98ac62937654151f03"
  end

  depends_on "python@3.14"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/96/8e/709914eb2b5749865801041647dc7f4e6d00b549cfe88b65ca192995f07c/distlib-0.4.0.tar.gz"
    sha256 "feec40075be03a04501a973d81f633735b4b69f98b05450592310c0f401a4e0d"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/b5/fe/997687a931ab51049acce6fa1f23e8f01216374ea81374ddee763c493db5/filelock-3.29.0.tar.gz"
    sha256 "69974355e960702e789734cb4871f884ea6fe50bd8404051a3530bc07809cf90"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/9f/4a/0883b8e3802965322523f0b200ecf33d31f10991d0401162f4b23c698b42/platformdirs-4.9.6.tar.gz"
    sha256 "3bfa75b0ad0db84096ae777218481852c0ebc6c727b3168c1b9e0118e458cf0a"
  end

  resource "python-discovery" do
    url "https://files.pythonhosted.org/packages/de/ef/3bae0e537cfe91e8431efcba4434463d2c5a65f5a89edd47c6cf2f03c55f/python_discovery-1.2.2.tar.gz"
    sha256 "876e9c57139eb757cb5878cbdd9ae5379e5d96266c99ef731119e04fffe533bb"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end