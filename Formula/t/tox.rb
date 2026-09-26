class Tox < Formula
  include Language::Python::Virtualenv

  desc "Generic Python virtualenv management and test command-line tool"
  homepage "https://tox.wiki/en/latest/"
  url "https://files.pythonhosted.org/packages/bf/92/1e311d474eb0892125dacb9aabe0b6a87945a69445cd9685b3f6a2d013ca/tox-4.64.2.tar.gz"
  sha256 "64198e9beb76f907c4fe65a87e05c26aa3cd79c85a7162f5052484f866adda06"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "652b3e8a41ab7d289e13976a9fdafedc86e3db505614a4d0dd511c4ae92551f6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "652b3e8a41ab7d289e13976a9fdafedc86e3db505614a4d0dd511c4ae92551f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "652b3e8a41ab7d289e13976a9fdafedc86e3db505614a4d0dd511c4ae92551f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "12adc6491f3bf6a5e6dda7490905e5aaa41eed2416290c56d6b34ec42e4a14f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "12adc6491f3bf6a5e6dda7490905e5aaa41eed2416290c56d6b34ec42e4a14f1"
  end

  depends_on "python@3.14"

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/29/2c/3f18755527b03ca9ff6be724bd5370cb777c76a87f17301377cf04a4729b/cachetools-7.2.0.tar.gz"
    sha256 "bcac1a1b8da6909994a2957238a57b8140dab7c5c5c69a43669654fe87a33c1d"
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
    url "https://files.pythonhosted.org/packages/4f/b8/9ba8f569df649beb7058db5eb392a5f779bdbc3b82cf3942f0be439fb99e/filelock-4.0.3.tar.gz"
    sha256 "87296d60478e14204fd9406e79831400fef76693bae2895deec236c98e87a8aa"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/ea/dd/65804b0c2925a1c821a05502ea57517b69a073ff400d25ab9faa3a2cf012/platformdirs-4.11.12.tar.gz"
    sha256 "e8dc1cb58f1153fd7f61db1374317770baababec2480b37b8f01c6cc25b45267"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "pyproject-api" do
    url "https://files.pythonhosted.org/packages/e1/2d/7b6837335aab9c00bcd18adde43c78948db6a2fe26dfa79a6bfcdefd3c5d/pyproject_api-1.11.2.tar.gz"
    sha256 "7bff8690a101f5f0bac3221475d214018f196ae5eea3af9c9879f4d682a3fd60"
  end

  resource "python-discovery" do
    url "https://files.pythonhosted.org/packages/0c/57/250bd238b966cece44328235eb85290045d059265fdaf7527a3a958123db/python_discovery-1.6.1.tar.gz"
    sha256 "cf87d3627dfb4412437fdd5b13eae402607722998d21567993aedbc59b23c15e"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/19/75/241269d1da26b624c0d5e110e8149093c759b7a286138f4efd61a60e75fe/tomli_w-1.2.0.tar.gz"
    sha256 "2dd14fac5a47c27be9cd4c976af5a12d87fb1f0b4512f81d69cce3b35ae25021"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/ad/3b/02608bb39c6b6f7d59ca62b04d704cf61e85361a7123b6394bca275661e1/virtualenv-21.12.1.tar.gz"
    sha256 "be5a0a62cb2d1529ff6999652e2e7826f95bf7faa9b96b88cc39847c023d90a0"
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