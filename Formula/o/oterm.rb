class Oterm < Formula
  include Language::Python::Virtualenv

  desc "Terminal client for Ollama"
  homepage "https:github.comggozadoterm"
  url "https:files.pythonhosted.orgpackagesc5c55915b90d50574cebea30f8455e6444c8428344df8e3cb23f7723d837529doterm-0.14.1.tar.gz"
  sha256 "511b29ae2e61db6439ea8dd72e96caa2b61af16f68ce5fb86958b88f9de0d605"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c05dff21961f02bf047bc1e07c3f785fc39a897f9cf0819c2a8b2a624802b51f"
    sha256 cellar: :any,                 arm64_sonoma:  "6e40f3566716833245850d7a8c313218ece15fb39455f3cd986b5a966468aa9a"
    sha256 cellar: :any,                 arm64_ventura: "66af11c4b18b8316f81a34efcca4b145398932efec826302fd6188a2fb53832e"
    sha256 cellar: :any,                 sonoma:        "e1523b8e35e39f0e3de0a3f58cbfe1a8987333751a335e9bded640539036f8c8"
    sha256 cellar: :any,                 ventura:       "161b609cefe71bc6b2d60c1314fd709ff38f690c1603bb3db882d2a8d5e29f80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be2fb208a0ab50da6bd3ff65587dfb7054bcc3517a5f2304f3b85aa6cf23a155"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c14ba8d610eb36e2cc82ef9fb985dd454c7a922207eac574fcb3fd440e1bdc4e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "cffi"
  depends_on "cryptography"
  depends_on "freetype"
  depends_on "jpeg-turbo"
  depends_on "libraqm"
  depends_on "libtiff"
  depends_on "little-cms2"
  depends_on "openjpeg"
  depends_on "pycparser"
  depends_on "python@3.13"

  uses_from_macos "zlib"

  resource "aiosql" do
    url "https:files.pythonhosted.orgpackages983a105cdf480d444ee059f3fbea65616fba006fba29d32e382fb1a4d947f4b7aiosql-13.4.tar.gz"
    sha256 "da6ebb4d5e735753853007a7d574e60761338fc6ca8d95d6d95b5d85d7b1354d"
  end

  resource "aiosqlite" do
    url "https:files.pythonhosted.orgpackages137d8bca2bf9a247c2c5dfeec1d7a5f40db6518f88d314b8bca9da29670d2671aiosqlite-0.21.0.tar.gz"
    sha256 "131bb8056daa3bc875608c631c678cda73922a2d4ba8aec373b19f18c17e7aa3"
  end

  resource "annotated-types" do
    url "https:files.pythonhosted.orgpackagesee67531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "anyio" do
    url "https:files.pythonhosted.orgpackages957d4c1bd541d4dffa1b52bd83fb8527089e097a106fc90b467a7313b105f840anyio-4.9.0.tar.gz"
    sha256 "673c0c244e15788651a4ff38710fea9675823028a6f08a5eda409e0c9840a028"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackages5ab01367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "authlib" do
    url "https:files.pythonhosted.orgpackagesa29db1e08d36899c12c8b894a44a5583ee157789f26fc4b176f8e4b6217b56e1authlib-1.6.0.tar.gz"
    sha256 "4367d32031b7af175ad3a323d571dc7257b7099d55978087ceae4a0d88cd3210"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackagesb92e0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8bclick-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "exceptiongroup" do
    url "https:files.pythonhosted.orgpackages0b9fa65090624ecf468cdca03533906e7c69ed7588582240cfe7cc9e770b50ebexceptiongroup-1.3.0.tar.gz"
    sha256 "b241f5885f560bc56a59ee63ca4c6a8bfa46ae4ad651af316d4e81817bb9fd88"
  end

  resource "fastmcp" do
    url "https:files.pythonhosted.orgpackages0476d9b352dd632dbac9eea3255df7bba6d83b2def769b388ec332368d7b4638fastmcp-2.8.1.tar.gz"
    sha256 "c89d8ce8bf53a166eda444cfdcb2c638170e62445487229fbaf340aed31beeaf"
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
    url "https:files.pythonhosted.orgpackages6efa66bd985dd0b7c109a3bcb89272ee0bfb7e2b4d06309ad7b38ff866734b2ahttpx_sse-0.4.1.tar.gz"
    sha256 "8f44d34414bc7b21bf3602713005c5df4917884f76072479b21f68befa4ea26e"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "jsonschema" do
    url "https:files.pythonhosted.orgpackagesbfd31cf5326b923a53515d8f3a2cd442e6d7e94fcc444716e879ea70a0ce3177jsonschema-4.24.0.tar.gz"
    sha256 "0b4e8069eb12aedfa881333004bccaec24ecef5a8a6a4b6df142b2cc9599d196"
  end

  resource "jsonschema-specifications" do
    url "https:files.pythonhosted.orgpackagesbfce46fbd9c8119cfc3581ee5643ea49464d168028cfb5caff5fc0596d0cf914jsonschema_specifications-2025.4.1.tar.gz"
    sha256 "630159c9f4dbea161a6a2205c3011cc4f18ff381b189fff48bb39b9bf26ae608"
  end

  resource "linkify-it-py" do
    url "https:files.pythonhosted.orgpackages2aaebb56c6828e4797ba5a4821eec7c43b8bf40f69cda4d4f5f8c8a2810ec96alinkify-it-py-2.0.3.tar.gz"
    sha256 "68cda27e162e9215c17d786649d1da0021a451bdc436ef9e0fa0ba5234b9b048"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mcp" do
    url "https:files.pythonhosted.orgpackages7c6863045305f29ff680a9cd5be360c755270109e6b76f696ea6824547ddbc30mcp-1.10.1.tar.gz"
    sha256 "aaa0957d8307feeff180da2d9d359f2b801f35c0c67f1882136239055ef034c2"
  end

  resource "mdit-py-plugins" do
    url "https:files.pythonhosted.orgpackages1903a2ecab526543b152300717cf232bb4bb8605b6edb946c845016fa9c9c9fdmdit_py_plugins-0.4.2.tar.gz"
    sha256 "5f2cd1fdb606ddf152d37ec30e46101a60512bc0e5fa1a7002c36647b09e26b5"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "ollama" do
    url "https:files.pythonhosted.orgpackages8d96c7fe0d2d1b3053be614822a7b722c7465161b3672ce90df71515137580a0ollama-0.5.1.tar.gz"
    sha256 "5a799e4dc4e7af638b11e3ae588ab17623ee019e496caaf4323efbaa8feeff93"
  end

  resource "openapi-pydantic" do
    url "https:files.pythonhosted.orgpackages022e58d83848dd1a79cb92ed8e63f6ba901ca282c5f09d04af9423ec26c56fd7openapi_pydantic-0.5.1.tar.gz"
    sha256 "ff6835af6bde7a459fb93eb93bb92b8749b754fc6e51b2f1590a19dc3005ee0d"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesa1d41fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24dpackaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pillow" do
    url "https:files.pythonhosted.orgpackagesf30dd0d6dea55cd152ce3d6767bb38a8fc10e33796ba4ba210cbab9354b6d238pillow-11.3.0.tar.gz"
    sha256 "3828ee7586cd0b2091b6209e5ad53e20d0649bbe87164a459d0676e035e8f523"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackagesfe8b3c73abc9c759ecd3f1f7ceff6685840859e8070c4d947c93fae71f6a0bf2platformdirs-4.3.8.tar.gz"
    sha256 "3d512d96e16bcb959a814c9f348431070822a6496326a4be0911c40b5a74c2bc"
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
    url "https:files.pythonhosted.orgpackages68851ea668bbab3c50071ca613c6ab30047fb36ab0da1b92fa8f17bbc38fd36cpydantic_settings-2.10.1.tar.gz"
    sha256 "06f0062169818d0f5524420a360d632d5857b83cffd4d42fe29597807a1614ee"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackagesb077a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "python-dotenv" do
    url "https:files.pythonhosted.orgpackagesf6b04bc07ccd3572a2f9df7e6782f52b0c6c90dcbb803ac4a167702d7d0dfe1epython_dotenv-1.1.1.tar.gz"
    sha256 "a8a6399716257f45be6a007360200409fce5cda2661e3dec71d23dc15f6189ab"
  end

  resource "python-multipart" do
    url "https:files.pythonhosted.orgpackagesf387f44d7c9f274c7ee665a29b885ec97089ec5dc034c7f3fafa03da9e39a09epython_multipart-0.0.20.tar.gz"
    sha256 "8dd0cab45b8e23064ae09147625994d090fa46f5b0d1e13af944c331a7fa9d13"
  end

  resource "referencing" do
    url "https:files.pythonhosted.orgpackages2fdb98b5c277be99dd18bfd91dd04e1b759cad18d1a338188c936e92f921c7e2referencing-0.36.2.tar.gz"
    sha256 "df2e89862cd09deabbdba16944cc3f10feb6b3e6f18e902f7cc25609a34775aa"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesa153830aa4c3066a8ab0ae9a9955976fb770fe9c6102117c8ec4ab3ea62d89e8rich-14.0.0.tar.gz"
    sha256 "82f1bc23a6a21ebca4ae0c45af9bdbc492ed20231dcb63f297d6d1021a9d5725"
  end

  resource "rpds-py" do
    url "https:files.pythonhosted.orgpackages8ca660184b7fc00dd3ca80ac635dd5b8577d444c57e8e8742cecabfacb829921rpds_py-0.25.1.tar.gz"
    sha256 "8960b6dac09b62dac26e75d7e2c4a22efb835d827a7278c34f72b2b84fa160e3"
  end

  resource "shellingham" do
    url "https:files.pythonhosted.orgpackages58158b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58eshellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
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
    url "https:files.pythonhosted.orgpackages0a69662169fdb92fb96ec3eaee218cf540a629d629c86d7993d9651226a6789bstarlette-0.47.1.tar.gz"
    sha256 "aef012dd2b6be325ffa16698f9dc533614fb1cebd593a906b90dc1025529a79b"
  end

  resource "terminaltexteffects" do
    url "https:files.pythonhosted.orgpackages147871c0ff84d2a7372ce029b22998fac27505771254bcdbccfa8fd3c786e7b0terminaltexteffects-0.12.0.tar.gz"
    sha256 "84bfa7eefc4d03ede3b9a9794d26a224df34851534f993df6a237fdb744542ef"
  end

  resource "textual" do
    url "https:files.pythonhosted.orgpackages34998408761a1a1076b2bb69d4859ec110d74be7515552407ac1cb6b68630eb6textual-3.2.0.tar.gz"
    sha256 "d2f3b0c39e02535bb5f2aec1c45e10bd3ee7508ed1e240b7505c3cf02a6f00ed"
  end

  resource "textual-image" do
    url "https:files.pythonhosted.orgpackagesfc97aa86f7f1f18b69d0c5cdebd074dbddf8f1a6390b3072af90db2c978a0099textual_image-0.8.3.tar.gz"
    sha256 "1695797f9959bf87b297d4aa5ef9d9bb8b3400d6f305be3fa1ecd4c5bdf73ba5"
  end

  resource "textualeffects" do
    url "https:files.pythonhosted.orgpackages640e8307b9349f79d42666e46e936d31d0224e47c8e9dac572c2585e0fa517ebtextualeffects-0.1.4.tar.gz"
    sha256 "86709321d49cd7abf47ed513782130174e6f5d85ea16996a7c38709c3646c463"
  end

  resource "typer" do
    url "https:files.pythonhosted.orgpackages6c89c527e6c848739be8ceb5c44eb8208c52ea3515c6cf6406aa61932887bf58typer-0.15.4.tar.gz"
    sha256 "89507b104f9b6a0730354f27c39fae5b63ccd0c95b1ce1f1a6ba0cfd329997c3"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesd1bc51647cd02527e87d05cb083ccc402f93e441606ff1f01739a62c8ad09ba5typing_extensions-4.14.0.tar.gz"
    sha256 "8676b788e32f02ab42d9e7c61324048ae4c6d844a399eebace3d4979d75ceef4"
  end

  resource "typing-inspection" do
    url "https:files.pythonhosted.orgpackagesf8b10c11f5058406b3af7609f121aaa6b609744687f1d158b3c3a5bf4cc94238typing_inspection-0.4.1.tar.gz"
    sha256 "6ae134cc0203c33377d43188d4064e9b357dba58cff3185f22924610e70a9d28"
  end

  resource "uc-micro-py" do
    url "https:files.pythonhosted.orgpackages917a146a99696aee0609e3712f2b44c6274566bc368dfe8375191278045186b8uc-micro-py-1.0.3.tar.gz"
    sha256 "d321b92cff673ec58027c04015fcaa8bb1e005478643ff4a500882eaab88c48a"
  end

  resource "uvicorn" do
    url "https:files.pythonhosted.orgpackages5e42e0e305207bb88c6b8d3061399c6a961ffe5fbb7e2aa63c9234df7259e9cduvicorn-0.35.0.tar.gz"
    sha256 "bc662f087f7cf2ce11a1d7fd70b90c9f98ef2e2831556dd078d131b96cc94a01"
  end

  def install
    # `shellingham` auto-detection doesn't work in Homebrew CI build environment so
    # defer installation to allow `typer` to use argument as shell for completions
    # Ref: https:typer.tiangolo.comfeatures#user-friendly-cli-apps
    venv = virtualenv_install_with_resources without: "shellingham"
    generate_completions_from_executable(bin"oterm", "--show-completion")
    venv.pip_install resource("shellingham")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}oterm --version")
    assert_match "EnvConfig", shell_output("#{bin}oterm --config")
  end
end