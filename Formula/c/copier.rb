class Copier < Formula
  include Language::Python::Virtualenv

  desc "Utility for rendering projects templates"
  homepage "https:copier.readthedocs.io"
  url "https:files.pythonhosted.orgpackages626f399c09b6d1dcb30fc341402d81cc1eaa4f7aaa3ee65b5f58e68aff4635e7copier-9.1.0.tar.gz"
  sha256 "0810134f0bf3ce72b402480d1420ab7e773c1c9ce719a923e1584cb69f97dacb"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cac8aa874e103a0cbfcfa3fb05e037dd2b92b53cf7ccb6ceffaad4c85896bca2"
    sha256 cellar: :any,                 arm64_ventura:  "6294a32fcc7fa67850dae82c5e1413d2bfe19ad90584a964bdde02174bac5ee7"
    sha256 cellar: :any,                 arm64_monterey: "1fcb96dddb23f1de2fcf6319fea2f8cb767e9705697454bca50e35f2856d93d4"
    sha256 cellar: :any,                 sonoma:         "04837c082ab40dd3d475e6f53b2cf1f3436a93039cee219f8a4cab2dbccaecd1"
    sha256 cellar: :any,                 ventura:        "08e113ccbfbd3e8403f74b30b0b330c611c6a5ab68479fe19f45162aca8991c2"
    sha256 cellar: :any,                 monterey:       "409193b22c2cad7b2b2ab3995f059392617d59dbae7f338cf878e29ad7299941"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89f844425cdf7a7955221304346486f8679cd402991b9539520f409139e13e33"
  end

  depends_on "rust" => :build
  depends_on "pygments"
  depends_on "python-markupsafe"
  depends_on "python-packaging"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"
  depends_on "pyyaml"

  resource "annotated-types" do
    url "https:files.pythonhosted.orgpackages67fe8c7b275824c6d2cd17c93ee85d0ee81c090285b6d52f4876ccc47cf9c3c4annotated_types-0.6.0.tar.gz"
    sha256 "563339e807e53ffd9c267e99fc6d9ea23eb8443c08f112651963e24e22f84a5d"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "decorator" do
    url "https:files.pythonhosted.orgpackages660c8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "dunamai" do
    url "https:files.pythonhosted.orgpackages1d03338fba56a6c76ea6d99ca0b7af3098292c2dd6597ed656daa6ae26a07a77dunamai-1.19.0.tar.gz"
    sha256 "6ad99ae34f7cd290550a2ef1305d2e0292e6e6b5b1b830dfc07ceb7fd35fec09"
  end

  resource "funcy" do
    url "https:files.pythonhosted.orgpackages70b8c6081521ff70afdff55cd9512b2220bbf4fa88804dae51d1b57b4b58ef32funcy-2.0.tar.gz"
    sha256 "3963315d59d41c6f30c04bc910e10ab50a3ac4a225868bfa96feed133df075cb"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesb25e3a21abf3cd467d7876045335e681d276ac32492febe6d98ad89562d1a7e1Jinja2-3.1.3.tar.gz"
    sha256 "ac8bd6544d4bb2c9792bf3a159e80bba8fda7f07e81bc3aed565432d5925ba90"
  end

  resource "jinja2-ansible-filters" do
    url "https:files.pythonhosted.orgpackages1a27fa186af4b246eb869ffca8ffa42d92b05abaec08c99329e74d88b2c46ec7jinja2-ansible-filters-1.3.2.tar.gz"
    sha256 "07c10cf44d7073f4f01102ca12d9a2dc31b41d47e4c61ed92ef6a6d2669b356b"
  end

  resource "pathspec" do
    url "https:files.pythonhosted.orgpackagescabcf35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbfpathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "plumbum" do
    url "https:files.pythonhosted.orgpackages8e3d6bbc1b93fd394f6cc9fbe098d8e2740063d58c36dd8da876f790458ded46plumbum-1.8.2.tar.gz"
    sha256 "9e6dc032f4af952665f32f3206567bc23b7858b1413611afe603a3f8ad9bfd75"
  end

  resource "prompt-toolkit" do
    url "https:files.pythonhosted.orgpackagesfb93180be2342f89f16543ec4eb3f25083b5b84eba5378f68efff05409fb39a9prompt_toolkit-3.0.36.tar.gz"
    sha256 "3e163f254bef5a03b146397d7c1963bd3e2812f0964bb9a24e6ec761fd28db63"
  end

  resource "pydantic" do
    url "https:files.pythonhosted.orgpackagesaa3f56142232152145ecbee663d70a19a45d078180633321efb3847d2562b490pydantic-2.5.3.tar.gz"
    sha256 "b3ef57c62535b0941697cce638c08900d87fcb67e29cfa99e8a68f747f393f7a"
  end

  resource "pydantic-core" do
    url "https:files.pythonhosted.orgpackagesb27d8304d8471cfe4288f95a3065ebda56f9790d087edc356ad5bd83c89e2d79pydantic_core-2.14.6.tar.gz"
    sha256 "1fd0c1d395372843fba13a51c28e3bb9d59bd7aebfeb17358ffaaa1e4dbbe948"
  end

  resource "pyyaml-include" do
    url "https:files.pythonhosted.orgpackagesa0c805acc1abc2694add669ae1c4469057ab7dc90a5b1d1ebbc2a8db4c4acd88pyyaml-include-1.3.2.tar.gz"
    sha256 "a516d5172092ec110a427dafe171da9341fe488eb6d1c78fb52f1f0414dec26d"
  end

  resource "questionary" do
    url "https:files.pythonhosted.orgpackages84d0d73525aeba800df7030ac187d09c59dc40df1c878b4fab8669bdc805535dquestionary-2.0.1.tar.gz"
    sha256 "bcce898bf3dbb446ff62830c86c5c6fb9a22a54146f0f5597d3da43b10d8fc8b"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages6c6353559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    params = %w[
      -d python=true
      -d js=true
      -d ansible=false
      -d biggest_kbs=1000
      -d main_branches=null
      -d github=true
    ]
    system bin"copier", "copy", *params, "--vcs-ref=v0.1.0",
      "https:github.comcopier-orgautopretty.git", "template"
    assert (testpath"template").directory?
    assert_predicate testpath"template.copier-answers.autopretty.yml", :exist?
  end
end