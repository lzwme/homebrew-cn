class Tox < Formula
  include Language::Python::Virtualenv

  desc "Generic Python virtualenv management and test command-line tool"
  homepage "https://tox.wiki/en/latest/"
  url "https://files.pythonhosted.org/packages/11/33/e8f6282e5ced7b01abd968706758014df0b602c622df2c0c61c148921800/tox-4.64.8.tar.gz"
  sha256 "8d54028cd31f5c8b3dc319e8c2346d720a1ed066aadf3325fd80e9fd3d233825"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c1caefebd4b5f87a36ceb7fc7d35451f26e4d855bcf69ac6075dd2751cb469d4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c1caefebd4b5f87a36ceb7fc7d35451f26e4d855bcf69ac6075dd2751cb469d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c1caefebd4b5f87a36ceb7fc7d35451f26e4d855bcf69ac6075dd2751cb469d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "150aa4cd5a3ae351d20c0d8b44bfa004ab2072f9e8df51da9c8e603854125066"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "150aa4cd5a3ae351d20c0d8b44bfa004ab2072f9e8df51da9c8e603854125066"
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
    url "https://files.pythonhosted.org/packages/4b/51/a182494d1d8dde1240bff84dda57d48165d982e59582ce8f167e8e3d7628/filelock-4.0.10.tar.gz"
    sha256 "00d6a81f976a6332551c2c10f39e12b4abb7e01c64d4c497b81a615bc9186f1f"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/42/23/4a86fc741c38c5b69792a4ef954b281afa69bea9f083f881de1b0d23bc07/platformdirs-4.12.3.tar.gz"
    sha256 "427fc0bb321ae0c5b037fa03238ca74820437be162e78b4848c4d4055b9b766c"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "pyproject-api" do
    url "https://files.pythonhosted.org/packages/51/24/757e066eafeeb91ac4887c2edb9c0ac5eb2d5420f836897443577719647f/pyproject_api-1.11.3.tar.gz"
    sha256 "4ca2f09f628d86ae019d7c701ebb65ee667efc28261f8b9ee3bd55bf0985712c"
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
    url "https://files.pythonhosted.org/packages/c4/f9/f323b3b6058cff3853b31cf6a49c0425ed797bf9611572ec10d065e08bac/virtualenv-21.14.5.tar.gz"
    sha256 "c4cb6c13e46b57225a999c7e22a09b163393878facc7ac4c059a57f46faa1647"
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