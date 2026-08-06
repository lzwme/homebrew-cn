class Flit < Formula
  include Language::Python::Virtualenv

  desc "Simplified packaging of Python modules"
  homepage "https://github.com/pypa/flit"
  url "https://files.pythonhosted.org/packages/c6/dc/1d5141ccc27a98b9972e24fea9803ce7f29b5d59574fad2f22ff921be089/flit-4.0.1.tar.gz"
  sha256 "dd52c4fd04d70db77fd59a82404808f4a89b3088d701391e004088e8f1c5b953"
  license "BSD-3-Clause"
  head "https://github.com/pypa/flit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "833b7bef70b837c2f73b7c322b5df7d21fd411f4d0fa859e217fe3a26e87d039"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "833b7bef70b837c2f73b7c322b5df7d21fd411f4d0fa859e217fe3a26e87d039"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "833b7bef70b837c2f73b7c322b5df7d21fd411f4d0fa859e217fe3a26e87d039"
    sha256 cellar: :any_skip_relocation, sonoma:        "716ecfbcfc933ff28ba33ebbfd04e6af25ad9fcf1c99d73f14d6d5f79d720830"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "833b7bef70b837c2f73b7c322b5df7d21fd411f4d0fa859e217fe3a26e87d039"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "833b7bef70b837c2f73b7c322b5df7d21fd411f4d0fa859e217fe3a26e87d039"
  end

  depends_on "certifi"
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/bd/2a/23f34ec9d04624958e137efdc394888716353190e75f25dd22c7a2c7a8aa/charset_normalizer-3.4.9.tar.gz"
    sha256 "673611bbd43f0810bec0b0f028ddeaaa501190339cac411f347ac76917c3ae7b"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/39/a4/5180d9afc57e8fca05601dd652bdff19604c218814037fe90ffc7625a50a/docutils-0.23.tar.gz"
    sha256 "746f5060322511280a1e50eb76846ed6bf2342984b2ac04dc42caa1a8d78799e"
  end

  resource "flit-core" do
    url "https://files.pythonhosted.org/packages/4e/e9/e936060bb42ddb708af53714019d943956e1a8ba6ea10f7e417e5f82bb0b/flit_core-4.0.1.tar.gz"
    sha256 "323e4f9ea1c2b1075d14326bd3150be360ad159634688441f3691c98cfd24447"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/19/75/241269d1da26b624c0d5e110e8149093c759b7a286138f4efd61a60e75fe/tomli_w-1.2.0.tar.gz"
    sha256 "2dd14fac5a47c27be9cd4c976af5a12d87fb1f0b4512f81d69cce3b35ae25021"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"sample.py").write <<~PYTHON
      """A sample package"""
      __version__ = "0.1"
    PYTHON
    (testpath/"pyproject.toml").write <<~TOML
      [build-system]
      requires = ["flit_core"]
      build-backend = "flit_core.buildapi"

      [project]
      name = "sample"
      authors = [{name = "Sample Author", email = "sample@example.com"}]
      dynamic = ["version", "description"]
    TOML
    system bin/"flit", "build"
    assert_path_exists testpath/"dist/sample-0.1-py2.py3-none-any.whl"
    assert_path_exists testpath/"dist/sample-0.1.tar.gz"
  end
end