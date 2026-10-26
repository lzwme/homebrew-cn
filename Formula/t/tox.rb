class Tox < Formula
  include Language::Python::Virtualenv

  desc "Generic Python virtualenv management and test command-line tool"
  homepage "https://tox.wiki/en/latest/"
  url "https://files.pythonhosted.org/packages/63/6e/677274ae411fa13f5c2ea5c633a6abfa0886e949bd2ef53c7e564a0b0b2e/tox-4.67.1.tar.gz"
  sha256 "a68602f64421b199016127364ee47347b958391d19c2b2e53fe95673a8fe98e9"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3becc0fd96304de217808b6062fe6ee797040e71d7cb1204ce8096a86e703dd4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3becc0fd96304de217808b6062fe6ee797040e71d7cb1204ce8096a86e703dd4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3becc0fd96304de217808b6062fe6ee797040e71d7cb1204ce8096a86e703dd4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cfa15c90e482686fceaae223d1f5ee1a49731c141f9137be9b9aa782fff4fe0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "cfa15c90e482686fceaae223d1f5ee1a49731c141f9137be9b9aa782fff4fe0c"
  end

  depends_on "python@3.15"

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/3a/5d/15ea0494ebcb9062c7ca79bf026cbba380a50538ae73753fb40bdffa79e2/cachetools-7.2.4.tar.gz"
    sha256 "e0203b04b75fe13e62098eeb5b2018c4eb1a14c04e2b5b450e70db3ee7e92ec5"
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
    url "https://files.pythonhosted.org/packages/58/e6/d0abbb256b44e6a05748c6942511ff67db8dbb068de0c35b24bf1b395b09/platformdirs-4.13.5.tar.gz"
    sha256 "05831adf87d392760f4b5c3a0a95579ab5a10b18b9b9bd43680dcb47544788a0"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/bf/db/7fc19e6f2dc92a966727031389fc2e08b558f0f25eb7403c1119ad4713cd/pluggy-1.7.0.tar.gz"
    sha256 "d1eaa46ebb595891b860ab086b4d09c8588af65ebd4361b8e8f4bb8920b90ba8"
  end

  resource "pyproject-api" do
    url "https://files.pythonhosted.org/packages/9a/c6/04bb77bccfa36aabc783a31e335b5441829f5ec9ff16e313b5b7022d81a8/pyproject_api-1.12.0.tar.gz"
    sha256 "2e83226079dc446a8e2357def7622c01c733284e39afc8e332d9f722fe0c2beb"
  end

  resource "python-discovery" do
    url "https://files.pythonhosted.org/packages/f3/ee/cf608372c88ce2c136ee13c69ab6f667dbc0d0c1176af188b4ddc8853e66/python_discovery-1.6.4.tar.gz"
    sha256 "bc70d31f0ec5de11eda13d4d64c16e24b3506a65984684f2b6c98cb83b2ea9df"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/19/75/241269d1da26b624c0d5e110e8149093c759b7a286138f4efd61a60e75fe/tomli_w-1.2.0.tar.gz"
    sha256 "2dd14fac5a47c27be9cd4c976af5a12d87fb1f0b4512f81d69cce3b35ae25021"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/70/aa/bff50daee0488e16d611258a9b6c5a1d0c9e128f8ca424e9f4e1c0444ef2/virtualenv-21.14.13.tar.gz"
    sha256 "de5307ba4b9a0001d9c8ea02832d38f63ca432880f416c1bface61c4323fd905"
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