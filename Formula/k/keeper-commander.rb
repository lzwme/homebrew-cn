class KeeperCommander < Formula
  include Language::Python::Virtualenv

  desc "Command-line and SDK interface to Keeper Password Manager"
  homepage "https:docs.keeper.ioenprivileged-access-managercommander-clioverview"
  url "https:files.pythonhosted.orgpackagesde0dfab8514dd3a522b1a2a66e9ed7e425b6c2aad1c2034e5923c1f873c0c6a8keepercommander-17.0.8.tar.gz"
  sha256 "e3c082c02132b22e0e20d44b7c6440a0663941e5e3b405cedc13745fccd80a3f"
  license "MIT"
  head "https:github.comKeeper-SecurityCommander.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "728a5d165e650e94d98b33be4a0b65db4c2a3ad55852c8d3b61be2a9052111ac"
    sha256 cellar: :any,                 arm64_sonoma:  "2783108c6fb02eaa3ca64242508f9866d4895e1e0b93b69a020d519e5d6aadc4"
    sha256 cellar: :any,                 arm64_ventura: "05fab0098f7954b7eafd49b1bc68fd87e16de11b06225f3948b090b68fedbb47"
    sha256 cellar: :any,                 sonoma:        "10ba16f0a00b17ac94e02a5d9c655c8850b9a9d6d7eb422fad19502b5310a34d"
    sha256 cellar: :any,                 ventura:       "354e0651a47ec314d938fc90188a34726b7fe4e8c13ef5b46c61bba6a3e8958b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b31d05ae22bc75fc901390b96758e91bd83b5f9aeb0bbe3f2e0d5eb8a44897c8"
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
    url "https:files.pythonhosted.orgpackagesbb5d6d7433e0f3cd46ce0b43cd65e1db465ea024dbb8216fb2404e919c2ad77bbcrypt-4.3.0.tar.gz"
    sha256 "3a3fd2204178b6d2adcf09cb4f6426ffef54762577a7c9b54c159008cb288c18"
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
    url "https:files.pythonhosted.orgpackagesd15343d99d7687e8cdef5ab5f9ec5eaf2c0423c2b35133a2b7e7bc276fc32b21setuptools-75.8.2.tar.gz"
    sha256 "4880473a969e5f23f2a2be3646b2dfd84af9028716d398e46192f84bc36900d2"
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