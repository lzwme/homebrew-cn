class Internetarchive < Formula
  include Language::Python::Virtualenv

  desc "Python wrapper for the various Internet Archive APIs"
  homepage "https:github.comjjjakeinternetarchive"
  url "https:files.pythonhosted.orgpackages0d9e07e577a1d3e20deeae447069b80d523e7140b790f0a8e1bab1e23b1b9252internetarchive-4.1.0.tar.gz"
  sha256 "467188386218d2c77815ca798a51dd18310b326841113bb462b24ea9a71beedc"
  license "AGPL-3.0-or-later"
  revision 2

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "74d45c88b5384b3b9b6a05a9426a6e1b37be1ed43f45091ada9b2f27b3291862"
  end

  depends_on "certifi"
  depends_on "python@3.13"

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagesf24fe1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1echarset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
  end

  resource "docopt" do
    url "https:files.pythonhosted.orgpackagesa2558f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "jsonpatch" do
    url "https:files.pythonhosted.orgpackages427818813351fe5d63acad16aec57f94ec2b70a09e53ca98145589e185423873jsonpatch-1.33.tar.gz"
    sha256 "9fcd4009c41e6d12348b4a0ff2563ba56a2923a7dfee731d004e212e1ee5030c"
  end

  resource "jsonpointer" do
    url "https:files.pythonhosted.orgpackages6a0aeebeb1fa92507ea94016a2a790b93c2ae41a7e18778f85471dc54475ed25jsonpointer-3.0.0.tar.gz"
    sha256 "2b2d729f2091522d61c3b31f82e11870f60b68f43fbc705cb76bf4b832af59ef"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "schema" do
    url "https:files.pythonhosted.orgpackagesd4010ea2e66bad2f13271e93b729c653747614784d3ebde219679e41ccdceecdschema-0.7.7.tar.gz"
    sha256 "7da553abd2958a19dc2547c388cde53398b39196175a9be59ea1caf5ab0a1807"
  end

  resource "tqdm" do
    url "https:files.pythonhosted.orgpackages58836ba9844a41128c62e810fddddd72473201f3eacde02046066142a2d96cc5tqdm-4.66.5.tar.gz"
    sha256 "e1020aef2e5096702d8a025ac7d16b1577279c9d63f8375b63083e9a5f0fcbad"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesed6322ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  def install
    ENV["PIP_USE_PEP517"] = "1"
    virtualenv_install_with_resources
  end

  test do
    metadata = JSON.parse shell_output("#{bin}ia metadata tigerbrew")
    assert_equal metadata["metadata"]["uploader"], "mistydemeo@gmail.com"
  end
end