class KeeperCommander < Formula
  include Language::Python::Virtualenv

  desc "Command-line and SDK interface to Keeper Password Manager"
  homepage "https:docs.keeper.ioenprivileged-access-managercommander-clioverview"
  url "https:files.pythonhosted.orgpackages887da2e829e26939837214e59c612e4a94d623ff14ac5456a7dbbd36d1c9686ekeepercommander-17.0.6.tar.gz"
  sha256 "0a5f36db2c74301211f41cc169b064533884912b392ea6b135bea63fa4fd3ab1"
  license "MIT"
  head "https:github.comKeeper-SecurityCommander.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "9b86aef722c3f6c044bfd06164d19b07a2274aad265a1d9efa2259fe576b17d2"
    sha256 cellar: :any,                 arm64_sonoma:  "6c07f2e41a45d114a444bd1fb95068057e7fc662d4d84708b68544e678d8913a"
    sha256 cellar: :any,                 arm64_ventura: "bc76942aad21e77df1fe2cbd8f68074405f83737feaf36b189b931f5dfb6b574"
    sha256 cellar: :any,                 sonoma:        "e1d6a15227de6d0e90d721110b468beace476e56fd00e9a6c020bd45eeffaa72"
    sha256 cellar: :any,                 ventura:       "400c94398a91548e1e2ef75ac5083362931e38e59d456dcca90c174fb7ad5008"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b433ccdcf01491147e7b8e2e89fe82528f7e3770f6667a5b7024dfb8f643bc19"
  end

  # bcrypt dependencies
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.13"

  resource "annotated-types" do
    url "https:files.pythonhosted.orgpackagesee67531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "asciitree" do
    url "https:files.pythonhosted.orgpackages2d6a885bc91484e1aa8f618f6f0228d76d0e67000b0fdd6090673b777e311913asciitree-0.3.3.tar.gz"
    sha256 "4aa4b9b649f85e3fcb343363d97564aa1fb62e249677f2e18a96765145cc0f6e"
  end

  resource "bcrypt" do
    url "https:files.pythonhosted.orgpackages568cdd696962612e4cd83c40a9e6b3db77bfe65a830f4b9af44098708584686cbcrypt-4.2.1.tar.gz"
    sha256 "6765386e3ab87f569b276988742039baab087b2cdb01e809d74e74503c2faafe"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages16b0572805e227f01586461c80e0fd25d65a2115599cc9dad142fee4b747c357charset_normalizer-3.4.1.tar.gz"
    sha256 "44251f18cd68a75b56585dd00dae26183e102cd5e0f9f1466e6df5da2ed64ea3"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "fido2" do
    url "https:files.pythonhosted.orgpackagesebcc4529123364d41f342145f2fd775307eaed817cd22810895dea10e15a4d06fido2-1.2.0.tar.gz"
    sha256 "e39f95920122d64283fda5e5581d95a206e704fa42846bfa4662f86aa0d3333b"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "importlib-metadata" do
    url "https:files.pythonhosted.orgpackages3308c1395a292bb23fd03bdf572a1357c5a733d3eecbab877641ceacab23db6eimportlib_metadata-8.6.1.tar.gz"
    sha256 "310b41d755445d74569f993ccfc22838295d9fe005425094fad953d7f15c8580"
  end

  resource "keeper-secrets-manager-core" do
    url "https:files.pythonhosted.orgpackagesc4b21e0fe5d7b64ddb98609a16e35ded1234bd2bb48a67bc302facb27adbdda1keeper_secrets_manager_core-16.6.6.tar.gz"
    sha256 "bda9e733908b34edbac956825fc062e6934894f210d49b0bba1679d167d7be80"
  end

  resource "prompt-toolkit" do
    url "https:files.pythonhosted.orgpackagesa1e1bd15cb8ffdcfeeb2bdc215de3c3cffca11408d829e4b8416dcfe71ba8854prompt_toolkit-3.0.50.tar.gz"
    sha256 "544748f3860a2623ca5cd6d2795e7a14f3d0e1c3c9728359013f79877fc89bab"
  end

  resource "protobuf" do
    url "https:files.pythonhosted.orgpackagesf7d1e0a911544ca9993e0f17ce6d3cc0932752356c1b0a834397f28e63479344protobuf-5.29.3.tar.gz"
    sha256 "5da0f41edaf117bde316404bad1a486cb4ededf8e4a54891296f648e8e076620"
  end

  resource "pycryptodomex" do
    url "https:files.pythonhosted.orgpackages11dce66551683ade663b5f07d7b3bc46434bf703491dbd22ee12d1f979ca828fpycryptodomex-3.21.0.tar.gz"
    sha256 "222d0bd05381dd25c32dd6065c071ebf084212ab79bab4599ba9e6a3e0009e6c"
  end

  resource "pydantic" do
    url "https:files.pythonhosted.orgpackagesb7aed5220c5c52b158b1de7ca89fc5edb72f304a70a4c540c84c8844bf4008depydantic-2.10.6.tar.gz"
    sha256 "ca5daa827cce33de7a42be142548b0096bf05a7e7b365aebfa5f8eeec7128236"
  end

  resource "pydantic-core" do
    url "https:files.pythonhosted.orgpackagesfc01f3e5ac5e7c25833db5eb555f7b7ab24cd6f8c322d3a3ad2d67a952dc0abcpydantic_core-2.27.2.tar.gz"
    sha256 "eb026e5a4c1fee05726072337ff51d1efb6f59090b7da90d30ea58625b1ffb39"
  end

  resource "pyperclip" do
    url "https:files.pythonhosted.orgpackages30232f0a3efc4d6a32f3b63cdff36cd398d9701d26cda58e3ab97ac79fb5e60dpyperclip-1.9.0.tar.gz"
    sha256 "b7de0142ddc81bfc5c7507eea19da920b92252b548b96186caf94a5e2527d310"
  end

  resource "pysocks" do
    url "https:files.pythonhosted.orgpackagesbd11293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages92ec089608b791d210aec4e7f97488e67ab0d33add3efccb83a056cbafe3a2a6setuptools-75.8.0.tar.gz"
    sha256 "c5afc8f407c626b8313a86e10311dd3f661c6cd9c09d4bf8c15c0e11f9f2b0e6"
  end

  resource "tabulate" do
    url "https:files.pythonhosted.orgpackagesecfe802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesdfdbf35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesaa63e53da845320b757bf29ef6a9062f5c669fe997973f966045cb019c3f4b66urllib3-2.3.0.tar.gz"
    sha256 "f8c5449b3cf0861679ce7e0503c7b44b5ec981bec0d1d3795a07f1ba96f0204d"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages6c6353559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  resource "websockets" do
    url "https:files.pythonhosted.orgpackages2e7a8bc4d15af7ff30f7ba34f9a172063bfcee9f5001d7cef04bee800a658f33websockets-15.0.tar.gz"
    sha256 "ca36151289a15b39d8d683fd8b7abbe26fc50be311066c5f8dcf3cb8cee107ab"
  end

  resource "zipp" do
    url "https:files.pythonhosted.orgpackages3f50bad581df71744867e9468ebd0bcd6505de3b275e06f202c2cb016e3ff56fzipp-3.21.0.tar.gz"
    sha256 "2c9958f6430a2040341a52eb608ed6dd93ef4392e02ffe219417c1b28b5dd1f4"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "keepersecurity.com", shell_output("#{bin}keeper server")
  end
end