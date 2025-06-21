class Sysaidmin < Formula
  include Language::Python::Virtualenv

  desc "GPT-powered sysadmin"
  homepage "https:github.comskorokithakissysaidmin"
  url "https:files.pythonhosted.orgpackages01d8f2b32cc85a544d1487bbdda7ec48d214c0e551d2d0ae6bbbb49d707fe297sysaidmin-0.2.5.tar.gz"
  sha256 "77c40710cead7bdcc6cb98b38d74dd05e1e1c24dbc450e3b983869a7c06da91f"
  license "AGPL-3.0-or-later"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f349b0692c820b96eac95d4dd610902eecb3222cc8a219a818ee0ba47de8db21"
    sha256 cellar: :any,                 arm64_sonoma:  "b9040f0ac5c6a41bb0369aac161485e0a107996324978843316aa6928b74c834"
    sha256 cellar: :any,                 arm64_ventura: "9139145caa1f5ebd84091cce4fd49b87870cd8635a2d8e055f27291b68ea070a"
    sha256 cellar: :any,                 sonoma:        "5cff7a13d6f5232eb72af3e6448f1d7fe1dc3decfb12572c7a99a94efede357d"
    sha256 cellar: :any,                 ventura:       "d60ace9468334c1693af5486aaa94c70074ec1aa741694bae08305405306f3c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "148c47732b83bb73b4534bee100105af1450c67597dda165228adf8035afac1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc64112bb29b0fb3288fc405c4d114ddbf4ca64d9c700a38d170f697cbf61f65"
  end

  depends_on "rust" => :build # for pydantic_core
  depends_on "certifi"
  depends_on "python@3.13"

  resource "annotated-types" do
    url "https:files.pythonhosted.orgpackagesee67531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "anyio" do
    url "https:files.pythonhosted.orgpackages957d4c1bd541d4dffa1b52bd83fb8527089e097a106fc90b467a7313b105f840anyio-4.9.0.tar.gz"
    sha256 "673c0c244e15788651a4ff38710fea9675823028a6f08a5eda409e0c9840a028"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagese43389c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12dcharset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages606c8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbcclick-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "distro" do
    url "https:files.pythonhosted.orgpackagesfcf898eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "griffe" do
    url "https:files.pythonhosted.orgpackagesa93e5aa9a61f7c3c47b0b52a1d930302992229d191bf4bc76447b324b731510agriffe-1.7.3.tar.gz"
    sha256 "52ee893c6a3a968b639ace8015bec9d36594961e156e23315c8e8e51401fa50b"
  end

  resource "h11" do
    url "https:files.pythonhosted.orgpackages01ee02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httpcore" do
    url "https:files.pythonhosted.orgpackages069482699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cbhttpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpx" do
    url "https:files.pythonhosted.orgpackagesb1df48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "httpx-sse" do
    url "https:files.pythonhosted.orgpackages4c608f4281fa9bbf3c8034fd54c0e7412e66edbab6bc74c4996bd616f8d0406ehttpx-sse-0.4.0.tar.gz"
    sha256 "1e81a3a3070ce322add1d3529ed42eb5f70817f45ed6ec915ab753f961139721"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "jiter" do
    url "https:files.pythonhosted.orgpackagesee9dae7ddb4b8ab3fb1b51faf4deb36cb48a4fbbd7cb36bad6a5fca4741306f7jiter-0.10.0.tar.gz"
    sha256 "07a7142c38aacc85194391108dc91b5b57093c978a9932bd86a36862759d9500"
  end

  resource "mcp" do
    url "https:files.pythonhosted.orgpackages06f2dc2450e566eeccf92d89a00c3e813234ad58e2ba1e31d11467a09ac4f3b9mcp-1.9.4.tar.gz"
    sha256 "cfb0bcd1a9535b42edaef89947b9e18a8feb49362e1cc059d6e7fc636f2cb09f"
  end

  resource "openai" do
    url "https:files.pythonhosted.orgpackages5aeabbeef604d1fe0f7e9111745bb8a81362973a95713b28855beb9a9832ab12openai-1.88.0.tar.gz"
    sha256 "122d35e42998255cf1fc84560f6ee49a844e65c054cd05d3e42fda506b832bb1"
  end

  resource "openai-agents" do
    url "https:files.pythonhosted.orgpackages53a3301c6302bd2142c44674b4ccfb90d3da6771e17cef2e9fa2744256fd8dcaopenai_agents-0.0.19.tar.gz"
    sha256 "4090d683ef7257b3f6299f76e477ad51a970fd76de7c55df65f4bc5029580f2b"
  end

  resource "pydantic" do
    url "https:files.pythonhosted.orgpackages00dd4325abf92c39ba8623b5af936ddb36ffcfe0beae70405d456ab1fb2f5b8cpydantic-2.11.7.tar.gz"
    sha256 "d989c3c6cb79469287b1569f7447a17848c998458d49ebe294e975b9baf0f0db"
  end

  resource "pydantic-core" do
    url "https:files.pythonhosted.orgpackagesad885f2260bdfae97aabf98f1778d43f69574390ad787afb646292a638c923d4pydantic_core-2.33.2.tar.gz"
    sha256 "7cb8bc3605c29176e1b105350d2e6474142d7c1bd1d9327c4a9bdb46bf827acc"
  end

  resource "pydantic-settings" do
    url "https:files.pythonhosted.orgpackages671d42628a2c33e93f8e9acbde0d5d735fa0850f3e6a2f8cb1eb6c40b9a732acpydantic_settings-2.9.1.tar.gz"
    sha256 "c509bf79d27563add44e8446233359004ed85066cd096d8b510f715e6ef5d268"
  end

  resource "python-dotenv" do
    url "https:files.pythonhosted.orgpackages882c7bb1416c5620485aa793f2de31d3df393d3686aa8a8506d11e10e13c5bafpython_dotenv-1.1.0.tar.gz"
    sha256 "41f90bc6f5f177fb41f53e87666db362025010eb28f60a01c9143bfa33a2b2d5"
  end

  resource "python-multipart" do
    url "https:files.pythonhosted.orgpackagesf387f44d7c9f274c7ee665a29b885ec97089ec5dc034c7f3fafa03da9e39a09epython_multipart-0.0.20.tar.gz"
    sha256 "8dd0cab45b8e23064ae09147625994d090fa46f5b0d1e13af944c331a7fa9d13"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackagese10a929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "sniffio" do
    url "https:files.pythonhosted.orgpackagesa287a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbdsniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "sse-starlette" do
    url "https:files.pythonhosted.orgpackages8cf4989bc70cb8091eda43a9034ef969b25145291f3601703b82766e5172dfedsse_starlette-2.3.6.tar.gz"
    sha256 "0382336f7d4ec30160cf9ca0518962905e1b69b72d6c1c995131e0a703b436e3"
  end

  resource "starlette" do
    url "https:files.pythonhosted.orgpackages8bd00332bd8a25779a0e2082b0e179805ad39afad642938b371ae0882e7f880dstarlette-0.47.0.tar.gz"
    sha256 "1f64887e94a447fed5f23309fb6890ef23349b7e478faa7b24a851cd4eb844af"
  end

  resource "tqdm" do
    url "https:files.pythonhosted.orgpackagesa84b29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744dtqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  resource "types-requests" do
    url "https:files.pythonhosted.orgpackages6d7f73b3a04a53b0fd2a911d4ec517940ecd6600630b559e4505cc7b68beb5a0types_requests-2.32.4.20250611.tar.gz"
    sha256 "741c8777ed6425830bf51e54d6abe245f79b4dcb9019f1622b773463946bf826"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesd1bc51647cd02527e87d05cb083ccc402f93e441606ff1f01739a62c8ad09ba5typing_extensions-4.14.0.tar.gz"
    sha256 "8676b788e32f02ab42d9e7c61324048ae4c6d844a399eebace3d4979d75ceef4"
  end

  resource "typing-inspection" do
    url "https:files.pythonhosted.orgpackagesf8b10c11f5058406b3af7609f121aaa6b609744687f1d158b3c3a5bf4cc94238typing_inspection-0.4.1.tar.gz"
    sha256 "6ae134cc0203c33377d43188d4064e9b357dba58cff3185f22924610e70a9d28"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages15229ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bcurllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "uvicorn" do
    url "https:files.pythonhosted.orgpackagesdead713be230bcda622eaa35c28f0d328c3675c371238470abdea52417f17a8euvicorn-0.34.3.tar.gz"
    sha256 "35919a9a979d7a59334b6b10e05d77c1d0d574c50e0fc98b8b1a0f165708b55a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output(bin"sysaidmin --version")

    ENV["SYSAIDMIN_API_KEY"] = "faketest"
    # $ sysaidmin "The foo process is emailing me and I don't know why."
    output = shell_output("#{bin}sysaidmin 'The foo process is emailing me and I dont know why.' 2>&1", 1)
    assert_match "Incorrect API key provided", output
  end
end