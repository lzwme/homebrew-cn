class Bbot < Formula
  include Language::Python::Virtualenv

  desc "OSINT automation tool"
  homepage "https:github.comblacklanternsecuritybbot"
  url "https:files.pythonhosted.orgpackagesace457bcd8983c0a22ea49552345b4f508bd8d03f0025a0a74064d9137bed15dbbot-2.4.0.tar.gz"
  sha256 "049a3235a090846a13d91f3df77b1c8974a2f08ce410982a95a6832c19f3ebde"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "300979563b389e707c3ff49eb11fd7a914de61c268aaf27380052db962c566ab"
    sha256 cellar: :any,                 arm64_sonoma:  "c40a74c65d5705e6a93e5f95d5742e363432bc3e06911e310d47ff6a79f9d833"
    sha256 cellar: :any,                 arm64_ventura: "fb7a402a964365e1349940ae71f165ded328a4ddd2f92b396af9e937385d1f4b"
    sha256 cellar: :any,                 sonoma:        "b949e4a22b9e7b34389f376a817bfb4e89eaef4b887ff75290a6580d6e11fe03"
    sha256 cellar: :any,                 ventura:       "664718f88fd17c342ef8a01cd593e071b5f64a706c588e03f7d8685e636a61b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24f3aec722ff2f598fc4215f5e651a15eda980cc13508fe2b3e8eb41cbe51540"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "openjdk" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "python@3.13"
  depends_on "zeromq"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "annotated-types" do
    url "https:files.pythonhosted.orgpackagesee67531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "ansible-core" do
    url "https:files.pythonhosted.orgpackages3926409259cf95b0ef3471f45837cfda01ae87bcced66dfef7691715184550cfansible_core-2.18.3.tar.gz"
    sha256 "8c4eaca40845238e2601b9bc9dbfbd4f6ed3502cb8b2632789f75ce478abfdee"
  end

  resource "ansible-runner" do
    url "https:files.pythonhosted.orgpackagese0b4842698d5c17b3cae7948df4c812e01f4199dfb9f35b1c0bb51cf2fe5c246ansible-runner-2.4.0.tar.gz"
    sha256 "82d02b2548830f37a53517b65c823c4af371069406c7d213b5c9041d45e0c5b6"
  end

  resource "antlr4-python3-runtime" do
    url "https:files.pythonhosted.orgpackages3e387859ff46355f76f8d19459005ca000b6e7012f2f1ca597746cbcd1fbfe5eantlr4-python3-runtime-4.9.3.tar.gz"
    sha256 "f224469b4168294902bb1efa80a8bf7855f24c99aef99cbefc1bcd3cce77881b"
  end

  resource "anyio" do
    url "https:files.pythonhosted.orgpackagesa373199a98fc2dae33535d6b8e8e6ec01f8c1d76c9adb096c6b7d64823038cdeanyio-4.8.0.tar.gz"
    sha256 "1d9fe889df5212298c0c0723fa20479d1b94883a2df44bd3897aa91083316f7a"
  end

  resource "beautifulsoup4" do
    url "https:files.pythonhosted.orgpackagesf03cadaf39ce1fb4afdd21b611e3d530b183bb7759c9b673d60db0e347fd4439beautifulsoup4-4.13.3.tar.gz"
    sha256 "1bd32405dacc920b42b83ba01644747ed77456a65760e285fbc47633ceddaf8b"
  end

  resource "cachetools" do
    url "https:files.pythonhosted.orgpackages6c813747dad6b14fa2cf53fcf10548cf5aea6913e96fab41a3c198676f8948a5cachetools-5.5.2.tar.gz"
    sha256 "1a661caa9175d26759571b2e19580f9d6393969e5dfca11fdb1f947a23e640d4"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages16b0572805e227f01586461c80e0fd25d65a2115599cc9dad142fee4b747c357charset_normalizer-3.4.1.tar.gz"
    sha256 "44251f18cd68a75b56585dd00dae26183e102cd5e0f9f1466e6df5da2ed64ea3"
  end

  resource "cloudcheck" do
    url "https:files.pythonhosted.orgpackagesbf8a58f1df20c4e59936df7a3bb62a6ea1eeae7ffe87996224b64b4e531b7d90cloudcheck-7.0.47.tar.gz"
    sha256 "61c4a3b70dcd86349c72e3179e427e7db6ee046cc88ba0d76ada1bea84223242"
  end

  resource "deepdiff" do
    url "https:files.pythonhosted.orgpackages8912207d2ec96a526cf9d04fc2423ff9832e93b665e94b9d7c9b5198903e18a7deepdiff-8.2.0.tar.gz"
    sha256 "6ec78f65031485735545ffbe7a61e716c3c2d12ca6416886d5e9291fc76c46c3"
  end

  resource "dnspython" do
    url "https:files.pythonhosted.orgpackagesb54a263763cb2ba3816dd94b08ad3a33d5fdae34ecb856678773cc40a3605829dnspython-2.7.0.tar.gz"
    sha256 "ce9c432eda0dc91cf618a5cedf1a4e142651196bbcd2c80e89ed5a907e5cfaf1"
  end

  resource "filelock" do
    url "https:files.pythonhosted.orgpackagesdc9c0b15fb47b464e1b663b1acd1253a062aa5feecb07d4e597daea542ebd2b5filelock-3.17.0.tar.gz"
    sha256 "ee4e77401ef576ebb38cd7f13b9b28893194acc20a8e68e18730ba9c0e54660e"
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
    url "https:files.pythonhosted.orgpackages788208f8c936781f67d9e6b9eeb8a0c8b4e406136ea4c3d1f89a5db71d42e0e6httpx-0.27.2.tar.gz"
    sha256 "f7c2be1d2f3c3c3160d441802406b206c2b76f5947b11115e6df10c6c65e66c2"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesaf92b3130cbbf5591acf9ade8708c365f3238046ac7cb8ccba6e81abccb0ccffjinja2-3.1.5.tar.gz"
    sha256 "8fefff8dc3034e27bb80d67c671eb8a9bc424c0ef4c0826edbff304cceff43bb"
  end

  resource "lockfile" do
    url "https:files.pythonhosted.orgpackages174772cb04a58a35ec495f96984dddb48232b551aafb95bde614605b754fe6f7lockfile-0.12.2.tar.gz"
    sha256 "6aed02de03cba24efabcd600b30540140634fc06cfa603822d508d5361e9f799"
  end

  resource "lxml" do
    url "https:files.pythonhosted.orgpackageseff6c15ca8e5646e937c148e147244817672cf920b56ac0bf2cc1512ae674be8lxml-5.3.1.tar.gz"
    sha256 "106b7b5d2977b339f1e97efe2778e2ab20e99994cbb0ec5e55771ed0795920c8"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackagesb2975d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "mmh3" do
    url "https:files.pythonhosted.orgpackages471b1fc6888c74cbd8abad1292dde2ddfcf8fc059e114c97dd6bf16d12f36293mmh3-5.1.0.tar.gz"
    sha256 "136e1e670500f177f49ec106a4ebf0adf20d18d96990cc36ea492c651d2b406c"
  end

  resource "omegaconf" do
    url "https:files.pythonhosted.orgpackages09486388f1bb9da707110532cb70ec4d2822858ddfb44f1cdf1233c20a80ea4bomegaconf-2.3.0.tar.gz"
    sha256 "d5d4b6d29955cc50ad50c46dc269bcd92c6e00f5f90d23ab5fee7bfca4ba4cc7"
  end

  resource "orderly-set" do
    url "https:files.pythonhosted.orgpackagese70eef328b512c2595831304e51f25e9287697b7bf13be0527ca9592a2659c16orderly_set-5.3.0.tar.gz"
    sha256 "80b3d8fdd3d39004d9aad389eaa0eab02c71f0a0511ba3a6d54a935a6c6a0acc"
  end

  resource "orjson" do
    url "https:files.pythonhosted.orgpackagesaef95dea21763eeff8c1590076918a446ea3d6140743e0e36f58f369928ed0f4orjson-3.10.15.tar.gz"
    sha256 "05ca7fe452a2e9d8d9d706a2984c95b9c2ebc5db417ce0b7a49b91d50642a23e"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesd06368dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106dapackaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "pexpect" do
    url "https:files.pythonhosted.orgpackages4292cc564bf6381ff43ce1f4d06852fc19a2f11d180f23dc32d9588bee2f149dpexpect-4.9.0.tar.gz"
    sha256 "ee7d41123f3c9911050ea2c2dac107568dc43b2d3b0c7557a33212c398ead30f"
  end

  resource "psutil" do
    url "https:files.pythonhosted.orgpackages2a80336820c1ad9286a4ded7e845b2eccfcb27851ab8ac6abece774a6ff4d3depsutil-7.0.0.tar.gz"
    sha256 "7be9c3eba38beccb6495ea33afd982a44074b78f28c434a1f51cc07fd315c456"
  end

  resource "ptyprocess" do
    url "https:files.pythonhosted.orgpackages20e516ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4eptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "puremagic" do
    url "https:files.pythonhosted.orgpackages092d40599f25667733e41bbc3d7e4c7c36d5e7860874aa5fe9c584e90b34954dpuremagic-1.28.tar.gz"
    sha256 "195893fc129657f611b86b959aab337207d6df7f25372209269ed9e303c1a8c0"
  end

  resource "pycryptodome" do
    url "https:files.pythonhosted.orgpackages135213b9db4a913eee948152a079fe58d035bd3d1a519584155da8e786f767e6pycryptodome-3.21.0.tar.gz"
    sha256 "f7787e0d469bdae763b876174cf2e6c0f7be79808af26b1da96f1a64bcf47297"
  end

  resource "pydantic" do
    url "https:files.pythonhosted.orgpackagesb7aed5220c5c52b158b1de7ca89fc5edb72f304a70a4c540c84c8844bf4008depydantic-2.10.6.tar.gz"
    sha256 "ca5daa827cce33de7a42be142548b0096bf05a7e7b365aebfa5f8eeec7128236"
  end

  resource "pydantic-core" do
    url "https:files.pythonhosted.orgpackagesfc01f3e5ac5e7c25833db5eb555f7b7ab24cd6f8c322d3a3ad2d67a952dc0abcpydantic_core-2.27.2.tar.gz"
    sha256 "eb026e5a4c1fee05726072337ff51d1efb6f59090b7da90d30ea58625b1ffb39"
  end

  resource "pyjwt" do
    url "https:files.pythonhosted.orgpackagese746bd74733ff231675599650d3e47f361794b22ef3e3770998dda30d3b63726pyjwt-2.10.1.tar.gz"
    sha256 "3cc5772eb20009233caf06e9d8a0577824723b44e6648ee0a2aedb6cf9381953"
  end

  resource "python-daemon" do
    url "https:files.pythonhosted.orgpackages3d374f10e37bdabc058a32989da2daf29e57dc59dbc5395497f3d36d5f5e2694python_daemon-3.1.2.tar.gz"
    sha256 "f7b04335adc473de877f5117e26d5f1142f4c9f7cd765408f0877757be5afbf4"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "pyzmq" do
    url "https:files.pythonhosted.orgpackages5ae38d0382cb59feb111c252b54e8728257416a38ffcb2243c4e4775a3c990fepyzmq-26.2.1.tar.gz"
    sha256 "17d72a74e5e9ff3829deb72897a175333d3ef5b5413948cae3cf7ebf0b02ecca"
  end

  resource "radixtarget" do
    url "https:files.pythonhosted.orgpackages26891c19b98c48f703fe654f3e7d8986556573fe412945f13842240b7cf87e9aradixtarget-3.0.15.tar.gz"
    sha256 "dedfad3aea1e973f261b7bc0d8936423f59ae4d082648fd496c6cdfdfa069fea"
  end

  resource "regex" do
    url "https:files.pythonhosted.orgpackages8e5fbd69653fbfb76cf8604468d3b4ec4c403197144c7bfe0e6a5fc9e02a07cbregex-2024.11.6.tar.gz"
    sha256 "7ab159b063c52a0333c884e4679f8d7a85112ee3078fe3d9004b2dd875585519"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "requests-file" do
    url "https:files.pythonhosted.orgpackages7297bf44e6c6bd8ddbb99943baf7ba8b1a8485bcd2fe0e55e5708d7fee4ff1aerequests_file-2.1.0.tar.gz"
    sha256 "0f549a3f3b0699415ac04d167e9cb39bccfb730cb832b4d20be3d9867356e658"
  end

  resource "resolvelib" do
    url "https:files.pythonhosted.orgpackagesce10f699366ce577423cbc3df3280063099054c23df70856465080798c6ebad6resolvelib-1.0.1.tar.gz"
    sha256 "04ce76cbd63fded2078ce224785da6ecd42b9564b1390793f64ddecbe997b309"
  end

  resource "setproctitle" do
    url "https:files.pythonhosted.orgpackagesc44d6a840c8d2baa07b57329490e7094f90aac177a1d5226bc919046f1106860setproctitle-1.3.5.tar.gz"
    sha256 "1e6eaeaf8a734d428a95d8c104643b39af7d247d604f40a7bebcf3960a853c5e"
  end

  resource "sniffio" do
    url "https:files.pythonhosted.orgpackagesa287a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbdsniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "socksio" do
    url "https:files.pythonhosted.orgpackagesf85c48a7d9495be3d1c651198fd99dbb6ce190e2274d0f28b9051307bdec6b85socksio-1.0.0.tar.gz"
    sha256 "f88beb3da5b5c38b9890469de67d0cb0f9d494b78b106ca1845f96c10b91c4ac"
  end

  resource "soupsieve" do
    url "https:files.pythonhosted.orgpackagesd7cefbaeed4f9fb8b2daa961f90591662df6a86c1abf25c548329a86920aedfbsoupsieve-2.6.tar.gz"
    sha256 "e2e68417777af359ec65daac1057404a3c8a5455bb8abc36f1a9866ab1a51abb"
  end

  resource "tabulate" do
    url "https:files.pythonhosted.orgpackages7a53afac341569b3fd558bf2b5428e925e2eb8753ad9627c1f9188104c6e0c4atabulate-0.8.10.tar.gz"
    sha256 "6c57f3f3dd7ac2782770155f3adb2db0b1a269637e42f27599925e64b114f519"
  end

  resource "tldextract" do
    url "https:files.pythonhosted.orgpackages4a4feee4bebcbad25a798bf55601d3a4aee52003bebcf9e55fce08b91ca541a9tldextract-5.1.3.tar.gz"
    sha256 "d43c7284c23f5dc8a42fd0fee2abede2ff74cc622674e4cb07f514ab3330c338"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesdfdbf35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "unidecode" do
    url "https:files.pythonhosted.orgpackagesf78919151076a006b9ac0dd37b1354e031f5297891ee507eb624755e58e10d3eUnidecode-1.3.8.tar.gz"
    sha256 "cfdb349d46ed3873ece4586b96aa75258726e2fa8ec21d6f00a591d98806c2f4"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesaa63e53da845320b757bf29ef6a9062f5c669fe997973f966045cb019c3f4b66urllib3-2.3.0.tar.gz"
    sha256 "f8c5449b3cf0861679ce7e0503c7b44b5ec981bec0d1d3795a07f1ba96f0204d"
  end

  resource "websockets" do
    url "https:files.pythonhosted.orgpackages2e7a8bc4d15af7ff30f7ba34f9a172063bfcee9f5001d7cef04bee800a658f33websockets-15.0.tar.gz"
    sha256 "ca36151289a15b39d8d683fd8b7abbe26fc50be311066c5f8dcf3cb8cee107ab"
  end

  resource "wordninja" do
    url "https:files.pythonhosted.orgpackages3015abe4af50f4be92b60c25e43c1c64d08453b51e46c32981d80b3aebec0260wordninja-2.0.0.tar.gz"
    sha256 "1a1cc7ec146ad19d6f71941ee82aef3d31221700f0d8bf844136cf8df79d281a"
  end

  resource "xmltodict" do
    url "https:files.pythonhosted.orgpackages500551dcca9a9bf5e1bce52582683ce50980bcadbc4fa5143b9f2b19ab99958fxmltodict-0.14.2.tar.gz"
    sha256 "201e7c28bb210e374999d1dde6382923ab0ed1a8a5faeece48ab525b7810a553"
  end

  resource "xmltojson" do
    url "https:files.pythonhosted.orgpackagesc5bd7ff42737e3715eaf0e46714776c2ce75c0d509c7b2e921fa0f94d031a1ffxmltojson-2.0.3.tar.gz"
    sha256 "68a0022272adf70b8f2639186172c808e9502cd03c0b851a65e0760561c7801d"
  end

  resource "yara-python" do
    url "https:files.pythonhosted.orgpackages2f3a0d2970e76215ab7a835ebf06ba0015f98a9d8e11b9969e60f1ca63f04ba5yara_python-4.5.1.tar.gz"
    sha256 "52ab24422b021ae648be3de25090cbf9e6c6caa20488f498860d07f7be397930"
  end

  def install
    # The source doesn't have a valid SOURCE_DATE_EPOCH, so here we set default.
    ENV["SOURCE_DATE_EPOCH"] = "1451574000"

    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}bbot -s --version")

    assert_path_exists testpath".configbbotbbot.yml"
    assert_path_exists testpath".configbbotsecrets.yml"
  end
end