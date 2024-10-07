class Aider < Formula
  include Language::Python::Virtualenv

  desc "AI pair programming in your terminal"
  homepage "https:aider.chat"
  url "https:files.pythonhosted.orgpackages9461f78dfd9f9f153cf2cffdc7cf3590c1d4e3bc9a79953dbccc30e7529ae63aaider_chat-0.59.1.tar.gz"
  sha256 "5e7ccb8c6b8054563d8c84a20f9d44dafd7f8f2e5fbb68275aa722386f2572f3"
  license "Apache-2.0"
  head "https:github.compaul-gauthieraider.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "77863957bc70d3cac83dade12bfdc0b8ec84a66a86e94300a54d221e208c9387"
    sha256 cellar: :any,                 arm64_sonoma:  "82046e2a7bc6f751196e32183be855f962fb00dbf7e1f88a05fd72b5af38242b"
    sha256 cellar: :any,                 arm64_ventura: "5d74cd69104ce3559aad0a8a807aed77d53d4f6ee3b90098d17c95ac19b10a88"
    sha256 cellar: :any,                 sonoma:        "f04562e9631a5ec8351a7c387d55b3657e83b2c2306f5a782993e0b819f11158"
    sha256 cellar: :any,                 ventura:       "d05862dae7e3dea423968a2b19d151a8203e644326f2717f023bb0ab72675938"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c46b141231ef2fbd12e67fecf1ee63b906fdf2f5f891cdf1a0d394504717c1fd"
  end

  depends_on "cython" => :build # for tree-sitter-languages
  depends_on "python-setuptools" => :build # for tree-sitter-languages
  depends_on "rust" => :build # for pydantic_core
  depends_on "certifi"
  depends_on "cffi"
  depends_on "libyaml"
  depends_on "numpy"
  depends_on "pillow"
  depends_on "python@3.12"
  depends_on "scipy"

  resource "aiohappyeyeballs" do
    url "https:files.pythonhosted.orgpackages2df722bba300a16fd1cad99da1a23793fe43963ee326d012fdf852d0b4035955aiohappyeyeballs-2.4.0.tar.gz"
    sha256 "55a1714f084e63d49639800f95716da97a1f173d46a16dfcfda0016abb93b6b2"
  end

  resource "aiohttp" do
    url "https:files.pythonhosted.orgpackagesca28ca549838018140b92a19001a8628578b0f2a3b38c16826212cc6f706e6d4aiohttp-3.10.5.tar.gz"
    sha256 "f071854b47d39591ce9a17981c46790acb30518e2f83dfca8db2dfa091178691"
  end

  resource "aiosignal" do
    url "https:files.pythonhosted.orgpackagesae670952ed97a9793b4958e5736f6d2b346b414a2cd63e82d05940032f45b32faiosignal-1.3.1.tar.gz"
    sha256 "54cd96e15e1649b75d6c87526a6ff0b6c1b0dd3459f43d9ca11d48c339b68cfc"
  end

  resource "annotated-types" do
    url "https:files.pythonhosted.orgpackagesee67531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "anyio" do
    url "https:files.pythonhosted.orgpackages7849f3f17ec11c4a91fe79275c426658e509b07547f874b14c1a526d86a83fc8anyio-4.6.0.tar.gz"
    sha256 "137b4559cbb034c477165047febb6ff83f390fc3b20bf181c1fc0a728cb8beeb"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackagesfc0faafca9af9315aee06a89ffde799a10a582fe8de76c563ee80bbcdc08b3fbattrs-24.2.0.tar.gz"
    sha256 "5cfb1b9148b5b086569baec03f20d7b6bf3bcacc9a42bebf87ffaaca362f6346"
  end

  resource "backoff" do
    url "https:files.pythonhosted.orgpackages47d75bbeb12c44d7c4f2fb5b56abce497eb5ed9f34d85701de869acedd602619backoff-2.2.1.tar.gz"
    sha256 "03f829f5bb1923180821643f8753b0502c3b682293992485b0eef2807afa5cba"
  end

  resource "beautifulsoup4" do
    url "https:files.pythonhosted.orgpackagesb3ca824b1195773ce6166d388573fc106ce56d4a805bd7427b624e063596ec58beautifulsoup4-4.12.3.tar.gz"
    sha256 "74e3d1928edc070d21748185c46e3fb33490f22f52a3addee9aee0f4f7781051"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "configargparse" do
    url "https:files.pythonhosted.orgpackages708a73f1008adfad01cb923255b924b1528727b8270e67cb4ef41eabdc7d783eConfigArgParse-1.7.tar.gz"
    sha256 "e7067471884de5478c58a511e529f0f9bd1c66bfef1dea90935438d6c23306d1"
  end

  resource "diff-match-patch" do
    url "https:files.pythonhosted.orgpackages48407f0b68e3578453d1ccd3638cfd9682b515b9d22730903a88615f1ee92352diff-match-patch-20230430.tar.gz"
    sha256 "953019cdb9c9d2c9e47b5b12bcff3cf4746fc4598eb406076fa1fc27e6a1f15c"
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
    url "https:files.pythonhosted.orgpackages9ddb3ef5bb276dae18d6ec2124224403d1d67bccdbefc17af4cc8f553e341ab1filelock-3.16.1.tar.gz"
    sha256 "c249fbfcd5db47e5e2d6d62198e565475ee65e4831e2561c8e313fa7eb961435"
  end

  resource "flake8" do
    url "https:files.pythonhosted.orgpackages3772e8d66150c4fcace3c0a450466aa3480506ba2cae7b61e100a2613afc3907flake8-7.1.1.tar.gz"
    sha256 "049d058491e228e03e67b390f311bbf88fce2dbaa8fa673e7aea87b7198b8d38"
  end

  resource "frozenlist" do
    url "https:files.pythonhosted.orgpackagescf3d2102257e7acad73efc4a0c306ad3953f68c504c16982bbdfee3ad75d8085frozenlist-1.4.1.tar.gz"
    sha256 "c037a86e8513059a2613aaba4d817bb90b9d9b6b69aace3ce9c877e8c8ed402b"
  end

  resource "fsspec" do
    url "https:files.pythonhosted.orgpackages627c12b0943011daaaa9c35c2a2e22e5eb929ac90002f08f1259d69aedad84defsspec-2024.9.0.tar.gz"
    sha256 "4b0afb90c2f21832df142f292649035d80b421f60a9e1c027802e5a0da2b04e8"
  end

  resource "gitdb" do
    url "https:files.pythonhosted.orgpackages190dbbb5b5ee188dec84647a4664f3e11b06ade2bde568dbd489d9d64adef8edgitdb-4.0.11.tar.gz"
    sha256 "bf5421126136d6d0af55bc1e7c1af1c397a34f5b7bd79e776cd3e89785c2b04b"
  end

  resource "gitpython" do
    url "https:files.pythonhosted.orgpackagesb6a1106fd9fa2dd989b6fb36e5893961f82992cf676381707253e0bf93eb1662GitPython-3.1.43.tar.gz"
    sha256 "35f314a9f878467f5453cc1fee295c3e18e52f1b99f10f6cf5b1682e968a9e7c"
  end

  resource "grep-ast" do
    url "https:files.pythonhosted.orgpackages5131728334e2f053b4a6c4cd2912b3e40218f9e12e158c2039a458814dd22e1fgrep_ast-0.3.3.tar.gz"
    sha256 "42b8887d57301dc55634368f8d549e9c49c913dafb4d19c9b54c3ddb604fccf4"
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
    url "https:files.pythonhosted.orgpackages788208f8c936781f67d9e6b9eeb8a0c8b4e406136ea4c3d1f89a5db71d42e0e6httpx-0.27.2.tar.gz"
    sha256 "f7c2be1d2f3c3c3160d441802406b206c2b76f5947b11115e6df10c6c65e66c2"
  end

  resource "huggingface-hub" do
    url "https:files.pythonhosted.orgpackages811852812091169325bf609feac958d5612e9c49788155a170352c7d55b6a74chuggingface_hub-0.25.0.tar.gz"
    sha256 "fb5fbe6c12fcd99d187ec7db95db9110fb1a20505f23040a5449a717c1a0db4d"
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
    url "https:files.pythonhosted.orgpackages98bef3e8c6081b684f176b761e6a2fef02a0be939740ed6f54109a2951d806f3importlib_resources-6.4.5.tar.gz"
    sha256 "980862a1d16c9e147a59603677fa2aa5fd82b87f223b6cb870695bcfce830065"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesed5539036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5djinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
  end

  resource "jiter" do
    url "https:files.pythonhosted.orgpackagesd71aaa64be757afc614484b370a4d9fc1747dc9237b37ce464f7f9d9ca2a3d38jiter-0.5.0.tar.gz"
    sha256 "1d916ba875bcab5c5f7d927df998c4cb694d27dceddf3392e58beaf10563368a"
  end

  resource "json5" do
    url "https:files.pythonhosted.orgpackages915951b032d53212a51f17ebbcc01bd4217faab6d6c09ed0d856a987a5f42bbcjson5-0.9.25.tar.gz"
    sha256 "548e41b9be043f9426776f05df8635a00fe06104ea51ed24b67f908856e151ae"
  end

  resource "jsonschema" do
    url "https:files.pythonhosted.orgpackages382e03362ee4034a4c917f697890ccd4aec0800ccf9ded7f511971c75451deecjsonschema-4.23.0.tar.gz"
    sha256 "d71497fef26351a33265337fa77ffeb82423f3ea21283cd9467bb03999266bc4"
  end

  resource "jsonschema-specifications" do
    url "https:files.pythonhosted.orgpackagesf8b9cc0cc592e7c195fb8a650c1d5990b10175cf13b4c97465c72ec841de9e4bjsonschema_specifications-2023.12.1.tar.gz"
    sha256 "48a76787b3e70f5ed53f1160d2b81f586e4ca6d1548c5de7085d1682674764cc"
  end

  resource "litellm" do
    url "https:files.pythonhosted.orgpackagesa84252333ad6499503e7c1c53375259d6a23d3f4fe9d32397f6970a3622e6d1clitellm-1.47.0.tar.gz"
    sha256 "992473938270264a570ef4147e8e6674d46c1d72847ec7d19a2efac781ea1944"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackages875baae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02dMarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "mccabe" do
    url "https:files.pythonhosted.orgpackagese7ff0ffefdcac38932a54d2b5eed4e0ba8a408f215002cd178ad1df0f2806ff8mccabe-0.7.0.tar.gz"
    sha256 "348e0240c33b60bbdf4e523192ef919f28cb2c3d7d5c7794f74009290f236325"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "multidict" do
    url "https:files.pythonhosted.orgpackagesd6be504b89a5e9ca731cd47487e91c469064f8ae5af93b7259758dcfc2b9c848multidict-6.1.0.tar.gz"
    sha256 "22ae2ebf9b0c69d206c003e2f6a914ea33f0a932d4aa16f236afc049d9958f4a"
  end

  resource "networkx" do
    url "https:files.pythonhosted.orgpackagesc480a84676339aaae2f1cfdf9f418701dd634aef9cc76f708ef55c36ff39c3canetworkx-3.2.1.tar.gz"
    sha256 "9f1bb5cf3409bf324e0a722c20bdb4c20ee39bf1c30ce8ae499c8502b0b5e0c6"
  end

  resource "openai" do
    url "https:files.pythonhosted.orgpackagese9804c366e9113527894584a6404f105d134fae83a314dc04a6a99bd0e2459bbopenai-1.47.0.tar.gz"
    sha256 "6e14d6f77c8cf546646afcd87a2ef752505b3710d2564a2e433e17307dfa86a0"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackages516550db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "pathspec" do
    url "https:files.pythonhosted.orgpackagescabcf35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbfpathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "pexpect" do
    url "https:files.pythonhosted.orgpackages4292cc564bf6381ff43ce1f4d06852fc19a2f11d180f23dc32d9588bee2f149dpexpect-4.9.0.tar.gz"
    sha256 "ee7d41123f3c9911050ea2c2dac107568dc43b2d3b0c7557a33212c398ead30f"
  end

  resource "prompt-toolkit" do
    url "https:files.pythonhosted.orgpackages476d0279b119dafc74c1220420028d490c4399b790fc1256998666e3a341879fprompt_toolkit-3.0.47.tar.gz"
    sha256 "1e1b29cb58080b1e69f207c893a1a7bf16d127a5c30c9d17a25a5d77792e5360"
  end

  resource "psutil" do
    url "https:files.pythonhosted.orgpackages18c78c6872f7372eb6a6b2e4708b88419fb46b857f7a2e1892966b851cc79fc9psutil-6.0.0.tar.gz"
    sha256 "8faae4f310b6d969fa26ca0545338b21f73c6b15db7c4a8d934a5482faa818f2"
  end

  resource "ptyprocess" do
    url "https:files.pythonhosted.orgpackages20e516ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4eptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "pycodestyle" do
    url "https:files.pythonhosted.orgpackages43aa210b2c9aedd8c1cbeea31a50e42050ad56187754b34eb214c46709445801pycodestyle-2.12.1.tar.gz"
    sha256 "6838eae08bbce4f6accd5d5572075c63626a15ee3e6f842df996bf62f6d73521"
  end

  resource "pycparser" do
    url "https:files.pythonhosted.orgpackages1db231537cf4b1ca988837256c910a668b553fceb8f069bedc4b1c826024b52cpycparser-2.22.tar.gz"
    sha256 "491c8be9c040f5390f5bf44a5b07752bd07f56edf992381b05c701439eec10f6"
  end

  resource "pydantic" do
    url "https:files.pythonhosted.orgpackagesa9b7d9e3f12af310e1120c21603644a1cd86f59060e040ec5c3a80b8f05fae30pydantic-2.9.2.tar.gz"
    sha256 "d155cef71265d1e9807ed1c32b4c8deec042a44a50a4188b25ac67ecd81a9c0f"
  end

  resource "pydantic-core" do
    url "https:files.pythonhosted.orgpackagese2aa6b6a9b9f8537b872f552ddd46dd3da230367754b6f707b8e1e963f515ea3pydantic_core-2.23.4.tar.gz"
    sha256 "2584f7cf844ac4d970fba483a717dbe10c1c1c96a969bf65d61ffe94df1b2863"
  end

  resource "pydub" do
    url "https:files.pythonhosted.orgpackagesfe9ae6bca0eed82db26562c73b5076539a4a08d3cffd19c3cc5913a3e61145fdpydub-0.25.1.tar.gz"
    sha256 "980a33ce9949cab2a569606b65674d748ecbca4f0796887fd6f46173a7b0d30f"
  end

  resource "pyflakes" do
    url "https:files.pythonhosted.orgpackages57f9669d8c9c86613c9d568757c7f5824bd3197d7b1c6c27553bc5618a27cce2pyflakes-3.2.0.tar.gz"
    sha256 "1c61603ff154621fb2a9172037d84dca3500def8c8b630657d1701f026f8af3f"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages8e628336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "pypandoc" do
    url "https:files.pythonhosted.orgpackages95ac40008af3ae4af9a5cc796803fb4d2ef82385632113f2c74f1ca1e2b5e3edpypandoc-1.13.tar.gz"
    sha256 "31652073c7960c2b03570bd1e94f602ca9bc3e70099df5ead4cea98ff5151c1e"
  end

  resource "pyperclip" do
    url "https:files.pythonhosted.orgpackages30232f0a3efc4d6a32f3b63cdff36cd398d9701d26cda58e3ab97ac79fb5e60dpyperclip-1.9.0.tar.gz"
    sha256 "b7de0142ddc81bfc5c7507eea19da920b92252b548b96186caf94a5e2527d310"
  end

  resource "python-dotenv" do
    url "https:files.pythonhosted.orgpackagesbc57e84d88dfe0aec03b7a2d4327012c1627ab5f03652216c63d49846d7a6c58python-dotenv-1.0.1.tar.gz"
    sha256 "e324ee90a023d808f1959c46bcbc04446a10ced277783dc6ee09987c37ec10ca"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "referencing" do
    url "https:files.pythonhosted.orgpackages995b73ca1f8e72fff6fa52119dbd185f73a907b1989428917b24cff660129b6dreferencing-0.35.1.tar.gz"
    sha256 "25b42124a6c8b632a425174f24087783efb348a6f1e0008e63cd4466fedf703c"
  end

  resource "regex" do
    url "https:files.pythonhosted.orgpackagesf938148df33b4dbca3bd069b963acab5e0fa1a9dbd6820f8c322d0dd6faeff96regex-2024.9.11.tar.gz"
    sha256 "6c188c307e8433bcb63dc1915022deb553b4203a70722fc542c363bf120a01fd"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackages927640f084cb7db51c9d1fa29a7120717892aeda9a7711f6225692c957a93535rich-13.8.1.tar.gz"
    sha256 "8260cda28e3db6bf04d2d1ef4dbc03ba80a824c88b0e7668a0f23126a424844a"
  end

  resource "rpds-py" do
    url "https:files.pythonhosted.orgpackages5564b693f262791b818880d17268f3f8181ef799b0d187f6f731b1772e05a29arpds_py-0.20.0.tar.gz"
    sha256 "d72a210824facfdaf8768cf2d7ca25a042c30320b3020de2fa04640920d4e121"
  end

  resource "smmap" do
    url "https:files.pythonhosted.orgpackages8804b5bf6d21dc4041000ccba7eb17dd3055feb237e7ffc2c20d3fae3af62baasmmap-5.0.1.tar.gz"
    sha256 "dceeb6c0028fdb6734471eb07c0cd2aae706ccaecab45965ee83f11c8d3b1f62"
  end

  resource "sniffio" do
    url "https:files.pythonhosted.orgpackagesa287a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbdsniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "sounddevice" do
    url "https:files.pythonhosted.orgpackages879262d87d7b53a4e1041f0d9e049e225fce3c7bc266c0162c023feb245b999dsounddevice-0.5.0.tar.gz"
    sha256 "0de95277654b3d403d9c15ded3c6cedf307e9b27cc9ce7bd995a2891d0c955af"
  end

  resource "soundfile" do
    url "https:files.pythonhosted.orgpackages6f965ff33900998bad58d5381fd1acfcdac11cbea4f08fc72ac1dc25ffb13f6asoundfile-0.12.1.tar.gz"
    sha256 "e8e1017b2cf1dda767aef19d2fd9ee5ebe07e050d430f77a0a7c66ba08b8cdae"
  end

  resource "soupsieve" do
    url "https:files.pythonhosted.orgpackagesd7cefbaeed4f9fb8b2daa961f90591662df6a86c1abf25c548329a86920aedfbsoupsieve-2.6.tar.gz"
    sha256 "e2e68417777af359ec65daac1057404a3c8a5455bb8abc36f1a9866ab1a51abb"
  end

  resource "tiktoken" do
    url "https:files.pythonhosted.orgpackagesc44aabaec53e93e3ef37224a4dd9e2fc6bb871e7a538c2b6b9d2a6397271daf4tiktoken-0.7.0.tar.gz"
    sha256 "1077266e949c24e0291f6c350433c6f0971365ece2b173a23bc3b9f9defef6b6"
  end

  resource "tokenizers" do
    url "https:files.pythonhosted.orgpackages48042071c150f374aab6d5e92aaec38d0f3c368d227dd9e0469a1f0966ac68d1tokenizers-0.19.1.tar.gz"
    sha256 "ee59e6680ed0fdbe6b724cf38bd70400a0c1dd623b07ac729087270caeac88e3"
  end

  resource "tqdm" do
    url "https:files.pythonhosted.orgpackages58836ba9844a41128c62e810fddddd72473201f3eacde02046066142a2d96cc5tqdm-4.66.5.tar.gz"
    sha256 "e1020aef2e5096702d8a025ac7d16b1577279c9d63f8375b63083e9a5f0fcbad"
  end

  resource "tree-sitter" do
    url "https:files.pythonhosted.orgpackages399eb7cb190aa08e4ea387f2b1531da03efb4b8b033426753c0b97e3698645f6tree-sitter-0.21.3.tar.gz"
    sha256 "b5de3028921522365aa864d95b3c41926e0ba6a85ee5bd000e10dc49b0766988"
  end

  # sdist issue report, https:github.comgrantjenkspy-tree-sitter-languagesissues63
  resource "tree-sitter-languages" do
    url "https:github.comgrantjenkspy-tree-sitter-languagesarchiverefstagsv1.10.2.tar.gz"
    sha256 "cdd03196ebaf8f486db004acd07a5b39679562894b47af6b20d28e4aed1a6ab5"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesdfdbf35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesed6322ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages6c6353559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  resource "yarl" do
    url "https:files.pythonhosted.orgpackagese43d4924f9ed49698bac5f112bc9b40aa007bbdcd702462c1df3d2e1383fb158yarl-1.11.1.tar.gz"
    sha256 "1bb2d9e212fb7449b8fb73bc461b51eaa17cc8430b4a87d87be7b25052d92f53"
  end

  resource "zipp" do
    url "https:files.pythonhosted.orgpackages54bf5c0000c44ebc80123ecbdddba1f5dcd94a5ada602a9c225d84b5aaa55e86zipp-3.20.2.tar.gz"
    sha256 "bc9eb26f4506fda01b81bcde0ca78103b6e62f991b381fec825435c836edbc29"
  end

  def install
    python3 = "python3.12"
    venv = virtualenv_install_with_resources without: "tree-sitter-languages"

    # Requires building languages outside `setup.py`: https:github.comgrantjenkspy-tree-sitter-languagespull65
    resource("tree-sitter-languages").stage do
      ENV.prepend_path "PYTHONPATH", Formula["cython"].opt_libexecLanguage::Python.site_packages(python3)
      system venv.root"binpython", "build.py"
      venv.pip_install Pathname.pwd
    end
  end

  test do
    mkdir "tmptestdir" do
      assert_match version.to_s, shell_output("#{bin}aider --version")
      assert_match "OPENAI_API_KEY: Not set", shell_output("#{bin}aider --yes --exit --no-check-update")
      ENV["OPENAI_API_KEY"] = "invalid"
      output = shell_output("#{bin}aider --yes --exit --message=test --no-check-update 2>&1")
      assert_match "Incorrect API key", output
    end
  end
end