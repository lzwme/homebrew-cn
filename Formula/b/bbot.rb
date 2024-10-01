class Bbot < Formula
  include Language::Python::Virtualenv

  desc "OSINT automation tool"
  homepage "https:github.comblacklanternsecuritybbot"
  url "https:files.pythonhosted.orgpackages3fcb24f98ee5843b10e3cc3d007eb02cd24c6f7e52cefe7cc002d15113a95c72bbot-2.0.1.tar.gz"
  sha256 "64bab2eb98605bc357f869e4d7ec82061786423f32542600d679fa85fa051ad3"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "1de99bb61d611077660770fc1313e9024c447bc1ecbae7b427c137b727a908b0"
    sha256 cellar: :any,                 arm64_sonoma:  "b1444695d6f5fcdf925ca3a80c1c74bd490215e0193ad4dee7a708710e213a8d"
    sha256 cellar: :any,                 arm64_ventura: "81f1e8bca31b1fbf3c393bbb49714751370a88274e3a91fdac51444b5666cbe5"
    sha256 cellar: :any,                 sonoma:        "f1df8220d1424f6a57c29e4ae71e2010e8eac16cef71855d224642d63a234ec2"
    sha256 cellar: :any,                 ventura:       "79c7dc329e3b3f17771b7b4f6410332d69531dfd560d823acf1372a803f0f69a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4c2be943e610d8baf73bc2fbbca237cc403582b22633f55c93e8858b10c9056"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "openjdk" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "python@3.12"
  depends_on "zeromq"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "annotated-types" do
    url "https:files.pythonhosted.orgpackagesee67531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "ansible" do
    url "https:files.pythonhosted.orgpackages902555e09468efe564f3b48c47a7e082bd84d4f0d064af60ac8458eba4667994ansible-8.7.0.tar.gz"
    sha256 "3a5ca5152e4547d590e40b542d76b18dbbe2b36da4edd00a13a7c51a374ff737"
  end

  resource "ansible-core" do
    url "https:files.pythonhosted.orgpackagesa1fce81a2e2a6e4247444fe632c8ffaff5c1bcc3adf85ae87d08158724f419fdansible_core-2.15.12.tar.gz"
    sha256 "5fde82cd3928d9857ad880782c644f27d3168b0f25321d5a8d6befa524aa1818"
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
    url "https:files.pythonhosted.orgpackagese6e3c4c8d473d6780ef1853d630d581f70d655b4f8d7553c6997958c283039a2anyio-4.4.0.tar.gz"
    sha256 "5aadc6a1bbb7cdb0bede386cac5e2940f5e2ff3aa20277e991cf028e0585ce94"
  end

  resource "beautifulsoup4" do
    url "https:files.pythonhosted.orgpackagesb3ca824b1195773ce6166d388573fc106ce56d4a805bd7427b624e063596ec58beautifulsoup4-4.12.3.tar.gz"
    sha256 "74e3d1928edc070d21748185c46e3fb33490f22f52a3addee9aee0f4f7781051"
  end

  resource "cachetools" do
    url "https:files.pythonhosted.orgpackagesc338a0f315319737ecf45b4319a8cd1f3a908e29d9277b46942263292115eee7cachetools-5.5.0.tar.gz"
    sha256 "2cc24fb4cbe39633fb7badd9db9ca6295d766d9c2995f245725a46715d050f2a"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "cloudcheck" do
    url "https:files.pythonhosted.orgpackagesa8b104bafc8c11807a1ebaa921809c46b5daa7212ba459ed6976cc057c73a773cloudcheck-5.0.1.547.tar.gz"
    sha256 "43740b552f0201df1bad1acf3a83fb0c566b695b5c156b9e815c9c83be9ae071"
  end

  resource "deepdiff" do
    url "https:files.pythonhosted.orgpackages70106f4b0bd0627d542f63a24f38e29d77095dc63d5f45bc1a7b4a6ca8750fa9deepdiff-7.0.1.tar.gz"
    sha256 "260c16f052d4badbf60351b4f77e8390bee03a0b516246f6839bc813fb429ddf"
  end

  resource "dnspython" do
    url "https:files.pythonhosted.orgpackages377dc871f55054e403fdfd6b8f65fd6d1c4e147ed100d3e9f9ba1fe695403939dnspython-2.6.1.tar.gz"
    sha256 "e8f0f9c23a7b7cb99ded64e6c3a6f3e701d78f50c55e002b839dea7225cff7cc"
  end

  resource "docutils" do
    url "https:files.pythonhosted.orgpackagesaeedaefcc8cd0ba62a0560c3c18c33925362d46c6075480bfa4df87b28e169a9docutils-0.21.2.tar.gz"
    sha256 "3a6b18732edf182daa3cd12775bbb338cf5691468f91eeeb109deff6ebfa986f"
  end

  resource "filelock" do
    url "https:files.pythonhosted.orgpackagese6763981447fd369539aba35797db99a8e2ff7ed01d9aa63e9344a31658b8d81filelock-3.16.0.tar.gz"
    sha256 "81de9eb8453c769b63369f87f11131a7ab04e367f8d97ad39dc230daa07e3bec"
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

  resource "idna" do
    url "https:files.pythonhosted.orgpackages006f93e724eafe34e860d15d37a4f72a1511dd37c43a76a8671b22a15029d545idna-3.9.tar.gz"
    sha256 "e5c5dafde284f26e9e0f28f6ea2d6400abd5ca099864a67f576f3981c6476124"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesed5539036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5djinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
  end

  resource "lockfile" do
    url "https:files.pythonhosted.orgpackages174772cb04a58a35ec495f96984dddb48232b551aafb95bde614605b754fe6f7lockfile-0.12.2.tar.gz"
    sha256 "6aed02de03cba24efabcd600b30540140634fc06cfa603822d508d5361e9f799"
  end

  resource "lxml" do
    url "https:files.pythonhosted.orgpackagese76b20c3a4b24751377aaa6307eb230b66701024012c29dd374999cc92983269lxml-5.3.0.tar.gz"
    sha256 "4e109ca30d1edec1ac60cdbe341905dc3b8f55b16855e03a54aaf59e51ec8c6f"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackages875baae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02dMarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "mmh3" do
    url "https:files.pythonhosted.orgpackages6396aa247e82878b123468f0079ce2ac77e948315bab91ce45d2934a62e0af95mmh3-4.1.0.tar.gz"
    sha256 "a1cf25348b9acd229dda464a094d6170f47d2850a1fcb762a3b6172d2ce6ca4a"
  end

  resource "omegaconf" do
    url "https:files.pythonhosted.orgpackages09486388f1bb9da707110532cb70ec4d2822858ddfb44f1cdf1233c20a80ea4bomegaconf-2.3.0.tar.gz"
    sha256 "d5d4b6d29955cc50ad50c46dc269bcd92c6e00f5f90d23ab5fee7bfca4ba4cc7"
  end

  resource "ordered-set" do
    url "https:files.pythonhosted.orgpackages4ccabfac8bc689799bcca4157e0e0ced07e70ce125193fc2e166d2e685b7e2feordered-set-4.1.0.tar.gz"
    sha256 "694a8e44c87657c59292ede72891eb91d34131f6531463aab3009191c77364a8"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackages516550db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "pexpect" do
    url "https:files.pythonhosted.orgpackages4292cc564bf6381ff43ce1f4d06852fc19a2f11d180f23dc32d9588bee2f149dpexpect-4.9.0.tar.gz"
    sha256 "ee7d41123f3c9911050ea2c2dac107568dc43b2d3b0c7557a33212c398ead30f"
  end

  resource "psutil" do
    url "https:files.pythonhosted.orgpackages90c76dc0a455d111f68ee43f27793971cf03fe29b6ef972042549db29eec39a2psutil-5.9.8.tar.gz"
    sha256 "6be126e3225486dff286a8fb9a06246a5253f4c7c53b475ea5f5ac934e64194c"
  end

  resource "ptyprocess" do
    url "https:files.pythonhosted.orgpackages20e516ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4eptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "pycryptodome" do
    url "https:files.pythonhosted.orgpackagesb9ed19223a0a0186b8a91ebbdd2852865839237a21c74f1fbc4b8d5b62965239pycryptodome-3.20.0.tar.gz"
    sha256 "09609209ed7de61c2b560cc5c8c4fbf892f8b15b1faf7e4cbffac97db1fffda7"
  end

  resource "pydantic" do
    url "https:files.pythonhosted.orgpackages14153d989541b9c8128b96d532cfd2dd10131ddcc75a807330c00feb3d42a5bdpydantic-2.9.1.tar.gz"
    sha256 "1363c7d975c7036df0db2b4a61f2e062fbc0aa5ab5f2772e0ffc7191a4f4bce2"
  end

  resource "pydantic-core" do
    url "https:files.pythonhosted.orgpackages5ccc07bec3fb337ff80eacd6028745bd858b9642f61ee58cfdbfb64451c1def0pydantic_core-2.23.3.tar.gz"
    sha256 "3cb0f65d8b4121c1b015c60104a685feb929a29d7cf204387c7f2688c7974690"
  end

  resource "pyjwt" do
    url "https:files.pythonhosted.orgpackagesfb68ce067f09fca4abeca8771fe667d89cc347d1e99da3e093112ac329c6020epyjwt-2.9.0.tar.gz"
    sha256 "7e1e5b56cc735432a7369cbfa0efe50fa113ebecdc04ae6922deba8b84582d0c"
  end

  resource "python-daemon" do
    url "https:files.pythonhosted.orgpackages845097b81327fccbb70eb99f3c95bd05a0c9d7f13fb3f4cfd975885110d1205apython-daemon-3.0.1.tar.gz"
    sha256 "6c57452372f7eaff40934a1c03ad1826bf5e793558e87fef49131e6464b4dae5"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "pyzmq" do
    url "https:files.pythonhosted.orgpackagesfd05bed626b9f7bb2322cdbbf7b4bd8f54b1b617b0d2ab2d3547d6e39428a48epyzmq-26.2.0.tar.gz"
    sha256 "070672c258581c8e4f640b5159297580a9974b026043bd4ab0470be9ed324f1f"
  end

  resource "radixtarget" do
    url "https:files.pythonhosted.orgpackages8c1967a158229e14089efa732a8b3378331e6491b8c23873c73f0cef5763ca1cradixtarget-1.1.0.18.tar.gz"
    sha256 "1a3306891a22f7ff2c71d6cd42202af8852cdb4fb68e9a1e9a76a3f60aa98ab6"
  end

  resource "regex" do
    url "https:files.pythonhosted.orgpackagesf938148df33b4dbca3bd069b963acab5e0fa1a9dbd6820f8c322d0dd6faeff96regex-2024.9.11.tar.gz"
    sha256 "6c188c307e8433bcb63dc1915022deb553b4203a70722fc542c363bf120a01fd"
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
    url "https:files.pythonhosted.orgpackagesffe1b16b16a1aa12174349d15b73fd4b87e641a8ae3fb1163e80938dbbf6ae98setproctitle-1.3.3.tar.gz"
    sha256 "c913e151e7ea01567837ff037a23ca8740192880198b7fbb90b16d181607caae"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages3e2cf0a538a2f91ce633a78daaeb34cbfb93a54bd2132a6de1f6cec028eee6efsetuptools-74.1.2.tar.gz"
    sha256 "95b40ed940a1c67eb70fc099094bd6e99c6ee7c23aa2306f4d2697ba7916f9c6"
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
    url "https:files.pythonhosted.orgpackagesdbedc92a5d6edaafec52f388c2d2946b4664294299cebf52bb1ef9cbc44ae739tldextract-5.1.2.tar.gz"
    sha256 "c9e17f756f05afb5abac04fe8f766e7e70f9fe387adb1859f0f52408ee060200"
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
    url "https:files.pythonhosted.orgpackagesed6322ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  resource "websockets" do
    url "https:files.pythonhosted.orgpackages2e627a7874b7285413c954a4cca3c11fd851f11b2fe5b4ae2d9bee4f6d9bdb10websockets-12.0.tar.gz"
    sha256 "81df9cbcbb6c260de1e007e58c011bfebe2dafc8435107b0537f393dd38c8b1b"
  end

  resource "wordninja" do
    url "https:files.pythonhosted.orgpackages3015abe4af50f4be92b60c25e43c1c64d08453b51e46c32981d80b3aebec0260wordninja-2.0.0.tar.gz"
    sha256 "1a1cc7ec146ad19d6f71941ee82aef3d31221700f0d8bf844136cf8df79d281a"
  end

  resource "xmltodict" do
    url "https:files.pythonhosted.orgpackages58400d783e14112e064127063fbf5d1fe1351723e5dfe9d6daad346a305f6c49xmltodict-0.12.0.tar.gz"
    sha256 "50d8c638ed7ecb88d90561beedbf720c9b4e851a9fa6c47ebd64e99d166d8a21"
  end

  resource "xmltojson" do
    url "https:files.pythonhosted.orgpackagesdced1d658daeb13fdf59aa90984f94452e76c9ab494bb53bf3ad6cbd37e6e320xmltojson-2.0.2.tar.gz"
    sha256 "10719660409bd1825507e04d2fa4848c10591a092613bcd66651c7e0774f5405"
  end

  resource "yara-python" do
    url "https:files.pythonhosted.orgpackages2f3a0d2970e76215ab7a835ebf06ba0015f98a9d8e11b9969e60f1ca63f04ba5yara_python-4.5.1.tar.gz"
    sha256 "52ab24422b021ae648be3de25090cbf9e6c6caa20488f498860d07f7be397930"
  end

  def install
    venv = virtualenv_install_with_resources without: "python-daemon"

    # Workaround breaking change in `setuptools`: https:pagure.iopython-daemonissue94
    resource("python-daemon").stage do
      inreplace "version.py", "import setuptools.extern.packaging.version", ""
      inreplace "version.py", "self.validate_version(version)", ""
      venv.pip_install Pathname.pwd
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}bbot -s --version")

    assert_predicate testpath".configbbotbbot.yml", :exist?
    assert_predicate testpath".configbbotsecrets.yml", :exist?
  end
end