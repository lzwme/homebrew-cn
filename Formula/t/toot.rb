class Toot < Formula
  include Language::Python::Virtualenv

  desc "Mastodon CLI & TUI"
  homepage "https:toot.bezdomni.net"
  url "https:files.pythonhosted.orgpackagese401dcfb2d4fd58a5c96d99d9ff98f7a48cf0813e4a615b5953da11e67374075toot-0.43.0.tar.gz"
  sha256 "6aa84c4b8df6e2214a3e735142bf5bd57b3b10aa08e35579425c5dbe3bc25ae7"
  license "GPL-3.0-only"
  revision 4
  head "https:github.comihabunektoot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b9a481ebcfed19fa1042b726e6615848d77906ab527f2eb2f0b244d50c6e0134"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b9a481ebcfed19fa1042b726e6615848d77906ab527f2eb2f0b244d50c6e0134"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9a481ebcfed19fa1042b726e6615848d77906ab527f2eb2f0b244d50c6e0134"
    sha256 cellar: :any_skip_relocation, sonoma:         "bfabd53f011a7213051083a017590460051816b0bf46226b8dfd08011bc12df7"
    sha256 cellar: :any_skip_relocation, ventura:        "bfabd53f011a7213051083a017590460051816b0bf46226b8dfd08011bc12df7"
    sha256 cellar: :any_skip_relocation, monterey:       "f113a9d8a56944535291cecdf69a412d1ee2b5c512fa4102dbe65e0eff7de71d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c5c2ff3b39211083faafb5260b67b4c66dc63607164a93cddfde1803647de6f"
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
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
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
    url "https:files.pythonhosted.orgpackages2bab18f4c8f2bec75eb1a7aebcc52cdb02ab04fd39ff7025bb1b1c7846cc45b8tomlkit-0.12.5.tar.gz"
    sha256 "eef34fba39834d4d6b73c9ba7f3e4d1c417a4e56f89a7e96e090dd0d24b8fb3c"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesdfdbf35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages436dfa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  resource "urwid" do
    url "https:files.pythonhosted.orgpackagesdb1b5dfd51ee4b31bfdeed32390bfd9bb66ade9227bc9e6472045723d140fca7urwid-2.6.14.tar.gz"
    sha256 "feeafc4fa9343fdfa1e9b01914064a4a9399ec746b814a550d44462e5ef85c72"
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