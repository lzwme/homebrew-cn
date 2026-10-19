class Tox < Formula
  include Language::Python::Virtualenv

  desc "Generic Python virtualenv management and test command-line tool"
  homepage "https://tox.wiki/en/latest/"
  url "https://files.pythonhosted.org/packages/4a/79/ce1ce8c98a1ff8ff318191ed1b4f113a3a8626fccfcedc687f7a485b5d7f/tox-4.67.0.tar.gz"
  sha256 "d3e48816bebbd7bad0f6942a36fa7bcd14fe4ccbf4b3a5d54040ca0294dafd1f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1b86a1f369f63527d9832833920c98507a88582c4f8e5fbccdab6432fb915457"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1b86a1f369f63527d9832833920c98507a88582c4f8e5fbccdab6432fb915457"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1b86a1f369f63527d9832833920c98507a88582c4f8e5fbccdab6432fb915457"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5c4f4eaf049f1cfcffdebe38259f369336ce5a193b1fe0f3b991a71d577d2e8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "5c4f4eaf049f1cfcffdebe38259f369336ce5a193b1fe0f3b991a71d577d2e8a"
  end

  depends_on "python@3.15"

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/09/88/27fe0785c7a9aa285c753db0b4ea967adbf76128fede66379c35a4b8d054/cachetools-7.2.3.tar.gz"
    sha256 "e6fafd06de4a5bd915ff7d247588ea497e28c9a568c62db8678d9a5f11515a9a"
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
    url "https://files.pythonhosted.org/packages/d5/98/771d8ca889f220d7d7e352addf500666368f0fd081c6080a83767580c6e4/filelock-4.2.1.tar.gz"
    sha256 "c4c937ccac2a813cee448e662a56366cfb374c0f8702e75f295c412cc1c5d5a3"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/b7/89/dfd269de936e76319cf27787d9eaaca513491f635d49b0fbe7cdb6d3bf6f/platformdirs-4.13.4.tar.gz"
    sha256 "dd96496961684a7f42041923f842ec7494e09f5e87aded99117e1109cd40570e"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/bf/db/7fc19e6f2dc92a966727031389fc2e08b558f0f25eb7403c1119ad4713cd/pluggy-1.7.0.tar.gz"
    sha256 "d1eaa46ebb595891b860ab086b4d09c8588af65ebd4361b8e8f4bb8920b90ba8"
  end

  resource "pyproject-api" do
    url "https://files.pythonhosted.org/packages/ce/04/15a06959a6a40d62b5aa001f6df5d26bba3961a84563f745ac337a79e979/pyproject_api-1.11.7.tar.gz"
    sha256 "408e31b80e054e70d26f11b0ae3f60210ae6d54cd050e904aac63462b56404e9"
  end

  resource "python-discovery" do
    url "https://files.pythonhosted.org/packages/fc/54/fad125f5c48f7821644ee6f223ebfcedc4e23597c1a16eeb13d33aa4a91a/python_discovery-1.6.3.tar.gz"
    sha256 "a62b301d96cf5489cb96ab023b32e068421867fdd5df2e42eece877869047fa2"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/19/75/241269d1da26b624c0d5e110e8149093c759b7a286138f4efd61a60e75fe/tomli_w-1.2.0.tar.gz"
    sha256 "2dd14fac5a47c27be9cd4c976af5a12d87fb1f0b4512f81d69cce3b35ae25021"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/36/ce/7136eeccc4ff32c06c3b523745af49c5cf6b2e95635d88ae8519a6f4d25b/virtualenv-21.14.10.tar.gz"
    sha256 "f733501a49404c91b5bb1d34d107073b8f4b93a9a1ddb7e9a950eb8ce60f38ad"
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