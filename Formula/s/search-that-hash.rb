class SearchThatHash < Formula
  include Language::Python::Virtualenv

  desc "Searches Hash APIs to crack your hash quickly"
  homepage "https:github.comHashPalsSearch-That-Hash"
  url "https:files.pythonhosted.orgpackages5eb9a304a92ba77a9e18b3023b66634e71cded5285cef7e3b56d3c1874e9d84esearch-that-hash-0.2.8.tar.gz"
  sha256 "384498abbb9a611aa173b20d06b135e013674670fecc01b34d456bfe536e0bca"
  license "GPL-3.0-or-later"
  revision 6
  head "https:github.comHashPalsSearch-That-Hash.git", branch: "main"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "17654735e1baf8b042d8c7a92a00e17cd3a433efcdfe0ce56c30a42c2da3959f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7d51e7d193f54d08a081687027a664177d71932fc881139fcadd36c1edf5fa5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a01765e1dc9dfac4f70c21f47731e1105e989a9a27d3e1f89412f302ba5eb587"
    sha256 cellar: :any_skip_relocation, sonoma:         "684477d36b05479cff5582e39842cb6d48783e8fc952c6cd798466549d17cbe8"
    sha256 cellar: :any_skip_relocation, ventura:        "eeabb7c5facfdca4d0c043423cf0764a4466970e553b52b2112cf6df0f4c88db"
    sha256 cellar: :any_skip_relocation, monterey:       "42cafebad9031752587e30fb669bcd69b8a119ec2ebd6cafe0917731fcab0e22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec8c7ccca37beba0d9bd61823a97a32d65348ec99823e1d6243f2d736e9a1c63"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "appdirs" do
    url "https:files.pythonhosted.orgpackagesd7d805696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages276fbe940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720eclick-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "cloudscraper" do
    url "https:files.pythonhosted.orgpackagesac256d0481860583f44953bd791de0b7c4f6d7ead7223f8a17e776247b34a5b4cloudscraper-1.2.71.tar.gz"
    sha256 "429c6e8aa6916d5bad5c8a5eac50f3ea53c9ac22616f6cb21b18dcc71517d0d3"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "coloredlogs" do
    url "https:files.pythonhosted.orgpackagesccc7eed8f27100517e8c0e6b923d5f0845d0cb99763da6fdee00478f91db7325coloredlogs-15.0.1.tar.gz"
    sha256 "7c991aa71a4577af2f82600d8f8f3a89f936baeaf9b50a9c197da014e5bf16b0"
  end

  resource "commonmark" do
    url "https:files.pythonhosted.orgpackages6048a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "humanfriendly" do
    url "https:files.pythonhosted.orgpackagescc3f2c29224acb2e2df4d2046e4c73ee2662023c58ff5b113c4c1adac0886c43humanfriendly-10.0.tar.gz"
    sha256 "6b0b831ce8f15f7300721aa49829fc4e83921a9a301cc7f606be6686a2288ddc"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesbf3fea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "loguru" do
    url "https:files.pythonhosted.orgpackages6d250d65383fc7b4f4ce9505d16773b2b2a9f0f465ef00ab337d66afff47594aloguru-0.5.3.tar.gz"
    sha256 "b28e72ac7a98be3d28ad28570299a393dfcd32e5e3f6a353dec94675767b6319"
  end

  resource "name-that-hash" do
    url "https:files.pythonhosted.orgpackages32581f4052bd4999c5aceb51c813cc8ef32838561c8fb18f90cf4b86df6bd818name-that-hash-1.10.0.tar.gz"
    sha256 "aabe1a3e23f5f8ca1ef6522eb1adcd5c69b5fed3961371ed84a22fc86ee648a2"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages55598bccf4157baf25e4aa5a0bb7fa3ba8600907de105ebc22b0c78cfbf6f565pygments-2.17.2.tar.gz"
    sha256 "da46cec9fd2de5be3a8a784f434e4c4ab670b4ff54d605c4c2717e9d49c4c367"
  end

  resource "pyparsing" do
    url "https:files.pythonhosted.orgpackages37fe65c989f70bd630b589adfbbcd6ed238af22319e90f059946c26b4835e44bpyparsing-3.1.1.tar.gz"
    sha256 "ede28a1a32462f5a9705e07aea48001a08f7cf81a021585011deba701581a0db"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-toolbelt" do
    url "https:files.pythonhosted.orgpackagesf361d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bbrequests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesaef66ffb46f6cf0bb584e44279accd3321cb838b78b324031feb8fd9adf63ed2rich-9.13.0.tar.gz"
    sha256 "d59e94a0e3e686f0d268fe5c7060baa1bd6744abca71b45351f5850a3aaa6764"
  end

  resource "toml" do
    url "https:files.pythonhosted.orgpackagesbeba1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3ctoml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesed12c5079a15cf5c01d7f4252b473b00f7e68ee711be605b9f001528f0298b98typing_extensions-3.10.0.2.tar.gz"
    sha256 "49f75d16ff11f1cd258e1b988ccff82a3ca5570217d7ad8c5f48205dd99a677e"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages7a507fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  def install
    # Switch build-system to poetry-core to avoid rust dependency on Linux.
    # Remove when mergedreleased: https:github.comHashPalsSearch-That-Hashpull184
    inreplace "pyproject.toml", 'requires = ["poetry>=0.12"]', 'requires = ["poetry-core>=1.0"]'
    inreplace "pyproject.toml", 'build-backend = "poetry.masonry.api"', 'build-backend = "poetry.core.masonry.api"'

    virtualenv_install_with_resources
  end

  test do
    hash = "5f4dcc3b5aa765d61d8327deb882cf99"
    output = shell_output("#{bin}sth --text #{hash}")
    assert_match "#{hash}\n", output
    assert_match "Text : password\nType : MD5\n", output
  end
end