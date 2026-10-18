class Tox < Formula
  include Language::Python::Virtualenv

  desc "Generic Python virtualenv management and test command-line tool"
  homepage "https://tox.wiki/en/latest/"
  url "https://files.pythonhosted.org/packages/65/17/183426a492c45f113fb73e26d7e17de63222338222a887b1da055356d0bc/tox-4.66.0.tar.gz"
  sha256 "f9dc2cec9310a3ab5a560669cf860cf6ffad7d04733a0845c7ad7ac00d6b2808"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b49b4b81bc72f6608294d2b44ade7bc1f3cd462834f0eba577c812b4427818f5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b49b4b81bc72f6608294d2b44ade7bc1f3cd462834f0eba577c812b4427818f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b49b4b81bc72f6608294d2b44ade7bc1f3cd462834f0eba577c812b4427818f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e58b1d97248b3b1a32bca3bf66a38a72eae8900d34c1665b6d9c66c9956165b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "e58b1d97248b3b1a32bca3bf66a38a72eae8900d34c1665b6d9c66c9956165b9"
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
    url "https://files.pythonhosted.org/packages/da/91/4a03cfdb03314cfca262921797fff04ff4054bd86a160aed76eddf8aa12b/platformdirs-4.13.3.tar.gz"
    sha256 "5e567f664eb087ab8521c0179cd8d1bd60857d271136567a39719e28e2d383ce"
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
    url "https://files.pythonhosted.org/packages/0b/6a/fbdeea5c07d5674139639d42a97a41d26e9b9b8cb2a1265fa936f655ee20/virtualenv-21.14.8.tar.gz"
    sha256 "394e45ed610ceffb5018e1a179e3a8012c02fd87fe792ab4aae67ce5e7e3afbd"
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