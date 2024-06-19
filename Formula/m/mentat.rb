class Mentat < Formula
  include Language::Python::Virtualenv

  desc "Coding assistant that leverages GPT-4 to write code"
  homepage "https:www.mentat.ai"
  url "https:files.pythonhosted.orgpackagese08ba808d6663065e3b446d3be521d7836f774f3b39bdd30f786d093aca383b6mentat-1.0.8.tar.gz"
  sha256 "81679055448a495c3e7e55eeb8b59373dc0658cea6b2549d0ae48d26937494ba"
  license "Apache-2.0"
  revision 3
  head "https:github.comAbanteAImentat.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "06f91e3553a418ff3d4002467c5490996c5daf08e0cbc04d408b2f88d4a83d7f"
    sha256 cellar: :any,                 arm64_ventura:  "f472fee094ce43c23c838432a94136279cfe9dfebe1503f667a2c1d6fc58ead7"
    sha256 cellar: :any,                 arm64_monterey: "f60ae0a65efb301be68987c370c13363e0e6453b68049dbc91c0737192c3cf1d"
    sha256 cellar: :any,                 sonoma:         "0baa094536dc29fd2d1f93270b8e89257ec3a1a15a10f8a6b212d528f96bdb8e"
    sha256 cellar: :any,                 ventura:        "514d9bab0b7167e18210590cfd1f73feb0d375849303ef0c6a1f96af8d5e16b4"
    sha256 cellar: :any,                 monterey:       "98971a04d93bbf20ee2e1bf3774e453b1cb35b715b0de483b10a00ee5818f6f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb9feeabced4de5e8a7d0237c1df317eeb816df380f831ebf68a38bde72a3c3a"
  end

  depends_on "rust" => :build # for tiktoken
  depends_on "certifi"
  depends_on "numpy"
  depends_on "pillow"
  depends_on "python@3.12"

  uses_from_macos "libffi"

  resource "annotated-types" do
    url "https:files.pythonhosted.orgpackagesee67531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "anyio" do
    url "https:files.pythonhosted.orgpackages28992dfd53fd55ce9838e6ff2d4dac20ce58263798bd1a0dbe18b3a9af3fcfceanyio-3.7.1.tar.gz"
    sha256 "44a3c9aba0f5defa43261a8b3efb97891f2bd7d804e0e1f56419befa1adfc780"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackages979081f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbbattrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "backoff" do
    url "https:files.pythonhosted.orgpackages47d75bbeb12c44d7c4f2fb5b56abce497eb5ed9f34d85701de869acedd602619backoff-2.2.1.tar.gz"
    sha256 "03f829f5bb1923180821643f8753b0502c3b682293992485b0eef2807afa5cba"
  end

  resource "cffi" do
    url "https:files.pythonhosted.orgpackages68ce95b0bae7968c65473e1298efb042e10cafc7bafc14d9e4f154008241c91dcffi-1.16.0.tar.gz"
    sha256 "bcb3ef43e58665bbda2fb198698fcae6776483e0c4a631aa5647806c25e02cc0"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "distro" do
    url "https:files.pythonhosted.orgpackagesfcf898eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "fire" do
    url "https:files.pythonhosted.orgpackages94ed3b9a10605163f48517931083aee8364d4d6d3bb1aa9b75eb0a4a5e9fbfc1fire-0.5.0.tar.gz"
    sha256 "a6b0d49e98c8963910021f92bba66f65ab440da2982b78eb1bbf95a0a34aacc6"
  end

  resource "gitdb" do
    url "https:files.pythonhosted.orgpackages190dbbb5b5ee188dec84647a4664f3e11b06ade2bde568dbd489d9d64adef8edgitdb-4.0.11.tar.gz"
    sha256 "bf5421126136d6d0af55bc1e7c1af1c397a34f5b7bd79e776cd3e89785c2b04b"
  end

  resource "gitpython" do
    url "https:files.pythonhosted.orgpackagesc6335e633d3a8b3dbec3696415960ed30f6718ed04ef423ce0fbc6512a92fa9aGitPython-3.1.37.tar.gz"
    sha256 "f9b9ddc0761c125d5780eab2d64be4873fc6817c2899cbcb34b02344bdc7bc54"
  end

  resource "h11" do
    url "https:files.pythonhosted.orgpackagesf5383af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "httpcore" do
    url "https:files.pythonhosted.orgpackages17b05e8b8674f8d203335a62fdfcfa0d11ebe09e23613c3391033cbba35f7926httpcore-1.0.5.tar.gz"
    sha256 "34a38e2f9291467ee3b44e89dd52615370e152954ba21721378a87b2960f7a61"
  end

  resource "httpx" do
    url "https:files.pythonhosted.orgpackages5c2d3da5bdf4408b8b2800061c339f240c1802f2e82d55e50bd39c5a881f47f0httpx-0.27.0.tar.gz"
    sha256 "a0cb88a46f32dc874e04ee956e4c2764aba2aa228f650b06788ba6bda2962ab5"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "iniconfig" do
    url "https:files.pythonhosted.orgpackagesd74bcbd8e699e64a6f16ca3a8220661b5f83792b3017d0f79807cb8708d33913iniconfig-2.0.0.tar.gz"
    sha256 "2d91e135bf72d31a410b17c16da610a82cb55f6b0477d1a902134b24a455b8b3"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackages7aff75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cceJinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "jsonschema" do
    url "https:files.pythonhosted.orgpackages19f11c1dc0f6b3bf9e76f7526562d29c320fa7d6a2f35b37a1392cc0acd58263jsonschema-4.22.0.tar.gz"
    sha256 "5b22d434a45935119af990552c862e5d6d564e8f6601206b305a61fdf661a2b7"
  end

  resource "jsonschema-specifications" do
    url "https:files.pythonhosted.orgpackagesf8b9cc0cc592e7c195fb8a650c1d5990b10175cf13b4c97465c72ec841de9e4bjsonschema_specifications-2023.12.1.tar.gz"
    sha256 "48a76787b3e70f5ed53f1160d2b81f586e4ca6d1548c5de7085d1682674764cc"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackages875baae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02dMarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "openai" do
    url "https:files.pythonhosted.orgpackages1c3ca92cf8844ec4bf3211a42926ed5cab72f18d32bb3a0155a759783b38d6b5openai-1.3.0.tar.gz"
    sha256 "51d9ccd0611fd8567ff595e8a58685c20a4710763d42f6bd968e1fb630993f25"
  end

  resource "outcome" do
    url "https:files.pythonhosted.orgpackages98df77698abfac98571e65ffeb0c1fba8ffd692ab8458d617a0eed7d9a8d38f2outcome-1.3.0.post0.tar.gz"
    sha256 "9dcf02e65f2971b80047b377468e72a268e15c0af3cf1238e6ff14f7f91143b8"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackages516550db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "pluggy" do
    url "https:files.pythonhosted.orgpackages962d02d4312c973c6050a18b314a5ad0b3210edb65a906f868e31c111dede4a6pluggy-1.5.0.tar.gz"
    sha256 "2cffa88e94fdc978c4c574f15f9e59b7f4201d439195c3715ca9e2486f1d0cf1"
  end

  resource "prompt-toolkit" do
    url "https:files.pythonhosted.orgpackages9a0276cadde6135986dc1e82e2928f35ebeb5a1af805e2527fe466285593a2baprompt_toolkit-3.0.39.tar.gz"
    sha256 "04505ade687dc26dc4284b1ad19a83be2f2afe83e7a828ace0c72f3a1df72aac"
  end

  resource "pycparser" do
    url "https:files.pythonhosted.orgpackages1db231537cf4b1ca988837256c910a668b553fceb8f069bedc4b1c826024b52cpycparser-2.22.tar.gz"
    sha256 "491c8be9c040f5390f5bf44a5b07752bd07f56edf992381b05c701439eec10f6"
  end

  resource "pydantic" do
    url "https:files.pythonhosted.orgpackages0dfcccd0e8910bc780f1a4e1ab15e97accbb1f214932e796cff3131f9a943967pydantic-2.7.4.tar.gz"
    sha256 "0c84efd9548d545f63ac0060c1e4d39bb9b14db8b3c0652338aecc07b5adec52"
  end

  resource "pydantic-core" do
    url "https:files.pythonhosted.orgpackages02d0622cdfe12fb138d035636f854eb9dc414f7e19340be395799de87c1de6f6pydantic_core-2.18.4.tar.gz"
    sha256 "ec3beeada09ff865c344ff3bc2f427f5e6c26401cc6113d77e372c3fdac73864"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages896b2114e54b290824197006e41be3f9bbe1a26e9c39d1f5fa20a6d62945a0b3Pygments-2.15.1.tar.gz"
    sha256 "8ace4d3c1dd481894b2005f560ead0f9f19ee64fe983366be1a21e171d12775c"
  end

  resource "pysocks" do
    url "https:files.pythonhosted.orgpackagesbd11293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "pytest" do
    url "https:files.pythonhosted.orgpackagesa7f3dadfbdbf6b6c8b5bd02adb1e08bc9fbb45ba51c68b0893fa536378cdf485pytest-7.4.0.tar.gz"
    sha256 "b4bf8c45bd59934ed84001ad51e11b4ee40d40a1229d2c79f9c592b0a3f6bd8a"
  end

  resource "pytest-asyncio" do
    url "https:files.pythonhosted.orgpackages5a85d39ef5f69d5597a206f213ce387bcdfa47922423875829f7a98a87d33281pytest-asyncio-0.21.1.tar.gz"
    sha256 "40a7eae6dded22c7b604986855ea48400ab15b069ae38116e8c01238e9eeb64d"
  end

  resource "pytest-mock" do
    url "https:files.pythonhosted.orgpackagesd82db3a811ec4fa24190a9ec5013e23c89421a7916167c6240c31fdc445f850cpytest-mock-3.11.1.tar.gz"
    sha256 "7f6b125602ac6d743e523ae0bfa71e1a697a2f5534064528c6ff84c2f7c2fc7f"
  end

  resource "pytest-reportlog" do
    url "https:files.pythonhosted.orgpackagesdaa0d1372b23d415a0766389480633a676fb1530e94ae8f6ea84619cae0ac215pytest-reportlog-0.4.0.tar.gz"
    sha256 "c9f2079504ee51f776d3118dcf5e4730f163d3dcf26ebc8f600c1fa307bf638c"
  end

  resource "python-dotenv" do
    url "https:files.pythonhosted.orgpackages31061ef763af20d0572c032fa22882cfbfb005fba6e7300715a37840858c919epython-dotenv-1.0.0.tar.gz"
    sha256 "a8df96034aae6d2d50a4ebe8216326c61c3eb64836776504fcca410e5937a3ba"
  end

  resource "referencing" do
    url "https:files.pythonhosted.orgpackages995b73ca1f8e72fff6fa52119dbd185f73a907b1989428917b24cff660129b6dreferencing-0.35.1.tar.gz"
    sha256 "25b42124a6c8b632a425174f24087783efb348a6f1e0008e63cd4466fedf703c"
  end

  resource "regex" do
    url "https:files.pythonhosted.orgpackages7adb5ddc89851e9cc003929c3b08b9b88b429459bf9acbf307b4556d51d9e49bregex-2024.5.15.tar.gz"
    sha256 "d3ee02d9e5f482cc8309134a91eeaacbdd2261ba111b0fef3748eeb4913e6a2c"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "rpds-py" do
    url "https:files.pythonhosted.orgpackages2daae7c404bdee1db7be09860dff423d022ffdce9269ec8e6532cce09ee7beearpds_py-0.18.1.tar.gz"
    sha256 "dc48b479d540770c811fbd1eb9ba2bb66951863e448efec2e2c102625328e92f"
  end

  resource "selenium" do
    url "https:files.pythonhosted.orgpackages0444e86a333a57dd81739126f78c73f2243af2bfb728787a7c66046eb923c02eselenium-4.15.2.tar.gz"
    sha256 "22eab5a1724c73d51b240a69ca702997b717eee4ba1f6065bf5d6b44dba01d48"
  end

  resource "sentry-sdk" do
    url "https:files.pythonhosted.orgpackages00e5cf944fd98a68dcde5567949061322577200222d4a897a471e8eaafdbaed4sentry-sdk-1.34.0.tar.gz"
    sha256 "e5d0d2b25931d88fa10986da59d941ac6037f742ab6ff2fce4143a27981d60c3"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "smmap" do
    url "https:files.pythonhosted.orgpackages8804b5bf6d21dc4041000ccba7eb17dd3055feb237e7ffc2c20d3fae3af62baasmmap-5.0.1.tar.gz"
    sha256 "dceeb6c0028fdb6734471eb07c0cd2aae706ccaecab45965ee83f11c8d3b1f62"
  end

  resource "sniffio" do
    url "https:files.pythonhosted.orgpackagesa287a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbdsniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "sortedcontainers" do
    url "https:files.pythonhosted.orgpackagese8c4ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  resource "sounddevice" do
    url "https:files.pythonhosted.orgpackagesd83bc989bde59a1eb333eb2a692f508a09408df562a3f99047a2d030e160cb11sounddevice-0.4.6.tar.gz"
    sha256 "3236b78f15f0415bdf006a620cef073d0c0522851d66f4a961ed6d8eb1482fe9"
  end

  resource "soundfile" do
    url "https:files.pythonhosted.orgpackages6f965ff33900998bad58d5381fd1acfcdac11cbea4f08fc72ac1dc25ffb13f6asoundfile-0.12.1.tar.gz"
    sha256 "e8e1017b2cf1dda767aef19d2fd9ee5ebe07e050d430f77a0a7c66ba08b8cdae"
  end

  resource "termcolor" do
    url "https:files.pythonhosted.orgpackagesb885147a0529b4e80b6b9d021ca8db3a820fcac53ec7374b87073d004aaf444ctermcolor-2.3.0.tar.gz"
    sha256 "b5b08f68937f138fe92f6c089b99f1e2da0ae56c52b78bf7075fd95420fd9a5a"
  end

  resource "tiktoken" do
    url "https:files.pythonhosted.orgpackages9f8877a86f915a81449156375b7538c94105a34bebf00838462c9d3fced490e9tiktoken-0.4.0.tar.gz"
    sha256 "59b20a819969735b48161ced9b92f05dc4519c17be4015cfb73b65270a243620"
  end

  resource "tqdm" do
    url "https:files.pythonhosted.orgpackages6206d5604a70d160f6a6ca5fd2ba25597c24abd5c5ca5f437263d177ac242308tqdm-4.66.1.tar.gz"
    sha256 "d88e651f9db8d8551a62556d3cff9e3034274ca5d66e93197cf2490e2dcb69c7"
  end

  resource "trio" do
    url "https:files.pythonhosted.orgpackages8af307c152213222c615fe2391b8e1fea0f5af83599219050a549c20fcbd9ba2trio-0.24.0.tar.gz"
    sha256 "ffa09a74a6bf81b84f8613909fb0beaee84757450183a7a2e0b47b455c0cac5d"
  end

  resource "trio-websocket" do
    url "https:files.pythonhosted.orgpackagesdd36abad2385853077424a11b818d9fd8350d249d9e31d583cb9c11cd4c85edatrio-websocket-0.11.1.tar.gz"
    sha256 "18c11793647703c158b1f6e62de638acada927344d534e3c7628eedcb746839f"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackages1f7a8b94bb016069caa12fc9f587b28080ac33b4fbb8ca369b98bc0a4828543etyping_extensions-4.8.0.tar.gz"
    sha256 "df8e4339e9cb77357558cbdbceca33c303714cf861d1eef15e1070055ae8b7ef"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages436dfa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages6c6353559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  resource "webdriver-manager" do
    url "https:files.pythonhosted.orgpackagese5502958aa25647e86334b30b4f8c819cc4fd5f15d3d0115042a4c924ec6e94dwebdriver_manager-4.0.1.tar.gz"
    sha256 "25ec177c6a2ce9c02fb8046f1b2732701a9418d6a977967bb065d840a3175d87"
  end

  resource "wsproto" do
    url "https:files.pythonhosted.orgpackagesc94a44d3c295350d776427904d73c189e10aeae66d7f555bb2feee16d1e4ba5awsproto-1.2.0.tar.gz"
    sha256 "ad565f26ecb92588a3e43bc3d96164de84cd9902482b130d0ddbaa9664a85065"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}mentat 2>&1")
    assert_match "No OpenAI api key detected", output
  end
end