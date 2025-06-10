class Sgr < Formula
  include Language::Python::Virtualenv

  desc "Command-line client for Splitgraph, a version control system for data"
  homepage "https:www.splitgraph.comdocssgr-advancedgetting-startedintroduction"
  url "https:files.pythonhosted.orgpackagesdd617d6cf822edb39d2426f6f185c7fc4de0ad4b80e0da3e5f50d94952795c11splitgraph-0.3.12.tar.gz"
  sha256 "76a4476002b5ac5a2b9fba36b6fcffd85b878bcc25f5aae411387e04a5532459"
  license "Apache-2.0"
  revision 13

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "db20ed00c7f28d1884e5532dc0438ca59540790898fdbaf1c58c1eef36bd632d"
    sha256 cellar: :any,                 arm64_sonoma:  "628f8550d5cc8827feaf871741a8deee69da3e65417cbea153bbc527f9c46515"
    sha256 cellar: :any,                 arm64_ventura: "f2c5752758f3ce00735b23615e30592e2a82eee38852b20f51b39272c54f4d1e"
    sha256 cellar: :any,                 sonoma:        "05ddb46cbe9fda4c3e515a497bf94a80217e3b2fdc9a23831840ba2f89c2d718"
    sha256 cellar: :any,                 ventura:       "5ffa755152d082223726bcd875552ba15fa6bff72c39f9c9b79e6040c5f00878"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ddd6bf34a9d009f71f6bf92e2954356e82b94e803c217e0e1dd85d8f36f3d43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c32a6bd8f4646c852a5155ba5609308687042831becd2410595e598604c9d303"
  end

  depends_on "rust" => :build # for pydantic
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libpq" # for psycopg2-binary
  depends_on "openssl@3"
  depends_on "python@3.13"

  resource "annotated-types" do
    url "https:files.pythonhosted.orgpackagesee67531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "argon2-cffi" do
    url "https:files.pythonhosted.orgpackages31fa57ec2c6d16ecd2ba0cf15f3c7d1c3c2e7b5fcb83555ff56d7ab10888ec8fargon2_cffi-23.1.0.tar.gz"
    sha256 "879c3e79a2729ce768ebb7d36d4609e3a78a4ca2ec3a9f12286ca057e3d0db08"
  end

  resource "argon2-cffi-bindings" do
    url "https:files.pythonhosted.orgpackagesb9e9184b8ccce6683b0aa2fbb7ba5683ea4b9c5763f1356347f1312c32e3c66eargon2-cffi-bindings-21.2.0.tar.gz"
    sha256 "bb89ceffa6c791807d1305ceb77dbfacc5aa499891d2c55661c6459651fc39e3"
  end

  resource "asciitree" do
    url "https:files.pythonhosted.orgpackages2d6a885bc91484e1aa8f618f6f0228d76d0e67000b0fdd6090673b777e311913asciitree-0.3.3.tar.gz"
    sha256 "4aa4b9b649f85e3fcb343363d97564aa1fb62e249677f2e18a96765145cc0f6e"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackages5ab01367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "chardet" do
    url "https:files.pythonhosted.orgpackagesee2d9cdc2b527e127b4c9db64b86647d567985940ac3698eeabc7ffaccb4ea61chardet-4.0.0.tar.gz"
    sha256 "0d6f53a15db4120f2b08c94f11e7d93d2c911ee118b6b30a04ec3ee8310179fa"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagese43389c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12dcharset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages276fbe940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720eclick-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "click-log" do
    url "https:files.pythonhosted.orgpackages3232228be4f971e4bd556c33d52a22682bfe318ffe57a1ddb7a546f347a90260click-log-0.4.0.tar.gz"
    sha256 "3970f8570ac54491237bcdb3d8ab5e3eef6c057df29f8c3d1151a51a9c23b975"
  end

  resource "docker" do
    url "https:files.pythonhosted.orgpackages919b4a2ea29aeba62471211598dac5d96825bb49348fa07e906ea930394a83cedocker-7.1.0.tar.gz"
    sha256 "ad8c70e6e3f8926cb8a92619b832b4ea5299e2831c14284663184e200546fa6c"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "inflection" do
    url "https:files.pythonhosted.orgpackagese17e691d061b7329bc8d54edbf0ec22fbfb2afe61facb681f9aaa9bff7a27d04inflection-0.5.1.tar.gz"
    sha256 "1a29730d366e996aaacffb2f1f1cb9593dc38e2ddd30c91250c6dde09ea9b417"
  end

  resource "joblib" do
    url "https:files.pythonhosted.orgpackages30088bd4a0250247861420a040b33ccf42f43c426ac91d99405374ef117e5872joblib-1.5.0.tar.gz"
    sha256 "d8757f955389a3dd7a23152e43bc297c2e0c2d3060056dad0feefc88a06939b5"
  end

  resource "jsonschema" do
    url "https:files.pythonhosted.orgpackages382e03362ee4034a4c917f697890ccd4aec0800ccf9ded7f511971c75451deecjsonschema-4.23.0.tar.gz"
    sha256 "d71497fef26351a33265337fa77ffeb82423f3ea21283cd9467bb03999266bc4"
  end

  resource "jsonschema-specifications" do
    url "https:files.pythonhosted.orgpackagesbfce46fbd9c8119cfc3581ee5643ea49464d168028cfb5caff5fc0596d0cf914jsonschema_specifications-2025.4.1.tar.gz"
    sha256 "630159c9f4dbea161a6a2205c3011cc4f18ff381b189fff48bb39b9bf26ae608"
  end

  resource "minio" do
    url "https:files.pythonhosted.orgpackages9e6886a1cef80396e6a35a6fc4fafee5d28578c1a137bddd3ca2aa86f9b26a22minio-7.2.15.tar.gz"
    sha256 "5247df5d4dca7bfa4c9b20093acd5ad43e82d8710ceb059d79c6eea970f49f79"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesa1d41fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24dpackaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "parsimonious" do
    url "https:files.pythonhosted.orgpackages02fc067a3f89869a41009e1a7cdfb14725f8ddd246f30f63c645e8ef8a1c56f4parsimonious-0.8.1.tar.gz"
    sha256 "3add338892d580e0cb3b1a39e4a1b427ff9f687858fdd61097053742391a9f6b"
  end

  resource "pglast" do
    url "https:files.pythonhosted.orgpackagescd0912807f704dfc3afc2bab151ead20edb6cb34a673416042f2ba5f0d6f6606pglast-7.7.tar.gz"
    sha256 "5dfbfc1fa39819643a3b915a13668e43bbd6c0b014aadf5d0b4309e860bacbb0"
  end

  resource "psycopg2-binary" do
    url "https:files.pythonhosted.orgpackagescb0ebdc8274dc0585090b4e3432267d7be4dfbfd8971c0fa59167c711105a6bfpsycopg2-binary-2.9.10.tar.gz"
    sha256 "4b3df0e6990aa98acda57d983942eff13d824135fe2250e6522edaa782a06de2"
  end

  resource "pycryptodome" do
    url "https:files.pythonhosted.orgpackages8ea68452177684d5e906854776276ddd34eca30d1b1e15aa1ee9cefc289a33f5pycryptodome-3.23.0.tar.gz"
    sha256 "447700a657182d60338bab09fdb27518f8856aecd80ae4c6bdddb67ff5da44ef"
  end

  resource "pydantic" do
    url "https:files.pythonhosted.orgpackages77ab5250d56ad03884ab5efd07f734203943c8a8ab40d551e208af81d0257bf2pydantic-2.11.4.tar.gz"
    sha256 "32738d19d63a226a52eed76645a98ee07c1f410ee41d93b4afbfa85ed8111c2d"
  end

  resource "pydantic-core" do
    url "https:files.pythonhosted.orgpackagesad885f2260bdfae97aabf98f1778d43f69574390ad787afb646292a638c923d4pydantic_core-2.33.2.tar.gz"
    sha256 "7cb8bc3605c29176e1b105350d2e6474142d7c1bd1d9327c4a9bdb46bf827acc"
  end

  resource "referencing" do
    url "https:files.pythonhosted.orgpackages2fdb98b5c277be99dd18bfd91dd04e1b759cad18d1a338188c936e92f921c7e2referencing-0.36.2.tar.gz"
    sha256 "df2e89862cd09deabbdba16944cc3f10feb6b3e6f18e902f7cc25609a34775aa"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "rpds-py" do
    url "https:files.pythonhosted.orgpackages8ca660184b7fc00dd3ca80ac635dd5b8577d444c57e8e8742cecabfacb829921rpds_py-0.25.1.tar.gz"
    sha256 "8960b6dac09b62dac26e75d7e2c4a22efb835d827a7278c34f72b2b84fa160e3"
  end

  resource "ruamel-yaml" do
    url "https:files.pythonhosted.orgpackagesd1d6eb2833ccba5ea36f8f4de4bcfa0d1a91eb618f832d430b70e3086821f251ruamel.yaml-0.17.40.tar.gz"
    sha256 "6024b986f06765d482b5b07e086cc4b4cd05dd22ddcbc758fa23d54873cf313d"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages8dd2ec1acaaff45caed5c2dedb33b67055ba9d4e96b091094df90762e60135fesetuptools-80.8.0.tar.gz"
    sha256 "49f7af965996f26d43c8ae34539c8d99c5042fbff34302ea151eaa9c207cd257"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages94e7b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sodapy" do
    url "https:files.pythonhosted.orgpackagesad1ed01ef2bc1b6199edfb0d00302fe3642d61a09175dd3e78832c78301b2ab6sodapy-2.2.0.tar.gz"
    sha256 "58af376d3bb0dc3a1edc7c8cf9938f5de8f558b35e240438dd83647ac3621981"
  end

  resource "splitgraph-pipelinewise-target-postgres" do
    url "https:files.pythonhosted.orgpackages5954de6a8a2b6bdb24de8d8fd4a2465532f3523abc750af4dd9d6e5c17ce6a53splitgraph-pipelinewise-target-postgres-2.1.0.tar.gz"
    sha256 "9d100ac65288ce24a90da159bbbb06f0fdc0871c2815c63bb6417fea7df4894f"
  end

  resource "tabulate" do
    url "https:files.pythonhosted.orgpackagesecfe802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "tqdm" do
    url "https:files.pythonhosted.orgpackagesa84b29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744dtqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesf63723083fcd6e35492953e8d2aaaa68b860eb422b34627b13f2ce3eb6106061typing_extensions-4.13.2.tar.gz"
    sha256 "e6c81219bd689f51865d9e372991c540bda33a0379d5573cddb9a3a23f7caaef"
  end

  resource "typing-inspection" do
    url "https:files.pythonhosted.orgpackagesf8b10c11f5058406b3af7609f121aaa6b609744687f1d158b3c3a5bf4cc94238typing_inspection-0.4.1.tar.gz"
    sha256 "6ae134cc0203c33377d43188d4064e9b357dba58cff3185f22924610e70a9d28"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages8a7816493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  # Switch build-system to poetry-core to avoid rust dependency on Linux.
  # Remove when mergedreleased: https:github.comsplitgraphsgrpull813
  patch do
    url "https:github.comsplitgraphsgrcommit234bcc12d21860852a40e78a22976ae33d2f2f57.patch?full_index=1"
    sha256 "1308f9172de2268cadc7ae7521a0f109df3cdc40d60f4908d69934acb777a2d5"
  end

  def install
    # Fix to allow newer `pglast`
    # PR ref: https:github.comsplitgraphsgrpull814
    inreplace "pyproject.toml", 'version = "==3.4"', 'version = ">=3.4"'

    virtualenv_install_with_resources start_with: "setuptools"
    generate_completions_from_executable(bin"sgr", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    sgr_status = shell_output("#{bin}sgr cloud login --username homebrewtest --password correcthorsebattery 2>&1", 2)
    assert_match "error: splitgraph.exceptions.AuthAPIError", sgr_status
    assert_match version.to_s, shell_output("#{bin}sgr --version")
  end
end