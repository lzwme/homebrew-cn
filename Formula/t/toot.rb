class Toot < Formula
  include Language::Python::Virtualenv

  desc "Mastodon CLI & TUI"
  homepage "https:toot.bezdomni.net"
  url "https:files.pythonhosted.orgpackages81be185a52bc194f00e02875b3dd3161ac8022e5cd6c365b5e90baa65c5ce229toot-0.44.1.tar.gz"
  sha256 "2887ba4c81c0a28448b260804ba6ac1f16178c188cd3a04621912acf764c9bd7"
  license "GPL-3.0-only"
  head "https:github.comihabunektoot.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "721cf94063d1e683ede64cdd0c0641dbe7dba08a83a113ddca89558a453ca413"
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
    url "https:files.pythonhosted.orgpackages39877e8ba20702294ee8b750427c2600308c20f39ddf3b0f73250dc43ef13038term_image-0.7.2.tar.gz"
    sha256 "07320573baa667dcde145d55e94769cbaafeea43b61245245153ff5075b55ffb"
  end

  resource "tomlkit" do
    url "https:files.pythonhosted.orgpackages4b34f5f4fbc6b329c948a90468dd423aaa3c3bfc1e07d5a76deec269110f2f6etomlkit-0.13.0.tar.gz"
    sha256 "08ad192699734149f5b97b45f1f18dad7eb1b6d16bc72ad0c2335772650d7b72"
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
    url "https:files.pythonhosted.orgpackages85b7516b0bbb7dd9fc313c6443b35d86b6f91b3baa83d2c4016e4d8e0df5a5e3urwid-2.6.15.tar.gz"
    sha256 "9ecc57330d88c8d9663ffd7092a681674c03ff794b6330ccfef479af7aa9671b"
  end

  resource "urwidgets" do
    url "https:files.pythonhosted.orgpackages606de7847c2a472bf16b87e4ecc3764bb059631fa5453d4148f3bb5cdd81e301urwidgets-0.2.0.tar.gz"
    sha256 "d41acf9d9f8d576cb580bc042919b209c5aeeb60e1f81052809c63f31c4e7688"
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