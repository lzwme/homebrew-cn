class Bbot < Formula
  include Language::Python::Virtualenv

  desc "OSINT automation tool"
  homepage "https:github.comblacklanternsecuritybbot"
  url "https:files.pythonhosted.orgpackagesb144d4280e1f817b92c7d9be6f7a9dc05a61998bb782c73ff4dc7636400d5454bbot-1.1.6.1.tar.gz"
  sha256 "58aa92ce506a76b998badfed9a895c551c38ba3845284325ec15b4bd2a45a352"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ebd83dc20936bd6f4eb503d1d83f4619f8dfa8e9533aa1239e07e5fb1de1b37a"
    sha256 cellar: :any,                 arm64_ventura:  "2396506e18eeb7edd3f0461e01c7f7dce4044a895e75fc31bf25cb57eb560b7d"
    sha256 cellar: :any,                 arm64_monterey: "f0474a013bdea51c82b08b9062c213f291e101b8b0a54a58d714fbc85571c2fb"
    sha256 cellar: :any,                 sonoma:         "a8d49efed4d21cc91a5e10451464f6485eeac2540ba2f7ba55194a63bfecb4aa"
    sha256 cellar: :any,                 ventura:        "11bdbb384f74c66aec04667b510c966321f1fd2f95dff54fae30ca4193dddd23"
    sha256 cellar: :any,                 monterey:       "7c49d63b22028098454bd398c0540c5096fd532b2f00b0698cc27f54866f9065"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5fedc44ce0d310eae875b33f6881ad226d5ee7dfbf326764822cb4360ac763c"
  end

  depends_on "openjdk" => :build
  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.12"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "aioconsole" do
    url "https:files.pythonhosted.orgpackages5f14e5c634fad6a95ffd602fbbd1aa107f05a8ffb79d33ec0d0477f3b137f8a9aioconsole-0.6.2.tar.gz"
    sha256 "bac11286f1062613d2523ceee1ba81c676cd269812b865b66b907448a7b5f63e"
  end

  resource "annotated-types" do
    url "https:files.pythonhosted.orgpackages67fe8c7b275824c6d2cd17c93ee85d0ee81c090285b6d52f4876ccc47cf9c3c4annotated_types-0.6.0.tar.gz"
    sha256 "563339e807e53ffd9c267e99fc6d9ea23eb8443c08f112651963e24e22f84a5d"
  end

  resource "ansible" do
    url "https:files.pythonhosted.orgpackages3947bef8fd8bc2b6e7b5058b61565959c91819eccb8be119a66f8524c0252c62ansible-7.7.0.tar.gz"
    sha256 "9c206ba515f13a0cc9c919d496218ba26df581755bdc39be85b074066c699a02"
  end

  resource "ansible-core" do
    url "https:files.pythonhosted.orgpackagesfb3ca9b8fd97e393406c651d3b12571ab2e43b227709cbc6b57d4c9b55e7f0f5ansible-core-2.14.15.tar.gz"
    sha256 "f987222edf3ac1d1a7ca1356e9f4818fbe9222c13681436ebc19fdf9af994e9d"
  end

  resource "ansible-runner" do
    url "https:files.pythonhosted.orgpackages78db7c615d2be8a98e08d31e90c6b89555919b3b7882885407b885c211ad8b93ansible-runner-2.3.6.tar.gz"
    sha256 "b2174a12dcad2dc2f342ea82876898f568a0b66c53568600bf80577158fcba1c"
  end

  resource "antlr4-python3-runtime" do
    url "https:files.pythonhosted.orgpackages3e387859ff46355f76f8d19459005ca000b6e7012f2f1ca597746cbcd1fbfe5eantlr4-python3-runtime-4.9.3.tar.gz"
    sha256 "f224469b4168294902bb1efa80a8bf7855f24c99aef99cbefc1bcd3cce77881b"
  end

  resource "anyio" do
    url "https:files.pythonhosted.orgpackagesdb4d3970183622f0330d3c23d9b8a5f52e365e50381fd484d08e3285104333d3anyio-4.3.0.tar.gz"
    sha256 "f75253795a87df48568485fd18cdd2a3fa5c4f7c5be8e5e36637733fce06fed6"
  end

  resource "beautifulsoup4" do
    url "https:files.pythonhosted.orgpackagesb3ca824b1195773ce6166d388573fc106ce56d4a805bd7427b624e063596ec58beautifulsoup4-4.12.3.tar.gz"
    sha256 "74e3d1928edc070d21748185c46e3fb33490f22f52a3addee9aee0f4f7781051"
  end

  resource "cachetools" do
    url "https:files.pythonhosted.orgpackagesb34d27a3e6dd09011649ad5210bdf963765bc8fa81a0827a4fc01bafd2705c5bcachetools-5.3.3.tar.gz"
    sha256 "ba29e2dfa0b8b556606f097407ed1aa62080ee108ab0dc5ec9d6a723a007d105"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "cloudcheck" do
    url "https:files.pythonhosted.orgpackages9e5df13187fabe21440fad1b3c0f5e0517c9d23cb37b9dd47a2454ebeed6efdbcloudcheck-2.2.0.203.tar.gz"
    sha256 "83eb239b024579712a19d736dc9649eff4a3f6e9314db3cd94faa883adbfe46c"
  end

  resource "deepdiff" do
    url "https:files.pythonhosted.orgpackages5211d265eb046685fe97538e39f71d16d58a1197ddbd59873e06167bcfba8a89deepdiff-6.7.1.tar.gz"
    sha256 "b367e6fa6caac1c9f500adc79ada1b5b1242c50d5f716a1a4362030197847d30"
  end

  resource "dnspython" do
    url "https:files.pythonhosted.orgpackages377dc871f55054e403fdfd6b8f65fd6d1c4e147ed100d3e9f9ba1fe695403939dnspython-2.6.1.tar.gz"
    sha256 "e8f0f9c23a7b7cb99ded64e6c3a6f3e701d78f50c55e002b839dea7225cff7cc"
  end

  resource "docutils" do
    url "https:files.pythonhosted.orgpackages679aff2ff8e922f3b97c4b4864ca6c78d76ca5969bd730560001167b7054ac48docutils-0.21.post1.tar.gz"
    sha256 "518e29081124e7d8159550958e6de240622562aa824f945f501ec3d3c5b67d19"
  end

  resource "filelock" do
    url "https:files.pythonhosted.orgpackages38ff877f1dbe369a2b9920e2ada3c9ab81cf6fe8fa2dce45f40cad510ef2df62filelock-3.13.4.tar.gz"
    sha256 "d13f466618bfde72bd2c18255e269f72542c6e70e7bac83a0232d6b1cc5c8cf4"
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
    url "https:files.pythonhosted.orgpackagesbd262dc654950920f499bd062a211071925533f821ccdca04fa0c2fd914d5d06httpx-0.26.0.tar.gz"
    sha256 "451b55c30d5185ea6b23c2c793abf9bb237d2a7dfb901ced6ff69ad37ec1dfaf"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesbf3fea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesb25e3a21abf3cd467d7876045335e681d276ac32492febe6d98ad89562d1a7e1Jinja2-3.1.3.tar.gz"
    sha256 "ac8bd6544d4bb2c9792bf3a159e80bba8fda7f07e81bc3aed565432d5925ba90"
  end

  resource "lockfile" do
    url "https:files.pythonhosted.orgpackages174772cb04a58a35ec495f96984dddb48232b551aafb95bde614605b754fe6f7lockfile-0.12.2.tar.gz"
    sha256 "6aed02de03cba24efabcd600b30540140634fc06cfa603822d508d5361e9f799"
  end

  resource "lxml" do
    url "https:files.pythonhosted.orgpackages8414c2070b5e37c650198de8328467dd3d1681e80986f81ba0fea04fc4ec9883lxml-4.9.4.tar.gz"
    sha256 "b1541e50b78e15fa06a2670157a1962ef06591d4c998b998047fff5e3236880e"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackages875baae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02dMarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
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
    url "https:files.pythonhosted.orgpackageseeb5b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4dpackaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
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
    url "https:files.pythonhosted.orgpackages4bde38b517edac45dd022e5d139aef06f9be4762ec2e16e2b14e1634ba28886bpydantic-2.6.4.tar.gz"
    sha256 "b1704e0847db01817624a6b86766967f552dd9dbf3afba4004409f908dcc84e6"
  end

  resource "pydantic-core" do
    url "https:files.pythonhosted.orgpackages773f65dbe5231946fe02b4e6ea92bc303d2462f45d299890fd5e8bfe4d1c3d66pydantic_core-2.16.3.tar.gz"
    sha256 "1cac689f80a3abab2d3c0048b29eea5751114054f032a941a32de4c852c59cad"
  end

  resource "pyjwt" do
    url "https:files.pythonhosted.orgpackages30728259b2bccfe4673330cea843ab23f86858a419d8f1493f66d413a76c7e3bPyJWT-2.8.0.tar.gz"
    sha256 "57e28d156e3d5c10088e0c68abb90bfac3df82b40a71bd0daa20c65ccd5c23de"
  end

  resource "python-daemon" do
    url "https:files.pythonhosted.orgpackages845097b81327fccbb70eb99f3c95bd05a0c9d7f13fb3f4cfd975885110d1205apython-daemon-3.0.1.tar.gz"
    sha256 "6c57452372f7eaff40934a1c03ad1826bf5e793558e87fef49131e6464b4dae5"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackagescde5af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-file" do
    url "https:files.pythonhosted.orgpackages2b69ba1b5f52f96cde4f2d8eca74a0aa2c11a66b2fe58d0fb63b2e46edce6ed3requests-file-2.0.0.tar.gz"
    sha256 "20c5931629c558fda566cacc10cfe2cd502433e628f568c34c80d96a0cc95972"
  end

  resource "resolvelib" do
    url "https:files.pythonhosted.orgpackagesac209541749d77aebf66dd92e2b803f38a50e3a5c76e7876f45eb2b37e758d82resolvelib-0.8.1.tar.gz"
    sha256 "c6ea56732e9fb6fca1b2acc2ccc68a0b6b8c566d8f3e78e0443310ede61dbd37"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages4d5bdc575711b6b8f2f866131a40d053e30e962e633b332acf7cd2c24843d83dsetuptools-69.2.0.tar.gz"
    sha256 "0ff4183f8f42cd8fa3acea16c45205521a4ef28f73c6391d8a25e92893134f2e"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
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
    url "https:files.pythonhosted.orgpackagesce21952a240de1c196c7e3fbcd4e559681f0419b1280c617db21157a0390717bsoupsieve-2.5.tar.gz"
    sha256 "5663d5a7b3bfaeee0bc4372e7fc48f9cff4940b3eec54a6451cc5299f1097690"
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
    url "https:files.pythonhosted.orgpackagesf6f3b827b3ab53b4e3d8513914586dcca61c355fa2ce8252dea4da56e67bf8f2typing_extensions-4.11.0.tar.gz"
    sha256 "83f085bd5ca59c80295fc2a82ab5dac679cbe02b9f33f7d83af68e241bea51b0"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages7a507fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  resource "websockets" do
    url "https:files.pythonhosted.orgpackagesd83b2ed38e52eed4cf277f9df5f0463a99199a04d9e29c9e227cfafa57bd3993websockets-11.0.3.tar.gz"
    sha256 "88fc51d9a26b10fc331be344f1781224a375b78488fc343620184e95a4b27016"
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

  # avoid runtime version check, see discussion in https:github.commtkennerlydunamaiissues80
  # upstream bug report, https:github.comblacklanternsecuritybbotissues1257
  patch :DATA

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}bbot -s --version")

    assert_predicate testpath".configbbotbbot.yml", :exist?
    assert_predicate testpath".configbbotsecrets.yml", :exist?
  end
end

__END__
diff --git apyproject.toml bpyproject.toml
index 4fc9831..7b8212f 100644
--- apyproject.toml
+++ bpyproject.toml
@@ -89,7 +89,7 @@ line-length = 119
 extend-exclude = "(test_step_1test_manager_*)"

 [tool.poetry-dynamic-versioning]
-enable = true
+enable = false
 metadata = false
 format-jinja = 'v1.1.6.1{% if branch == "dev" %}.{{ distance }}rc{% endif %}'