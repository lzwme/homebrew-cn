class Jupyterlab < Formula
  include Language::Python::Virtualenv

  desc "Interactive environments for writing and running code"
  homepage "https:jupyter.org"
  url "https:files.pythonhosted.orgpackagesa7566c5a78e860c6f09f91aca5ae5577dd6b68da9ac7596ac5877e627365e425jupyterlab-4.1.5.tar.gz"
  sha256 "c9ad75290cb10bfaff3624bf3fbb852319b4cce4c456613f8ebbaa98d03524db"
  license all_of: [
    "BSD-3-Clause",
    "MIT", # semver.py
  ]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "14bc02a5633b25cb8fbbc05c37a67269ed46a97f27f9e89d3e2112396a731457"
    sha256 cellar: :any,                 arm64_ventura:  "35fe46ec46de40bc0ebbec49f8a26b49e55a3ebd4508281c3b64926852194d89"
    sha256 cellar: :any,                 arm64_monterey: "7e1b841c20b6347028a4b80410865f6ea89492a4190bc14655221c01de9c4d3f"
    sha256 cellar: :any,                 sonoma:         "1bf981eb27b6fd800be2306bda04f5af62d3598703af29d61def8a356a658abb"
    sha256 cellar: :any,                 ventura:        "768ca945fda9f9434fca1039dfbfe9c60439482d1b28e8942b71cb8716aa6a6e"
    sha256 cellar: :any,                 monterey:       "60a83fa0dfdd31dc0c90f005b684e4b9c02b24e751619261ed21c6f6826e9efc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d440eb3d5291777c4da7ae7d62d4dcb59f9ef8033a49668d97d613f27b5be4c"
  end

  depends_on "rust" => :build # for rpds-py
  depends_on "certifi"
  depends_on "libyaml"
  depends_on "node"
  depends_on "pandoc"
  depends_on "python@3.12"
  depends_on "zeromq"

  uses_from_macos "expect" => :test
  uses_from_macos "libffi"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "anyio" do
    url "https:files.pythonhosted.orgpackagesdb4d3970183622f0330d3c23d9b8a5f52e365e50381fd484d08e3285104333d3anyio-4.3.0.tar.gz"
    sha256 "f75253795a87df48568485fd18cdd2a3fa5c4f7c5be8e5e36637733fce06fed6"
  end

  resource "appnope" do
    url "https:files.pythonhosted.orgpackages355d752690df9ef5b76e169e68d6a129fa6d08a7100ca7f754c89495db3c6019appnope-0.1.4.tar.gz"
    sha256 "1de3860566df9caf38f01f86f65e0e13e379af54f9e4bee1e66b48f2efffd1ee"
  end

  resource "argon2-cffi" do
    url "https:files.pythonhosted.orgpackages31fa57ec2c6d16ecd2ba0cf15f3c7d1c3c2e7b5fcb83555ff56d7ab10888ec8fargon2_cffi-23.1.0.tar.gz"
    sha256 "879c3e79a2729ce768ebb7d36d4609e3a78a4ca2ec3a9f12286ca057e3d0db08"
  end

  resource "argon2-cffi-bindings" do
    url "https:files.pythonhosted.orgpackagesb9e9184b8ccce6683b0aa2fbb7ba5683ea4b9c5763f1356347f1312c32e3c66eargon2-cffi-bindings-21.2.0.tar.gz"
    sha256 "bb89ceffa6c791807d1305ceb77dbfacc5aa499891d2c55661c6459651fc39e3"
  end

  resource "arrow" do
    url "https:files.pythonhosted.orgpackages2e000f6e8fcdb23ea632c866620cc872729ff43ed91d284c866b515c6342b173arrow-1.3.0.tar.gz"
    sha256 "d4540617648cb5f895730f1ad8c82a65f2dad0166f57b75f3ca54759c4d67a85"
  end

  resource "asttokens" do
    url "https:files.pythonhosted.orgpackages451df03bcb60c4a3212e15f99a56085d93093a497718adf828d050b9d675da81asttokens-2.4.1.tar.gz"
    sha256 "b03869718ba9a6eb027e134bfdf69f38a236d681c83c160d510768af11254ba0"
  end

  resource "async-lru" do
    url "https:files.pythonhosted.orgpackages80e22b4651eff771f6fd900d233e175ddc5e2be502c7eb62c0c42f975c6d36cdasync-lru-2.0.4.tar.gz"
    sha256 "b8a59a5df60805ff63220b2a0c5b5393da5521b113cd5465a44eb037d81a5627"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackagese3fcf800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650dattrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "babel" do
    url "https:files.pythonhosted.orgpackagese280cfbe44a9085d112e983282ee7ca4c00429bc4d1ce86ee5f4e60259ddff7fBabel-2.14.0.tar.gz"
    sha256 "6919867db036398ba21eb5c7a0f6b28ab8cbc3ae7a73a44ebe34ae74a4e7d363"
  end

  resource "beautifulsoup4" do
    url "https:files.pythonhosted.orgpackagesb3ca824b1195773ce6166d388573fc106ce56d4a805bd7427b624e063596ec58beautifulsoup4-4.12.3.tar.gz"
    sha256 "74e3d1928edc070d21748185c46e3fb33490f22f52a3addee9aee0f4f7781051"
  end

  resource "bleach" do
    url "https:files.pythonhosted.orgpackages6d1077f32b088738f40d4f5be801daa5f327879eadd4562f36a2b5ab975ae571bleach-6.1.0.tar.gz"
    sha256 "0a31f1837963c41d46bbf1331b8778e1308ea0791db03cc4e7357b97cf42a8fe"
  end

  resource "cffi" do
    url "https:files.pythonhosted.orgpackages68ce95b0bae7968c65473e1298efb042e10cafc7bafc14d9e4f154008241c91dcffi-1.16.0.tar.gz"
    sha256 "bcb3ef43e58665bbda2fb198698fcae6776483e0c4a631aa5647806c25e02cc0"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "comm" do
    url "https:files.pythonhosted.orgpackagese9a8fb783cb0abe2b5fded9f55e5703015cdf1c9c85b3669087c538dd15a6a86comm-0.2.2.tar.gz"
    sha256 "3fd7a84065306e07bea1773df6eb8282de51ba82f77c72f9c85716ab11fe980e"
  end

  resource "debugpy" do
    url "https:files.pythonhosted.orgpackages5ec7a18e15ed2e53f86de2e1c4162a54ddf1c4f4cee5ca40270c14725ccdd8ffdebugpy-1.8.1.zip"
    sha256 "f696d6be15be87aef621917585f9bb94b1dc9e8aced570db1b8a6fc14e8f9b42"
  end

  resource "decorator" do
    url "https:files.pythonhosted.orgpackages660c8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "defusedxml" do
    url "https:files.pythonhosted.orgpackages0fd5c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "editables" do
    url "https:files.pythonhosted.orgpackages374a986d35164e2033ddfb44515168a281a7986e260d344cf369c3f52d4c3275editables-0.5.tar.gz"
    sha256 "309627d9b5c4adc0e668d8c6fa7bac1ba7c8c5d415c2d27f60f081f8e80d1de2"
  end

  resource "executing" do
    url "https:files.pythonhosted.orgpackages084185d2d28466fca93737592b7f3cc456d1cfd6bcd401beceeba17e8e792b50executing-2.0.1.tar.gz"
    sha256 "35afe2ce3affba8ee97f2d69927fa823b08b472b7b994e36a52a964b93d16147"
  end

  resource "fastjsonschema" do
    url "https:files.pythonhosted.orgpackagesba7fcedf77ace50aa60c566deaca9066750f06e1fcf6ad24f254d255bb976dd6fastjsonschema-2.19.1.tar.gz"
    sha256 "e3126a94bdc4623d3de4485f8d468a12f02a67921315ddc87836d6e456dc789d"
  end

  resource "fqdn" do
    url "https:files.pythonhosted.orgpackages303ea80a8c077fd798951169626cde3e239adeba7dab75deb3555716415bd9b0fqdn-1.5.1.tar.gz"
    sha256 "105ed3677e767fb5ca086a0c1f4bb66ebc3c100be518f0e0d755d9eae164d89f"
  end

  resource "h11" do
    url "https:files.pythonhosted.orgpackagesf5383af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "hatch-jupyter-builder" do
    url "https:files.pythonhosted.orgpackages5bf68c8b353e7c6476ca28caea0408b0a3778d8849cda16f3e8e8f3145162daehatch_jupyter_builder-0.9.1.tar.gz"
    sha256 "79278198d124c646b799c5e8dca8504aed9dcaaa88d071a09eb0b5c2009a58ad"
  end

  resource "hatch-nodejs-version" do
    url "https:files.pythonhosted.orgpackagesafb6c9406cfa9edf740c6b3de6173408a159228eac0cee80eead4a5b9cc88848hatch_nodejs_version-0.3.2.tar.gz"
    sha256 "8a7828d817b71e50bbbbb01c9bfc0b329657b7900c56846489b9c958de15b54c"
  end

  resource "hatchling" do
    url "https:files.pythonhosted.orgpackagesd8a17dd1caa87c0b15c04c6291e25112e5d082cce02ee87f221a8be1d594f857hatchling-1.21.1.tar.gz"
    sha256 "bba440453a224e7d4478457fa2e8d8c3633765bafa02975a6b53b9bf917980bc"
  end

  resource "httpcore" do
    url "https:files.pythonhosted.orgpackages039d2055e6b65592d3a485a1141761ba7047674bbe085cebac0988b30e93c9e6httpcore-1.0.4.tar.gz"
    sha256 "cb2839ccfcba0d2d3c1131d3c3e26dfc327326fbe7a5dc0dbfe9f6c9151bb022"
  end

  resource "httpx" do
    url "https:files.pythonhosted.orgpackages5c2d3da5bdf4408b8b2800061c339f240c1802f2e82d55e50bd39c5a881f47f0httpx-0.27.0.tar.gz"
    sha256 "a0cb88a46f32dc874e04ee956e4c2764aba2aa228f650b06788ba6bda2962ab5"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesbf3fea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "ipykernel" do
    url "https:files.pythonhosted.orgpackagesab37ddef2ece768f4d457d8f7ac067d2857ff39f7e74f61568c6e9d7f6da79c3ipykernel-6.29.3.tar.gz"
    sha256 "e14c250d1f9ea3989490225cc1a542781b095a18a19447fcf2b5eaf7d0ac5bd2"
  end

  resource "ipython" do
    url "https:files.pythonhosted.orgpackages43ac82acd7bf004bc916f45cdb01622f3ef88199465ca6a7ba0bcf22db27226fipython-8.22.2.tar.gz"
    sha256 "2dcaad9049f9056f1fef63514f176c7d41f930daa78d05b82a176202818f2c14"
  end

  resource "isoduration" do
    url "https:files.pythonhosted.orgpackages7c1a3c8edc664e06e6bd06cce40c6b22da5f1429aa4224d0c590f3be21c91eadisoduration-20.11.0.tar.gz"
    sha256 "ac2f9015137935279eac671f94f89eb00584f940f5dc49462a0c4ee692ba1bd9"
  end

  resource "jedi" do
    url "https:files.pythonhosted.orgpackagesd69999b493cec4bf43176b678de30f81ed003fd6a647a301b9c927280c600f0ajedi-0.19.1.tar.gz"
    sha256 "cf0496f3651bc65d7174ac1b7d043eff454892c708a87d1b683e57b569927ffd"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesb25e3a21abf3cd467d7876045335e681d276ac32492febe6d98ad89562d1a7e1Jinja2-3.1.3.tar.gz"
    sha256 "ac8bd6544d4bb2c9792bf3a159e80bba8fda7f07e81bc3aed565432d5925ba90"
  end

  resource "json5" do
    url "https:files.pythonhosted.orgpackages4c070aca332ebcb8aac37716ae83b6ef8aeb9370f7821eaa6409cbee0c1e3853json5-0.9.22.tar.gz"
    sha256 "b729bde7650b2196a35903a597d2b704b8fdf8648bfb67368cfb79f1174a17bd"
  end

  resource "jsonpointer" do
    url "https:files.pythonhosted.orgpackages8f5e67d3ab449818b629a0ffe554bb7eb5c030a71f7af5d80fbf670d7ebe62bcjsonpointer-2.4.tar.gz"
    sha256 "585cee82b70211fa9e6043b7bb89db6e1aa49524340dde8ad6b63206ea689d88"
  end

  resource "jsonschema" do
    url "https:files.pythonhosted.orgpackages4dc53f6165d3df419ea7b0990b3abed4ff348946a826caf0e7c990b65ff7b9bejsonschema-4.21.1.tar.gz"
    sha256 "85727c00279f5fa6bedbe6238d2aa6403bedd8b4864ab11207d07df3cc1b2ee5"
  end

  resource "jsonschema-specifications" do
    url "https:files.pythonhosted.orgpackagesf8b9cc0cc592e7c195fb8a650c1d5990b10175cf13b4c97465c72ec841de9e4bjsonschema_specifications-2023.12.1.tar.gz"
    sha256 "48a76787b3e70f5ed53f1160d2b81f586e4ca6d1548c5de7085d1682674764cc"
  end

  resource "jupyter-client" do
    url "https:files.pythonhosted.orgpackagescd5af4583ba60733b5a1cb1379acdf7c710fb1fb4d9df936a740f8cadf25d853jupyter_client-8.6.1.tar.gz"
    sha256 "e842515e2bab8e19186d89fdfea7abd15e39dd581f94e399f00e2af5a1652d3f"
  end

  resource "jupyter-console" do
    url "https:files.pythonhosted.orgpackagesbd2de2fd31e2fc41c14e2bcb6c976ab732597e907523f6b2420305f9fc7fdbdbjupyter_console-6.6.3.tar.gz"
    sha256 "566a4bf31c87adbfadf22cdf846e3069b59a71ed5da71d6ba4d8aaad14a53539"
  end

  resource "jupyter-core" do
    url "https:files.pythonhosted.orgpackages0011b56381fa6c3f4cc5d2cf54a7dbf98ad9aa0b339ef7a601d6053538b079a7jupyter_core-5.7.2.tar.gz"
    sha256 "aa5f8d32bbf6b431ac830496da7392035d6f61b4f54872f15c4bd2a9c3f536d9"
  end

  resource "jupyter-events" do
    url "https:files.pythonhosted.orgpackages792f552806e72d8ca94a4ee6645d3fe7208cba0d3394c74c7b178fb4eac29fa7jupyter_events-0.9.1.tar.gz"
    sha256 "a52e86f59eb317ee71ff2d7500c94b963b8a24f0b7a1517e2e653e24258e15c7"
  end

  resource "jupyter-lsp" do
    url "https:files.pythonhosted.orgpackages8f34c7394087933293e28d6330e665272070037876ceb94e4d84a7464da565e9jupyter-lsp-2.2.4.tar.gz"
    sha256 "5e50033149344065348e688608f3c6d654ef06d9856b67655bd7b6bac9ee2d59"
  end

  resource "jupyter-server" do
    url "https:files.pythonhosted.orgpackagesffe07fc708fe05d7071fc13c93e02805594aa468a46dfa19fdf04d5f1712ac2ajupyter_server-2.13.0.tar.gz"
    sha256 "c80bfb049ea20053c3d9641c2add4848b38073bf79f1729cea1faed32fc1c78e"
  end

  resource "jupyter-server-terminals" do
    url "https:files.pythonhosted.orgpackagesfcd5562469734f476159e99a55426d697cbf8e7eb5efe89fb0e0b4f83a3d3459jupyter_server_terminals-0.5.3.tar.gz"
    sha256 "5ae0295167220e9ace0edcfdb212afd2b01ee8d179fe6f23c899590e9b8a5269"
  end

  resource "jupyterlab-pygments" do
    url "https:files.pythonhosted.orgpackages90519187be60d989df97f5f0aba133fa54e7300f17616e065d1ada7d7646b6d6jupyterlab_pygments-0.3.0.tar.gz"
    sha256 "721aca4d9029252b11cfa9d185e5b5af4d54772bb8072f9b7036f4170054d35d"
  end

  resource "jupyterlab-server" do
    url "https:files.pythonhosted.orgpackagesd6a07660dd15fbb5638b6014d315d37a6c2a0164a2265cc0f51ca73bcba10c2djupyterlab_server-2.25.4.tar.gz"
    sha256 "2098198e1e82e0db982440f9b5136175d73bea2cd42a6480aa6fd502cb23c4f9"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackages875baae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02dMarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "matplotlib-inline" do
    url "https:files.pythonhosted.orgpackagesd9503af8c0362f26108e54d58c7f38784a3bdae6b9a450bab48ee8482d737f44matplotlib-inline-0.1.6.tar.gz"
    sha256 "f887e5f10ba98e8d2b150ddcf4702c1e5f8b3a20005eb0f74bfdbd360ee6f304"
  end

  resource "mistune" do
    url "https:files.pythonhosted.orgpackagesefc8f0173fe3bf85fd891aee2e7bcd8207dfe26c2c683d727c5a6cc3aec7b628mistune-3.0.2.tar.gz"
    sha256 "fc7f93ded930c92394ef2cb6f04a8aabab4117a91449e72dcc8dfa646a508be8"
  end

  resource "nbclient" do
    url "https:files.pythonhosted.orgpackagese2d239bc36604f24bccd44d374ac34769bc58c53a1da5acd1e83f0165aa4940enbclient-0.10.0.tar.gz"
    sha256 "4b3f1b7dba531e498449c4db4f53da339c91d449dc11e9af3a43b4eb5c5abb09"
  end

  resource "nbconvert" do
    url "https:files.pythonhosted.orgpackages5a58b31e8a37e8c43937e536d72abd1f3271ca3195a206088e8180fa1c437789nbconvert-7.16.2.tar.gz"
    sha256 "8310edd41e1c43947e4ecf16614c61469ebc024898eb808cce0999860fc9fb16"
  end

  resource "nbformat" do
    url "https:files.pythonhosted.orgpackages9e73bcd3a88b322e813443758295701e0814c72a79f95905e1040b7db8f473benbformat-5.10.2.tar.gz"
    sha256 "c535b20a0d4310167bf4d12ad31eccfb0dc61e6392d6f8c570ab5b45a06a49a3"
  end

  resource "nest-asyncio" do
    url "https:files.pythonhosted.orgpackages83f851569ac65d696c8ecbee95938f89d4abf00f47d58d48f6fbabfe8f0baefenest_asyncio-1.6.0.tar.gz"
    sha256 "6f172d5449aca15afd6c646851f4e31e02c598d553a667e38cafa997cfec55fe"
  end

  resource "notebook" do
    url "https:files.pythonhosted.orgpackages866b5c7878a717e90716a69628a4f1b1c198f422434c2499d5110b71ae4d9048notebook-7.1.1.tar.gz"
    sha256 "818e7420fa21f402e726afb9f02df7f3c10f294c02e383ed19852866c316108b"
  end

  resource "notebook-shim" do
    url "https:files.pythonhosted.orgpackages54d292fa3243712b9a3e8bafaf60aac366da1cada3639ca767ff4b5b3654ec28notebook_shim-0.2.4.tar.gz"
    sha256 "b4b2cfa1b65d98307ca24361f5b30fe785b53c3fd07b7a47e89acb5e6ac638cb"
  end

  resource "overrides" do
    url "https:files.pythonhosted.orgpackages3686b585f53236dec60aba864e050778b25045f857e17f6e5ea0ae95fe80edd2overrides-7.7.0.tar.gz"
    sha256 "55158fa3d93b98cc75299b1e67078ad9003ca27945c76162c1c0766d6f91820a"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackageseeb5b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4dpackaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "pandocfilters" do
    url "https:files.pythonhosted.orgpackages706f3dd4940bbe001c06a65f88e36bad298bc7a0de5036115639926b0c5c0458pandocfilters-1.5.1.tar.gz"
    sha256 "002b4a555ee4ebc03f8b66307e287fa492e4a77b4ea14d3f934328297bb4939e"
  end

  resource "parso" do
    url "https:files.pythonhosted.orgpackagesa20e41f0cca4b85a6ea74d66d2226a7cda8e41206a624f5b330b958ef48e2e52parso-0.8.3.tar.gz"
    sha256 "8c07be290bb59f03588915921e29e8a50002acaf2cdc5fa0e0114f91709fafa0"
  end

  resource "pathspec" do
    url "https:files.pythonhosted.orgpackagescabcf35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbfpathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "pexpect" do
    url "https:files.pythonhosted.orgpackages4292cc564bf6381ff43ce1f4d06852fc19a2f11d180f23dc32d9588bee2f149dpexpect-4.9.0.tar.gz"
    sha256 "ee7d41123f3c9911050ea2c2dac107568dc43b2d3b0c7557a33212c398ead30f"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackages96dcc1d911bf5bb0fdc58cc05010e9f3efe3b67970cef779ba7fbc3183b987a8platformdirs-4.2.0.tar.gz"
    sha256 "ef0cc731df711022c174543cb70a9b5bd22e5a9337c8624ef2c2ceb8ddad8768"
  end

  resource "pluggy" do
    url "https:files.pythonhosted.orgpackages54c643f9d44d92aed815e781ca25ba8c174257e27253a94630d21be8725a2b59pluggy-1.4.0.tar.gz"
    sha256 "8c85c2876142a764e5b7548e7d9a0e0ddb46f5185161049a79b7e974454223be"
  end

  resource "prometheus-client" do
    url "https:files.pythonhosted.orgpackages3d393be07741a33356127c4fe633768ee450422c1231c6d34b951fee1458308dprometheus_client-0.20.0.tar.gz"
    sha256 "287629d00b147a32dcb2be0b9df905da599b2d82f80377083ec8463309a4bb89"
  end

  resource "prompt-toolkit" do
    url "https:files.pythonhosted.orgpackagesccc625b6a3d5cd295304de1e32c9edbcf319a52e965b339629d37d42bb7126caprompt_toolkit-3.0.43.tar.gz"
    sha256 "3527b7af26106cbc65a040bcc84839a3566ec1b051bb0bfe953631e704b0ff7d"
  end

  resource "psutil" do
    url "https:files.pythonhosted.orgpackages90c76dc0a455d111f68ee43f27793971cf03fe29b6ef972042549db29eec39a2psutil-5.9.8.tar.gz"
    sha256 "6be126e3225486dff286a8fb9a06246a5253f4c7c53b475ea5f5ac934e64194c"
  end

  resource "ptyprocess" do
    url "https:files.pythonhosted.orgpackages20e516ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4eptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "pure-eval" do
    url "https:files.pythonhosted.orgpackages975a0bc937c25d3ce4e0a74335222aee05455d6afa2888032185f8ab50cdf6fdpure_eval-0.2.2.tar.gz"
    sha256 "2b45320af6dfaa1750f543d714b6d1c520a1688dec6fd24d339063ce0aaa9ac3"
  end

  resource "pycparser" do
    url "https:files.pythonhosted.orgpackages5e0b95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46depycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages55598bccf4157baf25e4aa5a0bb7fa3ba8600907de105ebc22b0c78cfbf6f565pygments-2.17.2.tar.gz"
    sha256 "da46cec9fd2de5be3a8a784f434e4c4ab670b4ff54d605c4c2717e9d49c4c367"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-json-logger" do
    url "https:files.pythonhosted.orgpackages4fda95963cebfc578dabd323d7263958dfb68898617912bb09327dd30e9c8d13python-json-logger-2.0.7.tar.gz"
    sha256 "23e7ec02d34237c5aa1e29a070193a4ea87583bb4e7f8fd06d3de8264c4b2e1c"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackagescde5af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "pyzmq" do
    url "https:files.pythonhosted.orgpackages3a331a3683fc9a4bd64d8ccc0290da75c8f042184a1a49c146d28398414d3341pyzmq-25.1.2.tar.gz"
    sha256 "93f1aa311e8bb912e34f004cf186407a4e90eec4f0ecc0efd26056bf7eda0226"
  end

  resource "referencing" do
    url "https:files.pythonhosted.orgpackages21c5b99dd501aa72b30a5a87d488d7aa76ec05bdf0e2c7439bc82deb9448dd9areferencing-0.33.0.tar.gz"
    sha256 "c775fedf74bc0f9189c2a3be1c12fd03e8c23f4d371dce795df44e06c5b412f7"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "rfc3339-validator" do
    url "https:files.pythonhosted.orgpackages28eaa9387748e2d111c3c2b275ba970b735e04e15cdb1eb30693b6b5708c4dbdrfc3339_validator-0.1.4.tar.gz"
    sha256 "138a2abdf93304ad60530167e51d2dfb9549521a836871b88d7f4695d0022f6b"
  end

  resource "rfc3986-validator" do
    url "https:files.pythonhosted.orgpackagesda88f270de456dd7d11dcc808abfa291ecdd3f45ff44e3b549ffa01b126464d0rfc3986_validator-0.1.1.tar.gz"
    sha256 "3d44bde7921b3b9ec3ae4e3adca370438eccebc676456449b145d533b240d055"
  end

  resource "rpds-py" do
    url "https:files.pythonhosted.orgpackages55bace7b9f0fc5323f20ffdf85f682e51bee8dc03e9b54503939ebb63d1d0d5erpds_py-0.18.0.tar.gz"
    sha256 "42821446ee7a76f5d9f71f9e33a4fb2ffd724bb3e7f93386150b61a43115788d"
  end

  resource "send2trash" do
    url "https:files.pythonhosted.orgpackages4ad2d4b4d8b1564752b4e593c6d007426172b6574df5a7c07322feba010f5551Send2Trash-1.8.2.tar.gz"
    sha256 "c132d59fa44b9ca2b1699af5c86f57ce9f4c5eb56629d5d55fbb7a35f84e2312"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "sniffio" do
    url "https:files.pythonhosted.orgpackagesa287a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbdsniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "soupsieve" do
    url "https:files.pythonhosted.orgpackagesce21952a240de1c196c7e3fbcd4e559681f0419b1280c617db21157a0390717bsoupsieve-2.5.tar.gz"
    sha256 "5663d5a7b3bfaeee0bc4372e7fc48f9cff4940b3eec54a6451cc5299f1097690"
  end

  resource "stack-data" do
    url "https:files.pythonhosted.orgpackages28e355dcc2cfbc3ca9c29519eb6884dd1415ecb53b0e934862d3559ddcb7e20bstack_data-0.6.3.tar.gz"
    sha256 "836a778de4fec4dcd1dcd89ed8abff8a221f58308462e1c4aa2a3cf30148f0b9"
  end

  resource "terminado" do
    url "https:files.pythonhosted.orgpackages8a11965c6fd8e5cc254f1fe142d547387da17a8ebfd75a3455f637c663fb38a0terminado-0.18.1.tar.gz"
    sha256 "de09f2c4b85de4765f7714688fff57d3e75bad1f909b589fde880460c753fd2e"
  end

  resource "tinycss2" do
    url "https:files.pythonhosted.orgpackages75be24179dfaa1d742c9365cbd0e3f0edc5d3aa3abad415a2327c5a6ff8ca077tinycss2-1.2.1.tar.gz"
    sha256 "8cff3a8f066c2ec677c06dbc7b45619804a6938478d9d73c284b29d14ecb0627"
  end

  resource "tornado" do
    url "https:files.pythonhosted.orgpackagesbda2ea124343e3b8dd7712561fe56c4f92eda26865f5e1040b289203729186f2tornado-6.4.tar.gz"
    sha256 "72291fa6e6bc84e626589f1c29d90a5a6d593ef5ae68052ee2ef000dfd273dee"
  end

  resource "traitlets" do
    url "https:files.pythonhosted.orgpackages4f97d957b3a5f6da825cbbb6a02e584bcab769ea2c2a9ad67a9cc25b4bbafb30traitlets-5.14.2.tar.gz"
    sha256 "8cdd83c040dab7d1dee822678e5f5d100b514f7b72b01615b26fc5718916fdf9"
  end

  resource "trove-classifiers" do
    url "https:files.pythonhosted.orgpackages1311e13906315b498cb8f5ce5a7ff39fc35941e8291e914158157937fd1c095dtrove-classifiers-2024.3.3.tar.gz"
    sha256 "df7edff9c67ff86b733628998330b180e81d125b1e096536d83ac0fd79673fdc"
  end

  resource "types-python-dateutil" do
    url "https:files.pythonhosted.orgpackagesfb90e37d402a07f5a93791fc2837ee14b6947989aed6dc7895c420eb93354aeatypes-python-dateutil-2.8.19.20240311.tar.gz"
    sha256 "51178227bbd4cbec35dc9adffbf59d832f20e09842d7dcb8c73b169b8780b7cb"
  end

  resource "uri-template" do
    url "https:files.pythonhosted.orgpackages31c70336f2bd0bcbada6ccef7aaa25e443c118a704f828a0620c6fa0207c1b64uri-template-1.3.0.tar.gz"
    sha256 "0e00f8eb65e18c7de20d595a14336e9f337ead580c70934141624b6d1ffdacc7"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages7a507fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages6c6353559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  resource "webcolors" do
    url "https:files.pythonhosted.orgpackagesa1fbf95560c6a5d4469d9c49e24cf1b5d4d21ffab5608251c6020a965fb7791cwebcolors-1.13.tar.gz"
    sha256 "c225b674c83fa923be93d235330ce0300373d02885cef23238813b0d5668304a"
  end

  resource "webencodings" do
    url "https:files.pythonhosted.orgpackages0b02ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  resource "websocket-client" do
    url "https:files.pythonhosted.orgpackages20072a94288afc0f6c9434d6709c5320ee21eaedb2f463ede25ed9cf6feff330websocket-client-1.7.0.tar.gz"
    sha256 "10e511ea3a8c744631d3bd77e61eb17ed09304c413ad42cf6ddfa4c7787e8fe6"
  end

  def python3
    "python3.12"
  end

  def install
    venv = virtualenv_create(libexec, python3)
    ENV["JUPYTER_PATH"] = etc"jupyter"

    # install packages into virtualenv and link all jupyter extensions
    skipped = %w[hatch-jupyter-builder hatch-nodejs-version jupyterlab-pygments notebook]
    venv.pip_install resources.reject { |r| skipped.include? r.name }
    venv.pip_install_and_link buildpath
    bin.install_symlink (libexec"bin").glob("jupyter*")

    # These resources require `jupyterlab` to build, causing a build loop
    # with pip's --no-binary. They need `jlpm` in PATH, so we need to add it.
    # https:github.comjupyterlabjupyterlab_pygmentsissues23
    ENV.prepend_path "PATH", bin
    skipped.each do |r|
      venv.pip_install(resource(r), build_isolation: false)
    end

    # remove bundled kernel
    (libexec"sharejupyterkernels").rmtree

    # install completion
    resource("jupyter-core").stage do
      bash_completion.install "examplesjupyter-completion.bash" => "jupyter"
      zsh_completion.install "examplescompletions-zsh" => "_jupyter"
    end
  end

  def caveats
    <<~EOS
      Additional kernels can be installed into the shared jupyter directory
        #{etc}jupyter
    EOS
  end

  test do
    system bin"jupyter-console --help"
    assert_match python3, shell_output("#{bin}jupyter kernelspec list")

    (testpath"console.exp").write <<~EOS
      spawn #{bin}jupyter-console
      expect -timeout 60 "In "
      send "exit\r"
    EOS
    assert_match "Jupyter console", shell_output("expect -f console.exp")

    (testpath"notebook.exp").write <<~EOS
      spawn #{bin}jupyter notebook --no-browser
      expect "ServerApp"
    EOS
    assert_match "ServerApp", shell_output("expect -f notebook.exp")

    (testpath"nbconvert.ipynb").write <<~EOS
      {
        "cells": []
      }
    EOS
    system bin"jupyter-nbconvert", "nbconvert.ipynb", "--to", "html"
    assert_predicate testpath"nbconvert.html", :exist?, "Failed to export HTML"

    assert_match "-F _jupyter",
      shell_output("bash -c \"source #{bash_completion}jupyter && complete -p jupyter\"")

    # Ensure that jupyter can load the jupyter lab package.
    assert_match(^jupyterlab *: #{version}$,
      shell_output(bin"jupyter --version"))

    # Ensure that jupyter-lab binary was installed by pip.
    assert_equal version.to_s,
      shell_output(bin"jupyter-lab --version").strip

    port = free_port
    fork { exec "#{bin}jupyter-lab", "-y", "--port=#{port}", "--no-browser", "--ip=127.0.0.1", "--LabApp.token=''" }
    sleep 15
    assert_match "<title>JupyterLab<title>",
      shell_output("curl --silent --fail http:localhost:#{port}lab")
  end
end