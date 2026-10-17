class Tox < Formula
  include Language::Python::Virtualenv

  desc "Generic Python virtualenv management and test command-line tool"
  homepage "https://tox.wiki/en/latest/"
  url "https://files.pythonhosted.org/packages/83/6e/00870fc3e18befbd39ea5543b4c4e113baabee0cfb2d9aa04c86a1442837/tox-4.65.6.tar.gz"
  sha256 "d5970575e4bca29316f6c758eb8a5ce29f4bca310e30878aa390d0adb7c2f13f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7bf60b96b4fd63ea8d418a710225c8634e59e68db518ac138132d392cef6bc96"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7bf60b96b4fd63ea8d418a710225c8634e59e68db518ac138132d392cef6bc96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7bf60b96b4fd63ea8d418a710225c8634e59e68db518ac138132d392cef6bc96"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c7dc2831e3352b689286fa5f01903c14a6a700bc3ea1b1e7e5e8768185f0d1c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c7dc2831e3352b689286fa5f01903c14a6a700bc3ea1b1e7e5e8768185f0d1c0"
  end

  depends_on "python@3.15"

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/85/e0/27b467a38de29583a68973edbf99eeeee5b105567bdbd7d208e5b07525a7/cachetools-7.2.2.tar.gz"
    sha256 "d521dc98d501ba9efd8d2b1663bbf88163509c0c0a090eea6dc154b421ec5410"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/c9/02/bd72be9134d25ed783ecbbc38a539ffaefbf90c78418c7fb7229600dbac7/distlib-0.4.3.tar.gz"
    sha256 "f152097224a0ae24be5a0f6bae1b9359af82133bce63f98a95f86cae1aede9ed"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/f4/a9/1af41b37c3279712b22cdc63aac78a52432202b6fe1f9666a2a3d2831fb4/filelock-4.2.0.tar.gz"
    sha256 "7a60906c75227cf04d0c273afadc8219400f11aeb13cc69591d4f6cdc6c8036e"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/16/35/146546aa5b9286a83248d29c51781476bbb4b0a608523361120059e0f7ed/platformdirs-4.13.1.tar.gz"
    sha256 "ee77cf2d36d5a515b2acf68ede6434cf3a8fc70b822bb6b3264d01b96c69a8e0"
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
    url "https://files.pythonhosted.org/packages/b0/73/54993df8fc57e906dc9b7e01d1d9b0b2d3eb0ce3190639e33dccb12853f7/python_discovery-1.6.2.tar.gz"
    sha256 "cd1738ca1d37c86ef9d0b654dd46fcee1e41c97c6add12575e8501ced39afdb4"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/19/75/241269d1da26b624c0d5e110e8149093c759b7a286138f4efd61a60e75fe/tomli_w-1.2.0.tar.gz"
    sha256 "2dd14fac5a47c27be9cd4c976af5a12d87fb1f0b4512f81d69cce3b35ae25021"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/dc/3f/935cf1757643381fb7f7cc98197b4bc119223d9c2cf37dc3b03ad2a4455f/virtualenv-21.14.7.tar.gz"
    sha256 "5f427d56f39eb7e7447d641dd4b7ab1e9c92793f498f35f26da2e4972c5546ae"
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