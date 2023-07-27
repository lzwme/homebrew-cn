class Gcalcli < Formula
  include Language::Python::Virtualenv

  desc "Easily access your Google Calendar(s) from a command-line"
  homepage "https://github.com/insanum/gcalcli"
  url "https://files.pythonhosted.org/packages/e8/d9/9d1f03b9b47c3082bf664a2f789a3aded0674dca9e0b894540d754b937cc/gcalcli-4.3.0.tar.gz"
  sha256 "d00081460276027196e8fb957880b29ba4f22ea43136f9e232a9408016abc110"
  license "MIT"
  revision 4
  head "https://github.com/insanum/gcalcli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f246e95721ecb4a382f003980d24319162ff4da0f75d3b505c41e535ee81d8d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ad0bf9cc0bb35e9bc57f99ddfb19aed07ae4b306ca3f2900f5f1d77f4717f73"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd9b9875506d02339df421f5cf39dbf4a8a422d166123efd66e917da6c02185c"
    sha256 cellar: :any_skip_relocation, ventura:        "65c6738544131dc9ce8ee5e4e8d539619d0d08e5aed6e5f5e5b6c058c2c19b4a"
    sha256 cellar: :any_skip_relocation, monterey:       "71291260bed99af269e946dacf2cf4c37fbbdae194f704a2d532c7fb8362eec8"
    sha256 cellar: :any_skip_relocation, big_sur:        "88f5e347283d280a706f8d6e2f1442f9b44aa79c7cd45bb822b07ea801935295"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c647103aa7fb67e6d6c9fd97a86380d87042f64fc585222e3d0b26b48c4ddd9a"
  end

  depends_on "python@3.11"
  depends_on "six"

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/9d/8b/8e2ebf5ee26c21504de5ea2fb29cc6ae612b35fd05f959cdb641feb94ec4/cachetools-5.3.1.tar.gz"
    sha256 "dce83f2d9b4e1f732a8cd44af8e8fab2dbe46201467fc98b3ef8f269092bf62b"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/98/98/c2ff18671db109c9f10ed27f5ef610ae05b73bd876664139cf95bd1429aa/certifi-2023.7.22.tar.gz"
    sha256 "539cc1d13202e33ca466e88b2807e29f4c13049d6d87031a3c110744495cb082"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/f3/b8/f727ada5b63aba53848e3791dd57be7481d5c9bf86978600ca9cca4ab03e/google-api-core-2.11.1.tar.gz"
    sha256 "25d29e05a0058ed5f19c61c0a78b1b53adea4d9364b464d014fbda941f6d1c9a"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/d2/e8/8cbc3186a98b38332db85b4537cce71f0df170a35e5cd88c1dd3be4a0aca/google-api-python-client-2.95.0.tar.gz"
    sha256 "d2731ede12f79e53fbe11fdb913dfe986440b44c0a28431c78a8ec275f4c1541"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/a4/3a/b6ab1073d2ac98c1b4f9036a4d37d5720f783bd4dc6e2c0ae516d3b13326/google-auth-2.22.0.tar.gz"
    sha256 "164cba9af4e6e4e40c3a4f90a1a6c12ee56f14c0b4868d1ca91b32826ab334ce"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/c6/b5/a9e956fd904ecb34ec9d297616fe98fa4106fc12f3b0a914dec983c267b9/google-auth-httplib2-0.1.0.tar.gz"
    sha256 "a07c39fd632becacd3f07718dfd6021bf396978f03ad3ce4321d060015cc30ac"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/28/9b/ea531afe585da044686ab13351c99dfbb2ca02b96c396874946d52d0e127/googleapis-common-protos-1.59.1.tar.gz"
    sha256 "b35d530fe825fb4227857bc47ad84c33c809ac96f312e13182bdeaa2abe1178a"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/3d/ad/2371116b22d616c194aa25ec410c9c6c37f23599dcd590502b74db197584/httplib2-0.22.0.tar.gz"
    sha256 "d7a10bc5ef5ab08322488bde8c726eeee5c8618723fdb399597ec58f3d82df81"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "oauth2client" do
    url "https://files.pythonhosted.org/packages/a6/7b/17244b1083e8e604bf154cf9b716aecd6388acd656dd01893d0d244c94d9/oauth2client-4.1.3.tar.gz"
    sha256 "d486741e451287f69568a4d26d70d9acd73a2bbfa275746c535b4209891cccc6"
  end

  resource "parsedatetime" do
    url "https://files.pythonhosted.org/packages/a8/20/cb587f6672dbe585d101f590c3871d16e7aec5a576a1694997a3777312ac/parsedatetime-2.6.tar.gz"
    sha256 "4cb368fbb18a0b7231f4d76119165451c8d2e35951455dfee97c62a87b04d455"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/d3/1c/de86d82a5fc780feca36ef52c1231823bb3140266af8a04ed6286957aa6e/protobuf-4.23.4.tar.gz"
    sha256 "ccd9430c0719dce806b93f89c91de7977304729e55377f872a92465d548329a9"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/61/ef/945a8bcda7895717c8ba4688c08a11ef6454f32b8e5cb6e352a9004ee89d/pyasn1-0.5.0.tar.gz"
    sha256 "97b7290ca68e62a832558ec3976f15cbf911bf5d7c7039d8b861c2a0ece69fde"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/3b/e4/7dec823b1b5603c5b3c51e942d5d9e65efd6ff946e713a325ed4146d070f/pyasn1_modules-0.3.0.tar.gz"
    sha256 "5bd01446b736eb9d31512a30d46c1ac3395d676c6f3cafa4c03eb54b9925631c"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/4f/13/28e88033cab976721512e7741000fb0635fa078045e530a91abb25aea0c0/pyparsing-3.1.0.tar.gz"
    sha256 "edb662d6fe322d6e990b1594b5feaeadf806803359e3d4d42f11e295e588f0ea"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/aa/65/7d973b89c4d2351d7fb232c2e452547ddfa243e93131e7cfa766da627b52/rsa-4.9.tar.gz"
    sha256 "e38464a49c6c85d7f1351b0126661487a7e0a14a50f1675ec50eb34d4f20ef21"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/d2/5a/4742fdba39cd02a56226815abfa72fe0aa81c33bed16ed045647d6000eba/uritemplate-4.1.1.tar.gz"
    sha256 "4346edfc5c3b79f694bccd6d6099a322bbeb628dbf2cd86eea55a456ce5124f0"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e2/7d/539e6f0cf9f0b95b71dd701a56dae89f768cd39fd8ce0096af3546aeb5a3/urllib3-1.26.16.tar.gz"
    sha256 "8f135f6502756bde6b2a9b28989df5fbe87c9970cecaa69041edcce7f0589b14"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output("#{bin}/gcalcli --client-id=foo --client-secret=bar --noauth_local_webserver list", "foo")
    assert_match "Go to the following link in your browser:", output
  end
end