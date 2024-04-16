class Toot < Formula
  include Language::Python::Virtualenv

  desc "Mastodon CLI & TUI"
  homepage "https:toot.bezdomni.net"
  url "https:files.pythonhosted.orgpackagese401dcfb2d4fd58a5c96d99d9ff98f7a48cf0813e4a615b5953da11e67374075toot-0.43.0.tar.gz"
  sha256 "6aa84c4b8df6e2214a3e735142bf5bd57b3b10aa08e35579425c5dbe3bc25ae7"
  license "GPL-3.0-only"
  revision 1
  head "https:github.comihabunektoot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "894d51f95063a3249303e3ba26826049547e5ca31e576715658fb85d4b0c26ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "894d51f95063a3249303e3ba26826049547e5ca31e576715658fb85d4b0c26ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "894d51f95063a3249303e3ba26826049547e5ca31e576715658fb85d4b0c26ee"
    sha256 cellar: :any_skip_relocation, sonoma:         "894d51f95063a3249303e3ba26826049547e5ca31e576715658fb85d4b0c26ee"
    sha256 cellar: :any_skip_relocation, ventura:        "894d51f95063a3249303e3ba26826049547e5ca31e576715658fb85d4b0c26ee"
    sha256 cellar: :any_skip_relocation, monterey:       "894d51f95063a3249303e3ba26826049547e5ca31e576715658fb85d4b0c26ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "190130cfa7183586b536bc38f93ee6c410ba2e114546abd521ed4347ca888373"
  end

  depends_on "certifi"
  depends_on "pillow"
  depends_on "python@3.12"

  resource "beautifulsoup4" do
    url "https:files.pythonhosted.orgpackagesb3ca824b1195773ce6166d388573fc106ce56d4a805bd7427b624e063596ec58beautifulsoup4-4.12.3.tar.gz"
    sha256 "74e3d1928edc070d21748185c46e3fb33490f22f52a3addee9aee0f4f7781051"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "soupsieve" do
    url "https:files.pythonhosted.orgpackagesce21952a240de1c196c7e3fbcd4e559681f0419b1280c617db21157a0390717bsoupsieve-2.5.tar.gz"
    sha256 "5663d5a7b3bfaeee0bc4372e7fc48f9cff4940b3eec54a6451cc5299f1097690"
  end

  resource "term-image" do
    url "https:files.pythonhosted.orgpackagesf259019a0ca982be3e6d686b9c58a72ae26333b69f8a312ea6edcbefef57279bterm-image-0.7.0.tar.gz"
    sha256 "d62d85b62b58a90576b2dc22478aeee7eb71bfac169862a0abc94c9f494c8b0c"
  end

  resource "tomlkit" do
    url "https:files.pythonhosted.orgpackages7d494c0764898ee67618996148bdba4534a422c5e698b4dbf4001f7c6f930797tomlkit-0.12.4.tar.gz"
    sha256 "7ca1cfc12232806517a8515047ba66a19369e71edf2439d0f5824f91032b6cc3"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesf6f3b827b3ab53b4e3d8513914586dcca61c355fa2ce8252dea4da56e67bf8f2typing_extensions-4.11.0.tar.gz"
    sha256 "83f085bd5ca59c80295fc2a82ab5dac679cbe02b9f33f7d83af68e241bea51b0"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages7a507fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  resource "urwid" do
    url "https:files.pythonhosted.orgpackages8e748c2082f2b07a72ff5d2438447c13a70f0cbede73584e0a262c166a30785curwid-2.6.10.tar.gz"
    sha256 "ae33355c414c13214e541d3634f3c8a0bfb373914e62ffbcf2fa863527706321"
  end

  resource "urwidgets" do
    url "https:files.pythonhosted.orgpackages161fcb6f188ddd62a52b3fa5694c2a541309d246dee54e6d4bc7a4079b2bbc59urwidgets-0.1.1.tar.gz"
    sha256 "1e0dbceb875ace11067d93a585d8842a011db14ce78ec69ed485dc0df17f09e7"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages6c6353559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}toot --version")
    assert_equal "You are not logged in to any accounts", shell_output("#{bin}toot auth").chomp
  end
end