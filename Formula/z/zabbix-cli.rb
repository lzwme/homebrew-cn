class ZabbixCli < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for interacting with Zabbix monitoring system"
  homepage "https:unioslo.github.iozabbix-cli"
  url "https:files.pythonhosted.orgpackages6da4dff8b81939a4559532812e18682021345e103864fda8117a5e25c3014ae9zabbix_cli_uio-3.5.1.tar.gz"
  sha256 "0d6fcd8b8b345db029b7ca95763197bc1664ea2e35324d2ea4949bccb9f2b48f"
  license "GPL-3.0-or-later"
  head "https:github.comunioslozabbix-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5547b5925d1bc3557698f1e066b06628f9cba351413f790d91a93e6b0b3fe858"
    sha256 cellar: :any,                 arm64_sonoma:  "ec678f985ca9b82d5c8919767f370634fd5dcd268dda40bdca2f2f7e2d678c30"
    sha256 cellar: :any,                 arm64_ventura: "52bfaf3d4e86d25bdd3e8b2ac5473343ee972ce6e8b3aa914c6086c2d5732c02"
    sha256 cellar: :any,                 sonoma:        "18a8d51341dde75f4341857b9f5f1b867e2b571aff86c668020141a807f3805a"
    sha256 cellar: :any,                 ventura:       "d8164fe16eca2f430476ea603bf6a99855137614ac347efbb529c7a1dcf7b6c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "033bc128d1197e9f9df423143104d75d3b6fe6d38a1dec7b16ce57e8efb8cc4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd8373d87493813d3b8883760a55c4bd466717c871441bb723bdb71e45033918"
  end

  depends_on "rust" => :build # for pydantic_core
  depends_on "certifi"
  depends_on "python@3.13"

  resource "annotated-types" do
    url "https:files.pythonhosted.orgpackagesee67531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "anyio" do
    url "https:files.pythonhosted.orgpackagesa373199a98fc2dae33535d6b8e8e6ec01f8c1d76c9adb096c6b7d64823038cdeanyio-4.8.0.tar.gz"
    sha256 "1d9fe889df5212298c0c0723fa20479d1b94883a2df44bd3897aa91083316f7a"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackagesb92e0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8bclick-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "h11" do
    url "https:files.pythonhosted.orgpackagesf5383af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "httpcore" do
    url "https:files.pythonhosted.orgpackages6a41d7d0a89eb493922c37d343b607bc1b5da7f5be7e383740b4753ad8943e90httpcore-1.0.7.tar.gz"
    sha256 "8551cb62a169ec7162ac7be8d4817d561f60e08eaa485234898414bb5a8a0b4c"
  end

  resource "httpx" do
    url "https:files.pythonhosted.orgpackagesb1df48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesd06368dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106dapackaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackages13fc128cc9cb8f03208bdbf93d3aa862e16d376844a14f9a0ce5cf4507372de4platformdirs-4.3.6.tar.gz"
    sha256 "357fb2acbc885b0419afd3ce3ed34564c13c9b95c89360cd9563f73aa5e2b907"
  end

  resource "prompt-toolkit" do
    url "https:files.pythonhosted.orgpackagesa1e1bd15cb8ffdcfeeb2bdc215de3c3cffca11408d829e4b8416dcfe71ba8854prompt_toolkit-3.0.50.tar.gz"
    sha256 "544748f3860a2623ca5cd6d2795e7a14f3d0e1c3c9728359013f79877fc89bab"
  end

  resource "pydantic" do
    url "https:files.pythonhosted.orgpackagesb7aed5220c5c52b158b1de7ca89fc5edb72f304a70a4c540c84c8844bf4008depydantic-2.10.6.tar.gz"
    sha256 "ca5daa827cce33de7a42be142548b0096bf05a7e7b365aebfa5f8eeec7128236"
  end

  resource "pydantic-core" do
    url "https:files.pythonhosted.orgpackagesfc01f3e5ac5e7c25833db5eb555f7b7ab24cd6f8c322d3a3ad2d67a952dc0abcpydantic_core-2.27.2.tar.gz"
    sha256 "eb026e5a4c1fee05726072337ff51d1efb6f59090b7da90d30ea58625b1ffb39"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages7c2dc3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesab3a0316b28d0761c6734d6bc14e770d85506c986c85ffb239e688eeaab2c2bcrich-13.9.4.tar.gz"
    sha256 "439594978a49a09530cff7ebc4b5c7103ef57baf48d5ea3184f21d9a2befa098"
  end

  resource "shellingham" do
    url "https:files.pythonhosted.orgpackages58158b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58eshellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "sniffio" do
    url "https:files.pythonhosted.orgpackagesa287a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbdsniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "socksio" do
    url "https:files.pythonhosted.orgpackagesf85c48a7d9495be3d1c651198fd99dbb6ce190e2274d0f28b9051307bdec6b85socksio-1.0.0.tar.gz"
    sha256 "f88beb3da5b5c38b9890469de67d0cb0f9d494b78b106ca1845f96c10b91c4ac"
  end

  resource "strenum" do
    url "https:files.pythonhosted.orgpackages85ad430fb60d90e1d112a62ff57bdd1f286ec73a2a0331272febfddd21f330e1StrEnum-0.4.15.tar.gz"
    sha256 "878fb5ab705442070e4dd1929bb5e2249511c0bcf2b0eeacf3bcd80875c82eff"

    # py3.12 build patch, upstream pr ref, https:github.comirgeekStrEnumpull34
    patch do
      url "https:github.comirgeekStrEnumcommit896bef1b7e4a50c8b53d90c8d2fb5c0164f08ecd.patch?full_index=1"
      sha256 "1d74618b970b04d5548e9efa9134010812c20a941e26381d71bc21b06cfc667b"
    end
  end

  resource "tomli" do
    url "https:files.pythonhosted.orgpackages1887302344fed471e44a87289cf4967697d07e532f2421fdaf868a303cbae4fftomli-2.2.1.tar.gz"
    sha256 "cd45e1dc79c835ce60f7404ec8119f2eb06d38b1deba146f07ced3bbc44505ff"
  end

  resource "tomli-w" do
    url "https:files.pythonhosted.orgpackages1975241269d1da26b624c0d5e110e8149093c759b7a286138f4efd61a60e75fetomli_w-1.2.0.tar.gz"
    sha256 "2dd14fac5a47c27be9cd4c976af5a12d87fb1f0b4512f81d69cce3b35ae25021"
  end

  resource "typer" do
    url "https:files.pythonhosted.orgpackagescbcedca7b219718afd37a0068f4f2530a727c2b74a8b6e8e0c0080a4c0de4fcdtyper-0.15.1.tar.gz"
    sha256 "a0588c0a7fa68a1978a069818657778f86abe6ff5ea6abf472f940a08bfe4f0a"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesdfdbf35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages6c6353559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    # `shellingham` auto-detection doesn't work in Homebrew CI build environment so
    # defer installation to allow `typer` to use argument as shell for completions
    # Ref: https:typer.tiangolo.comfeatures#user-friendly-cli-apps
    venv = virtualenv_install_with_resources without: "shellingham"
    generate_completions_from_executable(bin"zabbix-cli", "--show-completion")
    venv.pip_install resource("shellingham")
  end

  test do
    assert_match <<~TOML, shell_output("#{bin}zabbix-cli sample_config")
      [api]
      url = "https:zabbix.example.com"
      username = "Admin"
      password = ""
      auth_token = ""
      verify_ssl = true
    TOML

    assert_match version.to_s, shell_output("#{bin}zabbix-cli --version")
  end
end