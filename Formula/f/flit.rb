class Flit < Formula
  include Language::Python::Virtualenv

  desc "Simplified packaging of Python modules"
  homepage "https:github.compypaflit"
  url "https:files.pythonhosted.orgpackages8bc13482d40966e55808bae4dbd8b158c700146ed5d916cc98f0f5dcb4e23addflit-3.11.0.tar.gz"
  sha256 "58d0a07f684c315700c9c54a661a1130995798c3e495db0db53ce6e7d0121825"
  license "BSD-3-Clause"
  head "https:github.compypaflit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d76b337f079e07bb57e59623a2caaab05386b9affcd7549d1615e8e08b338ea0"
  end

  depends_on "certifi"
  depends_on "python@3.13"

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages16b0572805e227f01586461c80e0fd25d65a2115599cc9dad142fee4b747c357charset_normalizer-3.4.1.tar.gz"
    sha256 "44251f18cd68a75b56585dd00dae26183e102cd5e0f9f1466e6df5da2ed64ea3"
  end

  resource "docutils" do
    url "https:files.pythonhosted.orgpackagesaeedaefcc8cd0ba62a0560c3c18c33925362d46c6075480bfa4df87b28e169a9docutils-0.21.2.tar.gz"
    sha256 "3a6b18732edf182daa3cd12775bbb338cf5691468f91eeeb109deff6ebfa986f"
  end

  resource "flit-core" do
    url "https:files.pythonhosted.orgpackagesbc18b9b81cab2b8f63e6e7f72e1ba2766a0454fcd563e7a77b8299cb917ba805flit_core-3.11.0.tar.gz"
    sha256 "6ceeee3219e9d2ea282041f3e027c441597b450b33007cb81168e887b6113a8f"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "tomli-w" do
    url "https:files.pythonhosted.orgpackages1975241269d1da26b624c0d5e110e8149093c759b7a286138f4efd61a60e75fetomli_w-1.2.0.tar.gz"
    sha256 "2dd14fac5a47c27be9cd4c976af5a12d87fb1f0b4512f81d69cce3b35ae25021"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesaa63e53da845320b757bf29ef6a9062f5c669fe997973f966045cb019c3f4b66urllib3-2.3.0.tar.gz"
    sha256 "f8c5449b3cf0861679ce7e0503c7b44b5ec981bec0d1d3795a07f1ba96f0204d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath"sample.py").write <<~PYTHON
      """A sample package"""
      __version__ = "0.1"
    PYTHON
    (testpath"pyproject.toml").write <<~TOML
      [build-system]
      requires = ["flit_core"]
      build-backend = "flit_core.buildapi"

      [tool.flit.metadata]
      module = "sample"
      author = "Sample Author"
    TOML
    system bin"flit", "build"
    assert_path_exists testpath"distsample-0.1-py2.py3-none-any.whl"
    assert_path_exists testpath"distsample-0.1.tar.gz"
  end
end