class Grip < Formula
  include Language::Python::Virtualenv

  desc "GitHub Markdown previewer"
  homepage "https:github.comjoeyespogrip"
  url "https:files.pythonhosted.orgpackagesf43fe8bc3ea1f24877292fa3962ad9e0234ad4bc787dc1eb5bd08c35afd0cecagrip-4.6.2.tar.gz"
  sha256 "3cf6dce0aa06edd663176914069af83f19dcb90f3a9c401271acfa71872f8ce3"
  license "MIT"
  revision 6

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2bde33d0566faacfeda1e158dd3bc85afdcca1ea41c7b539d391950d6a6c748f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f4f75e3204bc5e9629687d5d943993fdc59274189debe70f637bd5d4643cfe4a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7233745bdfb3f1584b78cb364a3234d3eaf8569400a9e73a5b062917f772cd70"
    sha256 cellar: :any_skip_relocation, sonoma:         "5c20662ce2da0881c2e46c3747b5daf794c3f87e928406f25deac73e541eed57"
    sha256 cellar: :any_skip_relocation, ventura:        "ae52c451176dd1dc7326dbb904e53682f3fe6b23dc2458c3168e3506ce8ca623"
    sha256 cellar: :any_skip_relocation, monterey:       "c538678eab502610c0156c16ea70e371c96f20d7d2c816b964a256df47a8c99e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6c6e7c443e7dc282f12c3891d76031bc8746b2fd2dba358c1ed293135b72e3f"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "blinker" do
    url "https:files.pythonhosted.orgpackages1e57a6a1721eff09598fb01f3c7cda070c1b6a0f12d63c83236edf79a440abccblinker-1.8.2.tar.gz"
    sha256 "8f77b09d3bf7c795e969e9486f39c2c5e9c39d4ee07424be2bc594ece9642d83"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "docopt" do
    url "https:files.pythonhosted.orgpackagesa2558f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "flask" do
    url "https:files.pythonhosted.orgpackages41e1d104c83026f8d35dfd2c261df7d64738341067526406b40190bc063e829aflask-3.0.3.tar.gz"
    sha256 "ceb27b0af3823ea2737928a4d99d125a06175b8512c445cbd9a9ce200ef76842"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "itsdangerous" do
    url "https:files.pythonhosted.orgpackages9ccb8ac0172223afbccb63986cc25049b154ecfb5e85932587206f42317be31ditsdangerous-2.2.0.tar.gz"
    sha256 "e0050c0b7da1eea53ffaf149c0cfbb5c6e2e2b69c4bef22c81fa6eb73e5f6173"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesed5539036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5djinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
  end

  resource "markdown" do
    url "https:files.pythonhosted.orgpackages22024785861427848cc11e452cc62bb541006a1087cf04a1de83aedd5530b948Markdown-3.6.tar.gz"
    sha256 "ed4f41f6daecbeeb96e576ce414c41d2d876daa9a16cb35fa8ed8c2ddfad0224"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackages875baae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02dMarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "path-and-address" do
    url "https:files.pythonhosted.orgpackages2bb5749fab14d9e84257f3b0583eedb54e013422b6c240491a4ae48d9ea5e44fpath-and-address-2.0.1.zip"
    sha256 "e96363d982b3a2de8531f4cd5f086b51d0248b58527227d43cf5014d045371b7"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages8e628336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackagesd8c1f32fb7c02e7620928ef14756ff4840cae3b8ef1d62f7e596bc5413300a16requests-2.32.1.tar.gz"
    sha256 "eb97e87e64c79e64e5b8ac75cee9dd1f97f49e289b083ee6be96268930725685"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages7a507fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  resource "werkzeug" do
    url "https:files.pythonhosted.orgpackages02512e0fc149e7a810d300422ab543f87f2bcf64d985eb6f1228c4efd6e4f8d4werkzeug-3.0.3.tar.gz"
    sha256 "097e5bfda9f0aba8da6b8545146def481d06aa7d3266e7448e2cccf67dd8bd18"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "<strong>Homebrew<strong> is awesome",
                 pipe_output("#{bin}grip - --export -", "**Homebrew** is awesome.")
  end
end