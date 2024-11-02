class Flit < Formula
  include Language::Python::Virtualenv

  desc "Simplified packaging of Python modules"
  homepage "https:github.compypaflit"
  url "https:files.pythonhosted.orgpackagesc32901c1ab00b1040c0de30f4dfd74cbaa26586e190bdcf12b1fd6783ea7dad4flit-3.10.0.tar.gz"
  sha256 "dadca58d5097db62884d25d70b572f104954927daadc8cee449739215b7237fd"
  license "BSD-3-Clause"
  head "https:github.compypaflit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9db339bbb39de12ab3ab639f3f26bed7ced3a3baa499db6dcc89632737c7519b"
  end

  depends_on "certifi"
  depends_on "python@3.13"

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagesf24fe1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1echarset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
  end

  resource "docutils" do
    url "https:files.pythonhosted.orgpackagesaeedaefcc8cd0ba62a0560c3c18c33925362d46c6075480bfa4df87b28e169a9docutils-0.21.2.tar.gz"
    sha256 "3a6b18732edf182daa3cd12775bbb338cf5691468f91eeeb109deff6ebfa986f"
  end

  resource "flit-core" do
    url "https:files.pythonhosted.orgpackages529289cceb9c49f3e6c72091304636c5ebc2fc48c546742bbf8a6a474e48e666flit_core-3.10.0.tar.gz"
    sha256 "6d904233178b3c924f665947ac7d286f2ac799fb69087e39e56ceb4084724a97"
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
    url "https:files.pythonhosted.orgpackagesd419b65f1a088ee23e37cdea415b357843eca8b1422a7b11a9eee6e35d4ec273tomli_w-1.1.0.tar.gz"
    sha256 "49e847a3a304d516a169a601184932ef0f6b61623fe680f836a2aa7128ed0d33"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesed6322ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath"sample.py").write <<~END
      """A sample package"""
      __version__ = "0.1"
    END
    (testpath"pyproject.toml").write <<~END
      [build-system]
      requires = ["flit_core"]
      build-backend = "flit_core.buildapi"

      [tool.flit.metadata]
      module = "sample"
      author = "Sample Author"
    END
    system bin"flit", "build"
    assert_predicate testpath"distsample-0.1-py2.py3-none-any.whl", :exist?
    assert_predicate testpath"distsample-0.1.tar.gz", :exist?
  end
end