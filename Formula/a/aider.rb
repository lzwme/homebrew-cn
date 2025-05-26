class Aider < Formula
  include Language::Python::Virtualenv

  desc "AI pair programming in your terminal"
  homepage "https:aider.chat"
  url "https:files.pythonhosted.orgpackages1b765621ce9d7e3a4fa2b7015a422023a238089a2628bc522762b2193cc6e8c0aider_chat-0.83.2.tar.gz"
  sha256 "b3b1d8d532313d22cec3f418773f2c7623e21c09fd6ae2bcaeba9726b73b0022"
  license "Apache-2.0"
  head "https:github.compaul-gauthieraider.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fdd59056418e25a87d7e90d5d69cee7bb563d7b43237c01214f71dd580bd77f3"
    sha256 cellar: :any,                 arm64_sonoma:  "2517fd3ce44b123fb4d4ce5e693e2e0e330cee26977a728b5db31a6e4e8af919"
    sha256 cellar: :any,                 arm64_ventura: "70b0bbb63ea8435811049d658687fae2054bc1e2baaa77c3937a66c69529bb79"
    sha256 cellar: :any,                 sonoma:        "7dd19b8a55054fad73f278a687c46c32c469a00eb15f4e9be5c356a678b870d4"
    sha256 cellar: :any,                 ventura:       "3d02adf57cc0e0f77bc05ac9576105a9bb016f61e719ba5a8f65dfb725ea5d48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "039b70ce858567d9fd262aee7bde938d43fd52d016c41e4eb9c87f2c6e7e861f"
  end

  depends_on "maturin" => :build # for `hf-xet`
  depends_on "pkgconf" => :build
  depends_on "rust" => :build # for pydantic_core

  depends_on "certifi"
  depends_on "cffi"
  depends_on "libyaml"
  depends_on "numpy"
  depends_on "pillow"
  depends_on "python@3.12" # py3.13 support issue, https:github.comAider-AIaiderissues3037
  depends_on "scipy"

  # One way to update python resources:
  # 1. remove GitHub url resources
  # 2. run `brew update-python-resources aider`
  # 3. use GitHub urls for any incomplete tree-sitter-* sdists (missing C headers)

  resource "aiohappyeyeballs" do
    url "https:files.pythonhosted.orgpackages2630f84a107a9c4331c14b2b586036f40965c128aa4fee4dda5d3d51cb14ad54aiohappyeyeballs-2.6.1.tar.gz"
    sha256 "c3f9d0113123803ccadfdf3f0faa505bc78e6a72d1cc4806cbd719826e943558"
  end

  resource "aiohttp" do
    url "https:files.pythonhosted.orgpackages63e7fa1a8c00e2c54b05dc8cb5d1439f627f7c267874e3f7bb047146116020f9aiohttp-3.11.18.tar.gz"
    sha256 "ae856e1138612b7e412db63b7708735cff4d38d0399f6a5435d3dac2669f558a"
  end

  resource "aiosignal" do
    url "https:files.pythonhosted.orgpackagesbab56d55e80f6d8a08ce22b982eafa278d823b541c925f11ee774b0b9c43473daiosignal-1.3.2.tar.gz"
    sha256 "a8c255c66fafb1e499c9351d0bf32ff2d8a0321595ebac3b93713656d2436f54"
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

  resource "backoff" do
    url "https:files.pythonhosted.orgpackages47d75bbeb12c44d7c4f2fb5b56abce497eb5ed9f34d85701de869acedd602619backoff-2.2.1.tar.gz"
    sha256 "03f829f5bb1923180821643f8753b0502c3b682293992485b0eef2807afa5cba"
  end

  resource "beautifulsoup4" do
    url "https:files.pythonhosted.orgpackagesd8e40c4c39e18fd76d6a628d4dd8da40543d136ce2d1752bd6eeeab0791f4d6bbeautifulsoup4-4.13.4.tar.gz"
    sha256 "dbb3c4e1ceae6aefebdaf2423247260cd062430a410e38c66f2baa50a8437195"
  end

  resource "cachetools" do
    url "https:files.pythonhosted.orgpackages6c813747dad6b14fa2cf53fcf10548cf5aea6913e96fab41a3c198676f8948a5cachetools-5.5.2.tar.gz"
    sha256 "1a661caa9175d26759571b2e19580f9d6393969e5dfca11fdb1f947a23e640d4"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagese43389c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12dcharset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackagesb92e0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8bclick-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "configargparse" do
    url "https:files.pythonhosted.orgpackages854d6c9ef746dfcc2a32e26f3860bb4a011c008c392b83eabdfb598d1a8bbe5dconfigargparse-1.7.1.tar.gz"
    sha256 "79c2ddae836a1e5914b71d58e4b9adbd9f7779d4e6351a637b7d2d9b6c46d3d9"
  end

  resource "diff-match-patch" do
    url "https:files.pythonhosted.orgpackages0ead32e1777dd57d8e85fa31e3a243af66c538245b8d64b7265bec9a61f2ca33diff_match_patch-20241021.tar.gz"
    sha256 "beae57a99fa48084532935ee2968b8661db861862ec82c6f21f4acdd6d835073"
  end

  resource "diskcache" do
    url "https:files.pythonhosted.orgpackages3f211c1ffc1a039ddcc459db43cc108658f32c57d271d7289a2794e401d0fdb6diskcache-5.6.3.tar.gz"
    sha256 "2c3a3fa2743d8535d832ec61c2054a1641f41775aa7c556758a109941e33e4fc"
  end

  resource "distro" do
    url "https:files.pythonhosted.orgpackagesfcf898eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "filelock" do
    url "https:files.pythonhosted.orgpackages0a10c23352565a6544bdc5353e0b15fc1c563352101f30e24bf500207a54df9afilelock-3.18.0.tar.gz"
    sha256 "adbc88eabb99d2fec8c9c1b229b171f18afa655400173ddc653d5d01501fb9f2"
  end

  resource "flake8" do
    url "https:files.pythonhosted.orgpackagese7c45842fc9fc94584c455543540af62fd9900faade32511fab650e9891ec225flake8-7.2.0.tar.gz"
    sha256 "fa558ae3f6f7dbf2b4f22663e5343b6b6023620461f8d4ff2019ef4b5ee70426"
  end

  resource "frozenlist" do
    url "https:files.pythonhosted.orgpackageseef4d744cba2da59b5c1d88823cf9e8a6c74e4659e2b27604ed973be2a0bf5abfrozenlist-1.6.0.tar.gz"
    sha256 "b99655c32c1c8e06d111e7f41c06c29a5318cb1835df23a45518e02a47c63b68"
  end

  resource "fsspec" do
    url "https:files.pythonhosted.orgpackages45d88425e6ba5fcec61a1d16e41b1b71d2bf9344f1fe48012c2b48b9620feae5fsspec-2025.3.2.tar.gz"
    sha256 "e52c77ef398680bbd6a98c0e628fbc469491282981209907bbc8aea76a04fdc6"
  end

  resource "gitdb" do
    url "https:files.pythonhosted.orgpackages729463b0fc47eb32792c7ba1fe1b694daec9a63620db1e313033d18140c2320agitdb-4.0.12.tar.gz"
    sha256 "5ef71f855d191a3326fcfbc0d5da835f26b13fbcba60c32c21091c349ffdb571"
  end

  resource "gitpython" do
    url "https:files.pythonhosted.orgpackagesc08937df0b71473153574a5cdef8f242de422a0f5d26d7a9e231e6f169b4ad14gitpython-3.1.44.tar.gz"
    sha256 "c87e30b26253bf5418b01b0660f818967f3c503193838337fe5e573331249269"
  end

  resource "google-ai-generativelanguage" do
    url "https:files.pythonhosted.orgpackages11d148fe5d7a43d278e9f6b5ada810b0a3530bbeac7ed7fcbcd366f932f05316google_ai_generativelanguage-0.6.15.tar.gz"
    sha256 "8f6d9dc4c12b065fe2d0289026171acea5183ebf2d0b11cefe12f3821e159ec3"
  end

  resource "google-api-core" do
    url "https:files.pythonhosted.orgpackages095c085bcb872556934bb119e5e09de54daa07873f6866b8f0303c49e72287f7google_api_core-2.24.2.tar.gz"
    sha256 "81718493daf06d96d6bc76a91c23874dbf2fac0adbbf542831b805ee6e974696"
  end

  resource "google-api-python-client" do
    url "https:files.pythonhosted.orgpackages4fe6787c24738fc7c99de9289abe60bd64591800ae1cdf60db7b87e0e6ef9cddgoogle_api_python_client-2.169.0.tar.gz"
    sha256 "0585bb97bd5f5bf3ed8d4bf624593e4c5a14d06c811d1952b07a1f94b4d12c51"
  end

  resource "google-auth" do
    url "https:files.pythonhosted.orgpackages94a538c21d0e731bb716cffcf987bd9a3555cb95877ab4b616cfb96939933f20google_auth-2.40.1.tar.gz"
    sha256 "58f0e8416a9814c1d86c9b7f6acf6816b51aba167b2c76821965271bac275540"
  end

  resource "google-auth-httplib2" do
    url "https:files.pythonhosted.orgpackages56be217a598a818567b28e859ff087f347475c807a5649296fb5a817c58dacefgoogle-auth-httplib2-0.2.0.tar.gz"
    sha256 "38aa7badf48f974f1eb9861794e9c0cb2a0511a4ec0679b1f886d108f5640e05"
  end

  resource "google-generativeai" do
    url "https:files.pythonhosted.orgpackages6e40c42ff9ded9f09ec9392879a8e6538a00b2dc185e834a3392917626255419google_generativeai-0.8.5-py3-none-any.whl"
    sha256 "22b420817fb263f8ed520b33285f45976d5b21e904da32b80d4fd20c055123a2"
  end

  resource "googleapis-common-protos" do
    url "https:files.pythonhosted.orgpackages392433db22342cf4a2ea27c9955e6713140fedd51e8b141b5ce5260897020f1agoogleapis_common_protos-1.70.0.tar.gz"
    sha256 "0e1b44e0ea153e6594f9f394fef15193a68aaaea2d843f83e2742717ca753257"
  end

  resource "grep-ast" do
    url "https:files.pythonhosted.orgpackages6782a87079945a7c15d242cb586ae22e17952132439eaa9c878ec5fbdc61c54dgrep_ast-0.9.0.tar.gz"
    sha256 "620a242a4493e6721338d1c9a6c234ae651f8774f4924a6dcf90f6865d4b2ee3"
  end

  resource "grpcio" do
    url "https:files.pythonhosted.orgpackagesd133bf7bf9188cfce1c626e4c5d55523fec7f2f1d905e003df5da025f532916egrpcio-1.72.0rc1.tar.gz"
    sha256 "221793dccd3332060f426975a041d319d6d57323d857d4afc25257ec4a5a67f3"
  end

  resource "grpcio-status" do
    url "https:files.pythonhosted.orgpackages5bb2f5caba63bb0c1637f468d820c46756b8bae28187928ffbe097157f478429grpcio_status-1.72.0rc1.tar.gz"
    sha256 "20b9cabe989824eeb5d8322189fdc084dfc69bb9fff7cb165cd28340cdbc73e1"
  end

  resource "h11" do
    url "https:files.pythonhosted.orgpackages01ee02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "hf-xet" do
    url "https:files.pythonhosted.orgpackages95be58f20728a5b445f8b064e74f0618897b3439f5ef90934da1916b9dfac76fhf_xet-1.1.2.tar.gz"
    sha256 "3712d6d4819d3976a1c18e36db9f503e296283f9363af818f50703506ed63da3"
  end

  resource "httpcore" do
    url "https:files.pythonhosted.orgpackages069482699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cbhttpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httplib2" do
    url "https:files.pythonhosted.orgpackages3dad2371116b22d616c194aa25ec410c9c6c37f23599dcd590502b74db197584httplib2-0.22.0.tar.gz"
    sha256 "d7a10bc5ef5ab08322488bde8c726eeee5c8618723fdb399597ec58f3d82df81"
  end

  resource "httpx" do
    url "https:files.pythonhosted.orgpackagesb1df48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "huggingface-hub" do
    url "https:files.pythonhosted.orgpackages25eb9268c1205d19388659d5dc664f012177b752c0eef194a9159acc7227780fhuggingface_hub-0.31.1.tar.gz"
    sha256 "492bb5f545337aa9e2f59b75ef4c5f535a371e8958a6ce90af056387e67f1180"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "importlib-metadata" do
    url "https:files.pythonhosted.orgpackages767233d1bb4be61f1327d3cd76fc41e2d001a6b748a0648d944c646643f123feimportlib_metadata-7.2.1.tar.gz"
    sha256 "509ecb2ab77071db5137c655e24ceb3eee66e7bbc6574165d0d114d9fc4bbe68"
  end

  resource "importlib-resources" do
    url "https:files.pythonhosted.orgpackagescf8cf834fbf984f691b4f7ff60f50b514cc3de5cc08abfc3295564dd89c5e2e7importlib_resources-6.5.2.tar.gz"
    sha256 "185f87adef5bcc288449d98fb4fba07cea78bc036455dd44c5fc4a2fe78fed2c"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesdfbff7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226bjinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "jiter" do
    url "https:files.pythonhosted.orgpackages1ec2e4562507f52f0af7036da125bb699602ead37a2332af0788f8e0a3417f36jiter-0.9.0.tar.gz"
    sha256 "aadba0964deb424daa24492abc3d229c60c4a31bfee205aedbf1acc7639d7893"
  end

  resource "json5" do
    url "https:files.pythonhosted.orgpackages12bec6c745ec4c4539b25a278b70e29793f10382947df0d9efba2fa09120895djson5-0.12.0.tar.gz"
    sha256 "0b4b6ff56801a1c7dc817b0241bca4ce474a0e6a163bfef3fc594d3fd263ff3a"
  end

  resource "jsonschema" do
    url "https:files.pythonhosted.orgpackages382e03362ee4034a4c917f697890ccd4aec0800ccf9ded7f511971c75451deecjsonschema-4.23.0.tar.gz"
    sha256 "d71497fef26351a33265337fa77ffeb82423f3ea21283cd9467bb03999266bc4"
  end

  resource "jsonschema-specifications" do
    url "https:files.pythonhosted.orgpackagesbfce46fbd9c8119cfc3581ee5643ea49464d168028cfb5caff5fc0596d0cf914jsonschema_specifications-2025.4.1.tar.gz"
    sha256 "630159c9f4dbea161a6a2205c3011cc4f18ff381b189fff48bb39b9bf26ae608"
  end

  resource "litellm" do
    url "https:files.pythonhosted.orgpackagesd1c12963a8a9795e3318eaff2a84c6886a780bd237cc276a2c8a126b3328e470litellm-1.68.1.tar.gz"
    sha256 "301fe0457ac059806009352b6578821351125cfdf35e3a0ab8c43a8336852667"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackagesb2975d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "mccabe" do
    url "https:files.pythonhosted.orgpackagese7ff0ffefdcac38932a54d2b5eed4e0ba8a408f215002cd178ad1df0f2806ff8mccabe-0.7.0.tar.gz"
    sha256 "348e0240c33b60bbdf4e523192ef919f28cb2c3d7d5c7794f74009290f236325"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "mixpanel" do
    url "https:files.pythonhosted.orgpackagesbda39d71562db2107da31be6a988cac88cd1be11364d103b618a98ba92d2487bmixpanel-4.10.1.tar.gz"
    sha256 "29a6b5773dd34f05cf8e249f4e1d16e7b6280d6b58894551ce9a5aad7700a115"
  end

  resource "mslex" do
    url "https:files.pythonhosted.orgpackagese0977022667073c99a0fe028f2e34b9bf76b49a611afd21b02527fbfd92d4cd5mslex-1.3.0.tar.gz"
    sha256 "641c887d1d3db610eee2af37a8e5abda3f70b3006cdfd2d0d29dc0d1ae28a85d"
  end

  resource "multidict" do
    url "https:files.pythonhosted.orgpackagesda2ce367dfb4c6538614a0c9453e510d75d66099edf1c4e69da1b5ce691a1931multidict-6.4.3.tar.gz"
    sha256 "3ada0b058c9f213c5f95ba301f922d402ac234f1111a7d8fd70f1b99f3c281ec"
  end

  resource "networkx" do
    url "https:files.pythonhosted.orgpackagesfd1d06475e1cd5264c0b870ea2cc6fdb3e37177c1e565c43f56ff17a10e3937fnetworkx-3.4.2.tar.gz"
    sha256 "307c3669428c5362aab27c8a1260aa8f47c4e91d3891f48be0141738d8d053e1"
  end

  resource "openai" do
    url "https:files.pythonhosted.orgpackages99b1318f5d4c482f19c5fcbcde190801bfaaaec23413cda0b88a29f6897448ffopenai-1.75.0.tar.gz"
    sha256 "fb3ea907efbdb1bcfd0c44507ad9c961afd7dce3147292b54505ecfd17be8fd1"
  end

  resource "oslex" do
    url "https:files.pythonhosted.orgpackages5ea9ebd426ee0ca59fb5ba8f0039c53989f4ca475f2dd9583b5719e2fb01602coslex-0.1.3.tar.gz"
    sha256 "1ed4cd82c75df2a8bcb0da34400984183753933155d0c7d999fa533137685f2d"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesd06368dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106dapackaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "pathspec" do
    url "https:files.pythonhosted.orgpackagescabcf35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbfpathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "pexpect" do
    url "https:files.pythonhosted.orgpackages4292cc564bf6381ff43ce1f4d06852fc19a2f11d180f23dc32d9588bee2f149dpexpect-4.9.0.tar.gz"
    sha256 "ee7d41123f3c9911050ea2c2dac107568dc43b2d3b0c7557a33212c398ead30f"
  end

  resource "posthog" do
    url "https:files.pythonhosted.orgpackagescf6f835a48728adb60b51dbe6bcc528480e38f1f80769a48704f687d83aefe7eposthog-4.0.1.tar.gz"
    sha256 "77e7ebfc6086972db421d3e05c91d5431b2b964865d33a9a32e55dd88da4bff8"
  end

  resource "prompt-toolkit" do
    url "https:files.pythonhosted.orgpackagesbb6e9d084c929dfe9e3bfe0c6a47e31f78a25c54627d64a66e884a8bf5474f1cprompt_toolkit-3.0.51.tar.gz"
    sha256 "931a162e3b27fc90c86f1b48bb1fb2c528c2761475e57c9c06de13311c7b54ed"
  end

  resource "propcache" do
    url "https:files.pythonhosted.orgpackages07c8fdc6686a986feae3541ea23dcaa661bd93972d3940460646c6bb96e21c40propcache-0.3.1.tar.gz"
    sha256 "40d980c33765359098837527e18eddefc9a24cea5b45e078a7f3bb5b032c6ecf"
  end

  resource "proto-plus" do
    url "https:files.pythonhosted.orgpackagesf4ac87285f15f7cce6d4a008f33f1757fb5a13611ea8914eb58c3d0d26243468proto_plus-1.26.1.tar.gz"
    sha256 "21a515a4c4c0088a773899e23c7bbade3d18f9c66c73edd4c7ee3816bc96a012"
  end

  resource "protobuf" do
    url "https:files.pythonhosted.orgpackages177db9dca7365f0e2c4fa7c193ff795427cfa6290147e5185ab11ece280a18e7protobuf-5.29.4.tar.gz"
    sha256 "4f1dfcd7997b31ef8f53ec82781ff434a28bf71d9102ddde14d076adcfc78c99"
  end

  resource "psutil" do
    url "https:files.pythonhosted.orgpackages2a80336820c1ad9286a4ded7e845b2eccfcb27851ab8ac6abece774a6ff4d3depsutil-7.0.0.tar.gz"
    sha256 "7be9c3eba38beccb6495ea33afd982a44074b78f28c434a1f51cc07fd315c456"
  end

  resource "ptyprocess" do
    url "https:files.pythonhosted.orgpackages20e516ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4eptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "pyasn1" do
    url "https:files.pythonhosted.orgpackagesbae901f1a64245b89f039897cb0130016d79f77d52669aae6ee7b159a6c4c018pyasn1-0.6.1.tar.gz"
    sha256 "6f580d2bdd84365380830acf45550f2511469f673cb4a5ae3857a3170128b034"
  end

  resource "pyasn1-modules" do
    url "https:files.pythonhosted.orgpackagese9e678ebbb10a8c8e4b61a59249394a4a594c1a7af95593dc933a349c8d00964pyasn1_modules-0.4.2.tar.gz"
    sha256 "677091de870a80aae844b1ca6134f54652fa2c8c5a52aa396440ac3106e941e6"
  end

  resource "pycodestyle" do
    url "https:files.pythonhosted.orgpackages046e1f4a62078e4d95d82367f24e685aef3a672abfd27d1a868068fed4ed2254pycodestyle-2.13.0.tar.gz"
    sha256 "c8415bf09abe81d9c7f872502a6eee881fbe85d8763dd5b9924bb0a01d67efae"
  end

  resource "pydantic" do
    url "https:files.pythonhosted.orgpackages77ab5250d56ad03884ab5efd07f734203943c8a8ab40d551e208af81d0257bf2pydantic-2.11.4.tar.gz"
    sha256 "32738d19d63a226a52eed76645a98ee07c1f410ee41d93b4afbfa85ed8111c2d"
  end

  resource "pydantic-core" do
    url "https:files.pythonhosted.orgpackagesad885f2260bdfae97aabf98f1778d43f69574390ad787afb646292a638c923d4pydantic_core-2.33.2.tar.gz"
    sha256 "7cb8bc3605c29176e1b105350d2e6474142d7c1bd1d9327c4a9bdb46bf827acc"
  end

  resource "pydub" do
    url "https:files.pythonhosted.orgpackagesfe9ae6bca0eed82db26562c73b5076539a4a08d3cffd19c3cc5913a3e61145fdpydub-0.25.1.tar.gz"
    sha256 "980a33ce9949cab2a569606b65674d748ecbca4f0796887fd6f46173a7b0d30f"
  end

  resource "pyflakes" do
    url "https:files.pythonhosted.orgpackagesafcc1df338bd7ed1fa7c317081dcf29bf2f01266603b301e6858856d346a12b3pyflakes-3.3.2.tar.gz"
    sha256 "6dfd61d87b97fba5dcfaaf781171ac16be16453be6d816147989e7f6e6a9576b"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages7c2dc3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "pypandoc" do
    url "https:files.pythonhosted.orgpackagese18826e650d053df5f3874aa3c05901a14166ce3271f58bfe114fd776987efbdpypandoc-1.15.tar.gz"
    sha256 "ea25beebe712ae41d63f7410c08741a3cab0e420f6703f95bc9b3a749192ce13"
  end

  resource "pyparsing" do
    url "https:files.pythonhosted.orgpackagesbb22f1129e69d94ffff626bdb5c835506b3a5b4f3d070f17ea295e12c2c6f60fpyparsing-3.2.3.tar.gz"
    sha256 "b9c13f1ab8b3b542f72e28f634bad4de758ab3ce4546e4301970ad6fa77c38be"
  end

  resource "pyperclip" do
    url "https:files.pythonhosted.orgpackages30232f0a3efc4d6a32f3b63cdff36cd398d9701d26cda58e3ab97ac79fb5e60dpyperclip-1.9.0.tar.gz"
    sha256 "b7de0142ddc81bfc5c7507eea19da920b92252b548b96186caf94a5e2527d310"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-dotenv" do
    url "https:files.pythonhosted.orgpackages882c7bb1416c5620485aa793f2de31d3df393d3686aa8a8506d11e10e13c5bafpython_dotenv-1.1.0.tar.gz"
    sha256 "41f90bc6f5f177fb41f53e87666db362025010eb28f60a01c9143bfa33a2b2d5"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "referencing" do
    url "https:files.pythonhosted.orgpackages2fdb98b5c277be99dd18bfd91dd04e1b759cad18d1a338188c936e92f921c7e2referencing-0.36.2.tar.gz"
    sha256 "df2e89862cd09deabbdba16944cc3f10feb6b3e6f18e902f7cc25609a34775aa"
  end

  resource "regex" do
    url "https:files.pythonhosted.orgpackages8e5fbd69653fbfb76cf8604468d3b4ec4c403197144c7bfe0e6a5fc9e02a07cbregex-2024.11.6.tar.gz"
    sha256 "7ab159b063c52a0333c884e4679f8d7a85112ee3078fe3d9004b2dd875585519"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesa153830aa4c3066a8ab0ae9a9955976fb770fe9c6102117c8ec4ab3ea62d89e8rich-14.0.0.tar.gz"
    sha256 "82f1bc23a6a21ebca4ae0c45af9bdbc492ed20231dcb63f297d6d1021a9d5725"
  end

  resource "rpds-py" do
    url "https:files.pythonhosted.orgpackages0bb352b213298a0ba7097c7ea96bee95e1947aa84cc816d48cebb539770cdf41rpds_py-0.24.0.tar.gz"
    sha256 "772cc1b2cd963e7e17e6cc55fe0371fb9c704d63e44cacec7b9b7f523b78919e"
  end

  resource "rsa" do
    url "https:files.pythonhosted.orgpackagesda8a22b7beea3ee0d44b1916c0c1cb0ee3af23b700b6da9f04991899d0c555d4rsa-4.9.1.tar.gz"
    sha256 "e7bdbfdb5497da4c07dfd35530e1a902659db6ff241e39d9953cad06ebd0ae75"
  end

  resource "shtab" do
    url "https:files.pythonhosted.orgpackages5a3e837067b970c1d2ffa936c72f384a63fdec4e186b74da781e921354a94024shtab-1.7.2.tar.gz"
    sha256 "8c16673ade76a2d42417f03e57acf239bfb5968e842204c17990cae357d07d6f"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages94e7b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "smmap" do
    url "https:files.pythonhosted.orgpackages44cda040c4b3119bbe532e5b0732286f805445375489fceaec1f48306068ee3bsmmap-5.0.2.tar.gz"
    sha256 "26ea65a03958fa0c8a1c7e8c7a58fdc77221b8910f6be2131affade476898ad5"
  end

  resource "sniffio" do
    url "https:files.pythonhosted.orgpackagesa287a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbdsniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "socksio" do
    url "https:files.pythonhosted.orgpackagesf85c48a7d9495be3d1c651198fd99dbb6ce190e2274d0f28b9051307bdec6b85socksio-1.0.0.tar.gz"
    sha256 "f88beb3da5b5c38b9890469de67d0cb0f9d494b78b106ca1845f96c10b91c4ac"
  end

  resource "sounddevice" do
    url "https:files.pythonhosted.orgpackages802db04ae180312b81dbb694504bee170eada5372242e186f6298139fd3a0513sounddevice-0.5.1.tar.gz"
    sha256 "09ca991daeda8ce4be9ac91e15a9a81c8f81efa6b695a348c9171ea0c16cb041"
  end

  resource "soundfile" do
    url "https:files.pythonhosted.orgpackagese1419b873a8c055582859b239be17902a85339bec6a30ad162f98c9b0288a2ccsoundfile-0.13.1.tar.gz"
    sha256 "b2c68dab1e30297317080a5b43df57e302584c49e2942defdde0acccc53f0e5b"
  end

  resource "soupsieve" do
    url "https:files.pythonhosted.orgpackages3ff44a80cd6ef364b2e8b65b15816a843c0980f7a5a2b4dc701fc574952aa19fsoupsieve-2.7.tar.gz"
    sha256 "ad282f9b6926286d2ead4750552c8a6142bc4c783fd66b0293547c8fe6ae126a"
  end

  resource "tiktoken" do
    url "https:files.pythonhosted.orgpackageseacf756fedf6981e82897f2d570dd25fa597eb3f4459068ae0572d7e888cfd6ftiktoken-0.9.0.tar.gz"
    sha256 "d02a5ca6a938e0490e1ff957bc48c8b078c88cb83977be1625b1fd8aac792c5d"
  end

  resource "tokenizers" do
    url "https:files.pythonhosted.orgpackages92765ac0c97f1117b91b7eb7323dcd61af80d72f790b4df71249a7850c195f30tokenizers-0.21.1.tar.gz"
    sha256 "a1bb04dc5b448985f86ecd4b05407f5a8d97cb2c0532199b2a302a604a0165ab"
  end

  resource "tqdm" do
    url "https:files.pythonhosted.orgpackagesa84b29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744dtqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  resource "tree-sitter" do
    url "https:files.pythonhosted.orgpackagesa7a2698b9d31d08ad5558f8bfbfe3a0781bd4b1f284e89bde3ad18e05101a892tree-sitter-0.24.0.tar.gz"
    sha256 "abd95af65ca2f4f7eca356343391ed669e764f37748b5352946f00f7fc78e734"
  end

  resource "tree-sitter-c-sharp" do
    url "https:github.comtree-sittertree-sitter-c-sharpreleasesdownloadv0.23.1tree-sitter-c-sharp.tar.xz"
    sha256 "091b700c852ec39c9253ad22ea50198567ede167afddedbcc6a8080a7148090b"
  end

  resource "tree-sitter-embedded-template" do
    url "https:github.comtree-sittertree-sitter-embedded-templatearchiverefstagsv0.23.2.tar.gz"
    sha256 "eeda286631c6086b6fbe6d2a2c5cc8c1ea6129aaaf5bef4ca4b9a3f44d829569"
  end

  resource "tree-sitter-language-pack" do
    url "https:files.pythonhosted.orgpackagescdcebc64ed55b2b8ffd4f599108be44f3fb9da8c00767502701a067be7b62c89tree_sitter_language_pack-0.7.3.tar.gz"
    sha256 "49139cb607d81352d33ad18e57520fc1057a009955c9ccced56607cc18e6a3fd"
  end

  resource "tree-sitter-yaml" do
    url "https:github.comtree-sitter-grammarstree-sitter-yamlarchiverefstagsv0.7.0.tar.gz"
    sha256 "8182760587f14d5131161dee3605613ccebe86062909f0879edf63b4bdd99d44"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesf63723083fcd6e35492953e8d2aaaa68b860eb422b34627b13f2ce3eb6106061typing_extensions-4.13.2.tar.gz"
    sha256 "e6c81219bd689f51865d9e372991c540bda33a0379d5573cddb9a3a23f7caaef"
  end

  resource "typing-inspection" do
    url "https:files.pythonhosted.orgpackages825ce6082df02e215b846b4b8c0b887a64d7d08ffaba30605502639d44c06b82typing_inspection-0.4.0.tar.gz"
    sha256 "9765c87de36671694a67904bf2c96e395be9c6439bb6c87b5142569dcdd65122"
  end

  resource "uritemplate" do
    url "https:files.pythonhosted.orgpackagesd25a4742fdba39cd02a56226815abfa72fe0aa81c33bed16ed045647d6000ebauritemplate-4.1.1.tar.gz"
    sha256 "4346edfc5c3b79f694bccd6d6099a322bbeb628dbf2cd86eea55a456ce5124f0"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages8a7816493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  resource "watchfiles" do
    url "https:files.pythonhosted.orgpackages03e28ed598c42057de7aa5d97c472254af4906ff0a59a66699d426fc9ef795d7watchfiles-1.0.5.tar.gz"
    sha256 "b7529b5dcc114679d43827d8c35a07c493ad6f083633d573d81c660abc5979e9"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages6c6353559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  resource "yarl" do
    url "https:files.pythonhosted.orgpackages6251c0edba5219027f6eab262e139f73e2417b0f4efffa23bf562f6e18f76ca5yarl-1.20.0.tar.gz"
    sha256 "686d51e51ee5dfe62dec86e4866ee0e9ed66df700d55c828a615640adc885307"
  end

  resource "zipp" do
    url "https:files.pythonhosted.orgpackages3f50bad581df71744867e9468ebd0bcd6505de3b275e06f202c2cb016e3ff56fzipp-3.21.0.tar.gz"
    sha256 "2c9958f6430a2040341a52eb608ed6dd93ef4392e02ffe219417c1b28b5dd1f4"
  end

  def python3
    "python3.12"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["AIDER_DRY_RUN"] = "true"
    ENV["AIDER_GUI"] = "false"
    ENV["AIDER_CHECK_UPDATE"] = "false"
    ENV["AIDER_YES_ALWAYS"] = "true"

    mkdir "tmptestdir" do
      assert_match version.to_s, shell_output("#{bin}aider --version")
      ENV["OPENAI_API_KEY"] = "invalid"
      output = shell_output("#{bin}aider --exit --message=test 2>&1")
      assert_match "API key provided: invalid", output
    end
  end
end