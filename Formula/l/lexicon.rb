class Lexicon < Formula
  include Language::Python::Virtualenv

  desc "Manipulate DNS records on various DNS providers in a standardized way"
  homepage "https:github.comAnalogJlexicon"
  url "https:files.pythonhosted.orgpackages01a60e889bff0516d3cfec95d78139f896c31e89639a8e1f9bc93a5b7be363f7dns_lexicon-3.17.0.tar.gz"
  sha256 "25871a7c145095ee21405525077856eadc059ab7692ae4c333f16563385d3c40"
  license "MIT"
  head "https:github.comAnalogJlexicon.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a4b2079a5e887dfbb11ce8d2dba15ac73e3b29a5adbbec5f6ea973ddd2c4cc7f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a019c557c8f71f656e54c67eccaa4cc6aa05dd4948ae78c45e28f7d582a059a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38dbcd61813dc616df9561a8feca5c78c95b7fe2ea0840473014729c66917642"
    sha256 cellar: :any_skip_relocation, sonoma:         "0d625b5af54b3e3cbb202490071e472fd6d67b1c89b9a45d45188a2427fabaab"
    sha256 cellar: :any_skip_relocation, ventura:        "d00360249bc5bf3f5bca95893a76009f01ee80af5f7453fbddaf6aecffafb132"
    sha256 cellar: :any_skip_relocation, monterey:       "90102a6ac38af9c308f42f2c115798d9159447eeea3250c94bd04fdb9622c1bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae88973e02df1de7485110c73852c91629c77453d5e4be187fe6ba21490eb9ed"
  end

  depends_on "cffi"
  depends_on "pycparser"
  depends_on "pygments"
  depends_on "python-certifi"
  depends_on "python-cryptography"
  depends_on "python-lxml"
  depends_on "python-pytz"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  resource "attrs" do
    url "https:files.pythonhosted.orgpackages979081f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbbattrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "beautifulsoup4" do
    url "https:files.pythonhosted.orgpackagesaf0b44c39cf3b18a9280950ad63a579ce395dda4c32193ee9da7ff0aed547094beautifulsoup4-4.12.2.tar.gz"
    sha256 "492bbc69dca35d12daac71c4db1bfff0c876c00ef4a2ffacce226d4638eb72da"
  end

  resource "boto3" do
    url "https:files.pythonhosted.orgpackages32e0451d5ff97dd90376224ba54c6771ead856b020c74939d16f7923f88bc601boto3-1.28.79.tar.gz"
    sha256 "b8acb57a124434284d6ab69c61d32d70e84e13e2c27c33b4ad3c32f15ad407d3"
  end

  resource "botocore" do
    url "https:files.pythonhosted.orgpackages644ac4829451faaf9c7b670a4520864e6838bdbb7eec7b92450d879e4b8e4d1abotocore-1.31.79.tar.gz"
    sha256 "07ecb93833475dde68e5c0e02a7ccf8ca22caf68cdc892651c300529894133e1"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "circuitbreaker" do
    url "https:files.pythonhosted.orgpackages92ec7f1dd19e3878f5391afb508e6a2fd8d9e5b176ca2992b90b55926c7341d8circuitbreaker-1.4.0.tar.gz"
    sha256 "80b7bda803d9a20e568453eb26f3530cd9bf602d6414f6ff6a74c611603396d2"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "dnspython" do
    url "https:files.pythonhosted.orgpackages652d372a20e52a87b2ba0160997575809806111a72e18aa92738daccceb8d2b9dnspython-2.4.2.tar.gz"
    sha256 "8dcfae8c7460a2f84b4072e26f1c9f4101ca20c071649cb7c34e8b6a93d58984"
  end

  resource "filelock" do
    url "https:files.pythonhosted.orgpackages707041905c80dcfe71b22fb06827b8eae65781783d4a14194bce79d16a013263filelock-3.13.1.tar.gz"
    sha256 "521f5f56c50f8426f5e03ad3b281b490a87ef15bc6c526f168290f0c7148d44e"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages8be143beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "isodate" do
    url "https:files.pythonhosted.orgpackagesdb7ac0a56c7d56c7fa723988f122fa1f1ccf8c5c4ccc48efad0d214b49e5b1afisodate-0.6.1.tar.gz"
    sha256 "48c5881de7e8b0a0d648cb024c8062dc84e7b840ed81e864c7614fd3c127bde9"
  end

  resource "jmespath" do
    url "https:files.pythonhosted.orgpackages002ae867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "localzone" do
    url "https:files.pythonhosted.orgpackagesf91a2406e73b9dedafc761526687a60a09aaa8b0b2f2268aa084c56cbed81959localzone-0.9.8.tar.gz"
    sha256 "23cb6b55a620868700b3f44e93d7402518e08eb7960935b3352ad3905c964597"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "oci" do
    url "https:files.pythonhosted.orgpackages4286d4a0d41d6e0772649ef51f8dc6291f65e95598bc117623a8c076beb6ac0aoci-2.115.0.tar.gz"
    sha256 "08bfe2d4bfe449a4f968e7c26a25719cc6ae52de9d4d8396944f45657ef5ba51"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackagesd3e3aa14d6b2c379fbb005993514988d956f1b9fdccd9cbe78ec0dbe5fb79bf5platformdirs-3.11.0.tar.gz"
    sha256 "cf8ee52a3afdb965072dcc652433e0c7e3e40cf5ea1477cd4b3b1d2eb75495b3"
  end

  resource "prettytable" do
    url "https:files.pythonhosted.orgpackagese1c05e9c4d2a643a00a6f67578ef35485173de273a4567279e4f0c200c01386bprettytable-3.9.0.tar.gz"
    sha256 "f4ed94803c23073a90620b201965e5dc0bccf1760b7a7eaf3158cab8aaffdf34"
  end

  resource "prompt-toolkit" do
    url "https:files.pythonhosted.orgpackages9a0276cadde6135986dc1e82e2928f35ebeb5a1af805e2527fe466285593a2baprompt_toolkit-3.0.39.tar.gz"
    sha256 "04505ade687dc26dc4284b1ad19a83be2f2afe83e7a828ace0c72f3a1df72aac"
  end

  resource "pyopenssl" do
    url "https:files.pythonhosted.orgpackagesbfa0e667c3c43b65a188cc3041fa00c50655315b93be45182b2c94d185a2610epyOpenSSL-23.3.0.tar.gz"
    sha256 "6b2cba5cc46e822750ec3e5a81ee12819850b11303630d575e98108a079c2b12"
  end

  resource "pyotp" do
    url "https:files.pythonhosted.orgpackagesf3b21d5994ba2acde054a443bd5e2d384175449c7d2b6d1a0614dbca3a63abfcpyotp-2.9.0.tar.gz"
    sha256 "346b6642e0dbdde3b4ff5a930b664ca82abfa116356ed48cc42c7d6590d36f63"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages4cc413b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-file" do
    url "https:files.pythonhosted.orgpackages505cd32aeed5c91e7970ee6ab8316c08d911c1d6044929408f6bbbcc763f8019requests-file-1.5.1.tar.gz"
    sha256 "07d74208d3389d01c38ab89ef403af0cfec63957d53a0081d8eca738d0247d8e"
  end

  resource "requests-toolbelt" do
    url "https:files.pythonhosted.orgpackagesf361d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bbrequests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesb10ee5aa3ab6857a16dadac7a970b2e1af21ddf23f03c99248db2c01082090a3rich-13.6.0.tar.gz"
    sha256 "5c14d22737e6d5084ef4771b62d5d4363165b403455a30a1c8ca39dc7b644bef"
  end

  resource "s3transfer" do
    url "https:files.pythonhosted.orgpackages3fff5fd9375f3fe467263cff9cad9746fd4c4e1399440ea9563091c958ff90b5s3transfer-0.7.0.tar.gz"
    sha256 "fd3889a66f5fe17299fe75b82eae6cf722554edca744ca5d5fe308b104883d2e"
  end

  resource "softlayer" do
    url "https:files.pythonhosted.orgpackages7195e43de5361a9b2c9255ae373f9fe342c3ff802edeb2c4c5c82816647925c1SoftLayer-6.1.10.tar.gz"
    sha256 "3263af56608d02f5f5b1df11954531ec87f46b4e15b7baa6081b810067b1bc82"
  end

  resource "soupsieve" do
    url "https:files.pythonhosted.orgpackagesce21952a240de1c196c7e3fbcd4e559681f0419b1280c617db21157a0390717bsoupsieve-2.5.tar.gz"
    sha256 "5663d5a7b3bfaeee0bc4372e7fc48f9cff4940b3eec54a6451cc5299f1097690"
  end

  resource "tldextract" do
    url "https:files.pythonhosted.orgpackages29936291afba24410e9925ac825e415c7b875b6246fc541fd619cbadc3a97acatldextract-5.1.0.tar.gz"
    sha256 "366acfb099c7eb5dc83545c391d73da6e3afe4eaec652417c3cf13b002a160e1"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesaf47b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3curllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackagesa6ad428bc4ff924e66365c96994873e09a17bb5e8a1228be6e8d185bc2a11de9wcwidth-0.2.9.tar.gz"
    sha256 "a675d1a4a2d24ef67096a04b85b02deeecd8e226f57b5e3a72dbb9ed99d27da8"
  end

  resource "zeep" do
    url "https:files.pythonhosted.orgpackagesfda48fa2337f1807fd9e671b85980b2c90052d524edf9d39b515aed4c5874c38zeep-4.2.1.tar.gz"
    sha256 "72093acfdb1d8360ed400869b73fbf1882b95c4287f798084c42ee0c1ff0e425"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}lexicon route53 list brew.sh TXT 2>&1", 1)
    assert_match "Unable to locate credentials", output

    output = shell_output("#{bin}lexicon cloudflare create domain.net TXT --name foo --content bar 2>&1", 1)
    assert_match "400 Client Error: Bad Request for url", output

    assert_match "lexicon #{version}", shell_output("#{bin}lexicon --version")
  end
end