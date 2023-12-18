class OktaAwscli < Formula
  include Language::Python::Virtualenv

  desc "Okta authentication for awscli"
  homepage "https:github.comokta-awscliokta-awscli"
  url "https:files.pythonhosted.orgpackagesaad31c954881dea1d1ceccbf54353fb26c4487a8c4702dd415ac44744e306c97okta-awscli-0.5.4.tar.gz"
  sha256 "509921a38dedc6fa1424f06e5bb94a5bb359463912c45218abdf6095b3aac821"
  license "Apache-2.0"
  revision 3

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c81041f8a90c8269d2b704efc650ea9eac43e9ad42a38316f339b50dd1610cde"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "502598946f2cf74b16ddf1cdb167e1d214cc029fdc98f09478db79ea928fa13b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3aebdebea352f84556fea31ec90f46a6c6c1bb5062a91534d3fe42cad157c825"
    sha256 cellar: :any_skip_relocation, sonoma:         "b83a13343e1f836ab2ebc63b91d2c095e72d89d911060faa1874210ee06f3019"
    sha256 cellar: :any_skip_relocation, ventura:        "ade594c9bf959589da1df856146eb81b5453c992763b3379330e081c8f3e8ceb"
    sha256 cellar: :any_skip_relocation, monterey:       "1b08fb2e81609b0413f63996315d26defd5e85269cdda415e01f7aa96cfdaf8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44c2d64dc7016ece92fd265fa11539a46c5b6d4faeea795f18ece1a24e276599"
  end

  depends_on "python-certifi"
  depends_on "python-click"
  depends_on "python@3.12"
  depends_on "six"

  resource "beautifulsoup4" do
    url "https:files.pythonhosted.orgpackagesaf0b44c39cf3b18a9280950ad63a579ce395dda4c32193ee9da7ff0aed547094beautifulsoup4-4.12.2.tar.gz"
    sha256 "492bbc69dca35d12daac71c4db1bfff0c876c00ef4a2ffacce226d4638eb72da"
  end

  resource "boto3" do
    url "https:files.pythonhosted.orgpackages1b2f4ccd05e765a9aa3222125da37ceced40b4133094069c4d011ca7ae37681fboto3-1.28.65.tar.gz"
    sha256 "9d52a1605657aeb5b19b09cfc01d9a92f88a616a5daf5479a59656d6341ea6b3"
  end

  resource "botocore" do
    url "https:files.pythonhosted.orgpackages4230e5e2126eca77baedbf51e48241c898d99784d272bcf2fb47f5a10360e555botocore-1.31.65.tar.gz"
    sha256 "90716c6f1af97e5c2f516e9a3379767ebdddcc6cbed79b026fa5038ce4e5e43e"
  end

  resource "bs4" do
    url "https:files.pythonhosted.orgpackages10ed7e8b97591f6f456174139ec089c769f89a94a1a4025fe967691de971f314bs4-0.0.1.tar.gz"
    sha256 "36ecea1fd7cc5c0c6e4a1ff075df26d50da647b75376626cc186e2212886dd3a"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagescface89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "configparser" do
    url "https:files.pythonhosted.orgpackages0b65bad3eb64f30657ee9fa2e00e80b3ad42037db5eb534fadd15a94a11fe979configparser-6.0.0.tar.gz"
    sha256 "ec914ab1e56c672de1f5c3483964e68f71b34e457904b7b76e06b922aec067a8"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages8be143beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "jmespath" do
    url "https:files.pythonhosted.orgpackages002ae867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages4cc413b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "s3transfer" do
    url "https:files.pythonhosted.orgpackages3fff5fd9375f3fe467263cff9cad9746fd4c4e1399440ea9563091c958ff90b5s3transfer-0.7.0.tar.gz"
    sha256 "fd3889a66f5fe17299fe75b82eae6cf722554edca744ca5d5fe308b104883d2e"
  end

  resource "soupsieve" do
    url "https:files.pythonhosted.orgpackagesce21952a240de1c196c7e3fbcd4e559681f0419b1280c617db21157a0390717bsoupsieve-2.5.tar.gz"
    sha256 "5663d5a7b3bfaeee0bc4372e7fc48f9cff4940b3eec54a6451cc5299f1097690"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesaf47b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3curllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  resource "validators" do
    url "https:files.pythonhosted.orgpackages9b2140a249498eee5a244a017582c06c0af01851179e2617928063a3d628bc8fvalidators-0.22.0.tar.gz"
    sha256 "77b2689b172eeeb600d9605ab86194641670cdb73b60afd577142a9397873370"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal <<~EOS, shell_output("#{bin}okta-awscli 2>&1", 1)
      ERROR - The app-link is missing. Will try to retrieve it from Okta
      ERROR - No profile found. Please define a default profile, or specify a named profile using `--okta-profile`
    EOS
  end
end