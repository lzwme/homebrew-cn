class Tox < Formula
  include Language::Python::Virtualenv

  desc "Generic Python virtualenv management and test command-line tool"
  homepage "https://tox.wiki/en/latest/"
  url "https://files.pythonhosted.org/packages/57/c0/cc1ce2c8d5b3eef3c6051e5b73311a09ded0ccb931329a717abaf6cce527/tox-4.67.3.tar.gz"
  sha256 "54c6cd8e5509ebc2188836a550ada6264759df7f14fd46f613d20fc3d2dedb26"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "951d5f6ffe25cc08a2945820455dfe6b65990bbda5696afb72b268ebc3a69384"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "951d5f6ffe25cc08a2945820455dfe6b65990bbda5696afb72b268ebc3a69384"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "951d5f6ffe25cc08a2945820455dfe6b65990bbda5696afb72b268ebc3a69384"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0e0ee66a5fb2d851a6cc53645647aabd3ebfebcc6f1c78b32061cb621e2cf15d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "0e0ee66a5fb2d851a6cc53645647aabd3ebfebcc6f1c78b32061cb621e2cf15d"
  end

  depends_on "python@3.15"

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/f2/0f/e02be8857e0fc519a12337568f0bf4b0aad4f3a95d7303e9e9d9fbcca8c2/cachetools-7.2.6.tar.gz"
    sha256 "1096513bdeed468ba505df3d123e4578a5a22c955f4a9ba3912fd71f3f95363a"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/68/bc/d36966de7304047a1001a7559fbf266c464bb5d8cc85464536ef8c9bcc32/distlib-0.4.4.tar.gz"
    sha256 "ca4175b4ac7f71223cc30ed7248c45d2b38c2439d8ee6e498ab67ed63cf3508d"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/d8/28/3893324bcadf8f89b1616637468d766af3f625008c0735bf704fdfa86617/filelock-4.2.4.tar.gz"
    sha256 "c6d8663535e1650ee430507b4ffbac7b464dd64b7647ea0112a9f406499d163d"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/1a/43/8c4b5fe23f0e119cf4e1b16c2d16240ab9057cdbb138568c91d5a48abf81/platformdirs-4.13.6.tar.gz"
    sha256 "211d176e24674b5895dedf9021c262bcf9fad008a70610bfb147d4a8d6d8fe1b"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/bf/db/7fc19e6f2dc92a966727031389fc2e08b558f0f25eb7403c1119ad4713cd/pluggy-1.7.0.tar.gz"
    sha256 "d1eaa46ebb595891b860ab086b4d09c8588af65ebd4361b8e8f4bb8920b90ba8"
  end

  resource "pyproject-api" do
    url "https://files.pythonhosted.org/packages/a6/af/5ac3c74655469fd52c6d496d728a85e5db454abb15682be5e620735a2349/pyproject_api-1.12.2.tar.gz"
    sha256 "ad2a72516abcc950877222e9eff760c9120d2086f0d9fce6aef4f16985a3e946"
  end

  resource "python-discovery" do
    url "https://files.pythonhosted.org/packages/8e/3e/0c8cbdb52feeac4a8667ccff3c58fd2568d6d2969db2717ff00a9fdae73a/python_discovery-1.6.6.tar.gz"
    sha256 "d687024fec55c489e7a465c7f5644300a4d9dbf7727a556a85660536ee922933"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/19/75/241269d1da26b624c0d5e110e8149093c759b7a286138f4efd61a60e75fe/tomli_w-1.2.0.tar.gz"
    sha256 "2dd14fac5a47c27be9cd4c976af5a12d87fb1f0b4512f81d69cce3b35ae25021"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/b2/24/20282bc8e69ff8dee680dc2b95e9dc81fa7e7894b14c1a8d06330e97fef7/virtualenv-21.15.1.tar.gz"
    sha256 "e79c90b8f601701599c25905e02839924fede2c798d52325670d24fbdaab74ee"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "usage", shell_output("#{bin}/tox --help")
    system bin/"tox"
    pyver = Language::Python.major_minor_version(python3).to_s.delete(".")

    system bin/"tox", "quickstart", "src"
    (testpath/"src/test_trivial.py").write <<~PYTHON
      def test_trivial():
          assert True
    PYTHON
    chdir "src" do
      system bin/"tox", "run"
    end
    assert_path_exists testpath/"src/.tox/py#{pyver}"
  end
end