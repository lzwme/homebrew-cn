class Jupyterlab < Formula
  include Language::Python::Virtualenv

  desc "Interactive environments for writing and running code"
  homepage "https:jupyter.org"
  url "https:files.pythonhosted.orgpackages374bf56825c4715e213f8d7784a1185eac74820eb86f3e2bf3753c22e839222djupyterlab-4.3.1.tar.gz"
  sha256 "a4a338327556443521731d82f2a6ccf926df478914ca029616621704d47c3c65"
  license all_of: [
    "BSD-3-Clause",
    "MIT", # semver.py
  ]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5419bb5a0d2771b555280542c9c9642f5130bed981295f9bd5ad7d3b6935256a"
    sha256 cellar: :any,                 arm64_sonoma:  "da61d3f319a7f0d0252df921ed42bb660d1839c0b0d8d01e0db849392ca30470"
    sha256 cellar: :any,                 arm64_ventura: "32be9288de3afb93d82495b3e6663d9508f6eadb0fa55bae8f72bae086f14c27"
    sha256 cellar: :any,                 sonoma:        "1fa255a1ea15f121a8a813690387292c6c6af4706777556e1b0381de67265246"
    sha256 cellar: :any,                 ventura:       "6883a78cb795b6bde892d718aa1a8e46293eace3e4fb01a151394933c7cbd568"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e825f842dabe2aedb7c0c2bfbe52a861e31a0d72b5df8c4b66fdd438987a51b2"
  end

  depends_on "cmake" => :build # for ipykernel
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
    url "https:files.pythonhosted.orgpackages9f0945b9b7a6d4e45c6bcb5bf61d19e3ab87df68e0601fa8c5293de3542546ccanyio-4.6.2.post1.tar.gz"
    sha256 "4c8bc31ccdb51c7f7bd251f51c609e038d63e34219b44aa86e47576389880b4c"
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
    url "https:files.pythonhosted.orgpackagesfc0faafca9af9315aee06a89ffde799a10a582fe8de76c563ee80bbcdc08b3fbattrs-24.2.0.tar.gz"
    sha256 "5cfb1b9148b5b086569baec03f20d7b6bf3bcacc9a42bebf87ffaaca362f6346"
  end

  resource "babel" do
    url "https:files.pythonhosted.orgpackages2a74f1bc80f23eeba13393b7222b11d95ca3af2c1e28edca18af487137eefed9babel-2.16.0.tar.gz"
    sha256 "d1f3554ca26605fe173f3de0c65f750f5a42f924499bf134de6423582298e316"
  end

  resource "beautifulsoup4" do
    url "https:files.pythonhosted.orgpackagesb3ca824b1195773ce6166d388573fc106ce56d4a805bd7427b624e063596ec58beautifulsoup4-4.12.3.tar.gz"
    sha256 "74e3d1928edc070d21748185c46e3fb33490f22f52a3addee9aee0f4f7781051"
  end

  resource "bleach" do
    url "https:files.pythonhosted.orgpackages769a0e33f5054c54d349ea62c277191c020c2d6ef1d65ab2cb1993f91ec846d1bleach-6.2.0.tar.gz"
    sha256 "123e894118b8a599fd80d3ec1a6d4cc7ce4e5882b1317a7e1ba69b56e95f991f"
  end

  resource "cffi" do
    url "https:files.pythonhosted.orgpackagesfc97c783634659c2920c3fc70419e3af40972dbaf758daa229a7d6ea6135c90dcffi-1.17.1.tar.gz"
    sha256 "1c39c6016c32bc48dd54561950ebd6836e1670f2ae46128f67cf49e789c52824"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagesf24fe1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1echarset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
  end

  resource "comm" do
    url "https:files.pythonhosted.orgpackagese9a8fb783cb0abe2b5fded9f55e5703015cdf1c9c85b3669087c538dd15a6a86comm-0.2.2.tar.gz"
    sha256 "3fd7a84065306e07bea1773df6eb8282de51ba82f77c72f9c85716ab11fe980e"
  end

  resource "debugpy" do
    url "https:files.pythonhosted.orgpackagese45e7667b95c9d7ddb25c047143a3a47685f9be2a5d3d177a85a730b22dc6e5cdebugpy-1.8.8.zip"
    sha256 "e6355385db85cbd666be703a96ab7351bc9e6c61d694893206f8001e22aee091"
  end

  resource "decorator" do
    url "https:files.pythonhosted.orgpackages660c8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "defusedxml" do
    url "https:files.pythonhosted.orgpackages0fd5c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "executing" do
    url "https:files.pythonhosted.orgpackages8ce37d45f492c2c4a0e8e0fad57d081a7c8a0286cdd86372b070cca1ec0caa1eexecuting-2.1.0.tar.gz"
    sha256 "8ea27ddd260da8150fa5a708269c4a10e76161e2496ec3e587da9e3c0fe4b9ab"
  end

  resource "fastjsonschema" do
    url "https:files.pythonhosted.orgpackages033f3ad5e7be13b4b8b55f4477141885ab2364f65d5f6ad5f7a9daffd634d066fastjsonschema-2.20.0.tar.gz"
    sha256 "3d48fc5300ee96f5d116f10fe6f28d938e6008f59a6a025c2649475b87f76a23"
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
    url "https:files.pythonhosted.orgpackagese1477ec270a9567262ae3cb32dd420d2b53bf7aee769aca1f240eae0426b5bbchatchling-1.26.3.tar.gz"
    sha256 "b672a9c36a601a06c4e88a1abb1330639ee8e721e0535a37536e546a667efc7a"
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

  resource "ipykernel" do
    url "https:files.pythonhosted.orgpackagese95c67594cb0c7055dc50814b21731c22a601101ea3b1b50a9a1b090e11f5d0fipykernel-6.29.5.tar.gz"
    sha256 "f093a22c4a40f8828f8e330a9c297cb93dcab13bd9678ded6de8e5cf81c56215"
  end

  resource "ipython" do
    url "https:files.pythonhosted.orgpackages85e0a3f36dde97e12121106807d80485423ae4c5b27ce60d40d4ab0bab18a9dbipython-8.29.0.tar.gz"
    sha256 "40b60e15b22591450eef73e40a027cf77bd652e757523eebc5bd7c7c498290eb"
  end

  resource "isoduration" do
    url "https:files.pythonhosted.orgpackages7c1a3c8edc664e06e6bd06cce40c6b22da5f1429aa4224d0c590f3be21c91eadisoduration-20.11.0.tar.gz"
    sha256 "ac2f9015137935279eac671f94f89eb00584f940f5dc49462a0c4ee692ba1bd9"
  end

  resource "jedi" do
    url "https:files.pythonhosted.orgpackages723a79a912fbd4d8dd6fbb02bf69afd3bb72cf0c729bb3063c6f4498603db17ajedi-0.19.2.tar.gz"
    sha256 "4770dc3de41bde3966b02eb84fbcf557fb33cce26ad23da12c742fb50ecb11f0"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesed5539036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5djinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
  end

  resource "json5" do
    url "https:files.pythonhosted.orgpackages9e997cf7b9a08984203937bf8c9afd28ff64f733d0f6ccb677888f4bcd82af25json5-0.9.28.tar.gz"
    sha256 "1f82f36e615bc5b42f1bbd49dbc94b12563c56408c6ffa06414ea310890e9a6e"
  end

  resource "jsonpointer" do
    url "https:files.pythonhosted.orgpackages6a0aeebeb1fa92507ea94016a2a790b93c2ae41a7e18778f85471dc54475ed25jsonpointer-3.0.0.tar.gz"
    sha256 "2b2d729f2091522d61c3b31f82e11870f60b68f43fbc705cb76bf4b832af59ef"
  end

  resource "jsonschema" do
    url "https:files.pythonhosted.orgpackages382e03362ee4034a4c917f697890ccd4aec0800ccf9ded7f511971c75451deecjsonschema-4.23.0.tar.gz"
    sha256 "d71497fef26351a33265337fa77ffeb82423f3ea21283cd9467bb03999266bc4"
  end

  resource "jsonschema-specifications" do
    url "https:files.pythonhosted.orgpackages10db58f950c996c793472e336ff3655b13fbcf1e3b359dcf52dcf3ed3b52c352jsonschema_specifications-2024.10.1.tar.gz"
    sha256 "0f38b83639958ce1152d02a7f062902c41c8fd20d558b0c34344292d417ae272"
  end

  resource "jupyter-client" do
    url "https:files.pythonhosted.orgpackages7122bf9f12fdaeae18019a468b68952a60fe6dbab5d67cd2a103cac7659b41cajupyter_client-8.6.3.tar.gz"
    sha256 "35b3a0947c4a6e9d589eb97d7d4cd5e90f910ee73101611f01283732bd6d9419"
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
    url "https:files.pythonhosted.orgpackages8d537537a1aa558229bb0b1b178d814c9d68a9c697d3aecb808a1cb2646acf1fjupyter_events-0.10.0.tar.gz"
    sha256 "670b8229d3cc882ec782144ed22e0d29e1c2d639263f92ca8383e66682845e22"
  end

  resource "jupyter-lsp" do
    url "https:files.pythonhosted.orgpackages85b43200b0b09c12bc3b72d943d923323c398eff382d1dcc7c0dbc8b74630e40jupyter-lsp-2.2.5.tar.gz"
    sha256 "793147a05ad446f809fd53ef1cd19a9f5256fd0a2d6b7ce943a982cb4f545001"
  end

  resource "jupyter-server" do
    url "https:files.pythonhosted.orgpackages0c3488b47749c7fa9358e10eac356c4b97d94a91a67d5c935a73f69bc4a31118jupyter_server-2.14.2.tar.gz"
    sha256 "66095021aa9638ced276c248b1d81862e4c50f292d575920bbe960de1c56b12b"
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
    url "https:files.pythonhosted.orgpackages0ac9a883ce65eb27905ce77ace410d83587c82ea64dc85a48d1f7ed52bcfa68djupyterlab_server-2.27.3.tar.gz"
    sha256 "eb36caca59e74471988f0ae25c77945610b887f777255aa21f8065def9e51ed4"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackagesb2975d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "matplotlib-inline" do
    url "https:files.pythonhosted.orgpackages995ba36a337438a14116b16480db471ad061c36c3694df7c2084a0da7ba538b7matplotlib_inline-0.1.7.tar.gz"
    sha256 "8423b23ec666be3d16e16b60bdd8ac4e86e840ebd1dd11a30b9f117f2fa0ab90"
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
    url "https:files.pythonhosted.orgpackagesafe8ba521a033b21132008e520c28ceb818f9f092da5f0261e94e509401b29f9nbconvert-7.16.4.tar.gz"
    sha256 "86ca91ba266b0a448dc96fa6c5b9d98affabde2867b363258703536807f9f7f4"
  end

  resource "nbformat" do
    url "https:files.pythonhosted.orgpackages6dfd91545e604bc3dad7dca9ed03284086039b294c6b3d75c0d2fa45f9e9caf3nbformat-5.10.4.tar.gz"
    sha256 "322168b14f937a5d11362988ecac2a4952d3d8e3a2cbeb2319584631226d5b3a"
  end

  resource "nest-asyncio" do
    url "https:files.pythonhosted.orgpackages83f851569ac65d696c8ecbee95938f89d4abf00f47d58d48f6fbabfe8f0baefenest_asyncio-1.6.0.tar.gz"
    sha256 "6f172d5449aca15afd6c646851f4e31e02c598d553a667e38cafa997cfec55fe"
  end

  resource "notebook" do
    url "https:files.pythonhosted.orgpackages7d97369dd928d0561e7a8ae673156d2470664a83935320b068fa35b54d19f0bdnotebook-7.0.7.tar.gz"
    sha256 "3bcff00c17b3ac142ef5f436d50637d936b274cfa0b41f6ac0175363de9b4e09"
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
    url "https:files.pythonhosted.orgpackagesd06368dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106dapackaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "pandocfilters" do
    url "https:files.pythonhosted.orgpackages706f3dd4940bbe001c06a65f88e36bad298bc7a0de5036115639926b0c5c0458pandocfilters-1.5.1.tar.gz"
    sha256 "002b4a555ee4ebc03f8b66307e287fa492e4a77b4ea14d3f934328297bb4939e"
  end

  resource "parso" do
    url "https:files.pythonhosted.orgpackages669468e2e17afaa9169cf6412ab0f28623903be73d1b32e208d9e8e541bb086dparso-0.8.4.tar.gz"
    sha256 "eb3a7b58240fb99099a345571deecc0f9540ea5f4dd2fe14c2a99d6b281ab92d"
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
    url "https:files.pythonhosted.orgpackages13fc128cc9cb8f03208bdbf93d3aa862e16d376844a14f9a0ce5cf4507372de4platformdirs-4.3.6.tar.gz"
    sha256 "357fb2acbc885b0419afd3ce3ed34564c13c9b95c89360cd9563f73aa5e2b907"
  end

  resource "pluggy" do
    url "https:files.pythonhosted.orgpackages962d02d4312c973c6050a18b314a5ad0b3210edb65a906f868e31c111dede4a6pluggy-1.5.0.tar.gz"
    sha256 "2cffa88e94fdc978c4c574f15f9e59b7f4201d439195c3715ca9e2486f1d0cf1"
  end

  resource "prometheus-client" do
    url "https:files.pythonhosted.orgpackagese154a369868ed7a7f1ea5163030f4fc07d85d22d7a1d270560dab675188fb612prometheus_client-0.21.0.tar.gz"
    sha256 "96c83c606b71ff2b0a433c98889d275f51ffec6c5e267de37c7a2b5c9aa9233e"
  end

  resource "prompt-toolkit" do
    url "https:files.pythonhosted.orgpackages2d4ffeb5e137aff82f7c7f3248267b97451da3644f6cdc218edfe549fb354127prompt_toolkit-3.0.48.tar.gz"
    sha256 "d6623ab0477a80df74e646bdbc93621143f5caf104206aa29294d53de1a03d90"
  end

  resource "psutil" do
    url "https:files.pythonhosted.orgpackages26102a30b13c61e7cf937f4adf90710776b7918ed0a9c434e2c38224732af310psutil-6.1.0.tar.gz"
    sha256 "353815f59a7f64cdaca1c0307ee13558a0512f6db064e92fe833784f08539c7a"
  end

  resource "ptyprocess" do
    url "https:files.pythonhosted.orgpackages20e516ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4eptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "pure-eval" do
    url "https:files.pythonhosted.orgpackagescd050a34433a064256a578f1783a10da6df098ceaa4a57bbeaa96a6c0352786bpure_eval-0.2.3.tar.gz"
    sha256 "5f4e983f40564c576c7c8635ae88db5956bb2229d7e9237d03b3c0b0190eaf42"
  end

  resource "pycparser" do
    url "https:files.pythonhosted.orgpackages1db231537cf4b1ca988837256c910a668b553fceb8f069bedc4b1c826024b52cpycparser-2.22.tar.gz"
    sha256 "491c8be9c040f5390f5bf44a5b07752bd07f56edf992381b05c701439eec10f6"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages8e628336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
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
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "pyzmq" do
    url "https:files.pythonhosted.orgpackagesfd05bed626b9f7bb2322cdbbf7b4bd8f54b1b617b0d2ab2d3547d6e39428a48epyzmq-26.2.0.tar.gz"
    sha256 "070672c258581c8e4f640b5159297580a9974b026043bd4ab0470be9ed324f1f"
  end

  resource "referencing" do
    url "https:files.pythonhosted.orgpackages995b73ca1f8e72fff6fa52119dbd185f73a907b1989428917b24cff660129b6dreferencing-0.35.1.tar.gz"
    sha256 "25b42124a6c8b632a425174f24087783efb348a6f1e0008e63cd4466fedf703c"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
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
    url "https:files.pythonhosted.orgpackages2380afdf96daf9b27d61483ef05b38f282121db0e38f5fd4e89f40f5c86c2a4frpds_py-0.21.0.tar.gz"
    sha256 "ed6378c9d66d0de903763e7706383d60c33829581f0adff47b6535f1802fa6db"
  end

  resource "send2trash" do
    url "https:files.pythonhosted.orgpackagesfd3aaec9b02217bb79b87bbc1a21bc6abc51e3d5dcf65c30487ac96c0908c722Send2Trash-1.8.3.tar.gz"
    sha256 "b18e7a3966d99871aefeb00cfbcfdced55ce4871194810fc71f4aa484b953abf"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackagesc8db722a42ffdc226e950c4757b3da7b56ff5c090bb265dccd707f7b8a3c6feesetuptools-75.5.0.tar.gz"
    sha256 "5c4ccb41111392671f02bb5f8436dfc5a9a7185e80500531b133f5775c4163ef"
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
    url "https:files.pythonhosted.orgpackagesd7cefbaeed4f9fb8b2daa961f90591662df6a86c1abf25c548329a86920aedfbsoupsieve-2.6.tar.gz"
    sha256 "e2e68417777af359ec65daac1057404a3c8a5455bb8abc36f1a9866ab1a51abb"
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
    url "https:files.pythonhosted.orgpackages7afd7a5ee21fd08ff70d3d33a5781c255cbe779659bd03278feb98b19ee550f4tinycss2-1.4.0.tar.gz"
    sha256 "10c0972f6fc0fbee87c3edb76549357415e94548c1ae10ebccdea16fb404a9b7"
  end

  resource "tornado" do
    url "https:files.pythonhosted.orgpackagesee66398ac7167f1c7835406888a386f6d0d26ee5dbf197d8a571300be57662d3tornado-6.4.1.tar.gz"
    sha256 "92d3ab53183d8c50f8204a51e6f91d18a15d5ef261e84d452800d4ff6fc504e9"
  end

  resource "traitlets" do
    url "https:files.pythonhosted.orgpackageseb7972064e6a701c2183016abbbfedaba506d81e30e232a68c9f0d6f6fcd1574traitlets-5.14.3.tar.gz"
    sha256 "9ed0579d3502c94b4b3732ac120375cda96f923114522847de4b3bb98b96b6b7"
  end

  resource "trove-classifiers" do
    url "https:files.pythonhosted.orgpackages998592c2667cf221b37648041ce9319427f92fa76cbec634aad844e67e284706trove_classifiers-2024.10.21.16.tar.gz"
    sha256 "17cbd055d67d5e9d9de63293a8732943fabc21574e4c7b74edf112b4928cf5f3"
  end

  resource "types-python-dateutil" do
    url "https:files.pythonhosted.orgpackages31f8f6ee4c803a7beccffee21bb29a71573b39f7037c224843eff53e5308c16etypes-python-dateutil-2.9.0.20241003.tar.gz"
    sha256 "58cb85449b2a56d6684e41aeefb4c4280631246a0da1a719bdbe6f3fb0317446"
  end

  resource "uri-template" do
    url "https:files.pythonhosted.orgpackages31c70336f2bd0bcbada6ccef7aaa25e443c118a704f828a0620c6fa0207c1b64uri-template-1.3.0.tar.gz"
    sha256 "0e00f8eb65e18c7de20d595a14336e9f337ead580c70934141624b6d1ffdacc7"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesed6322ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages6c6353559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  resource "webcolors" do
    url "https:files.pythonhosted.orgpackages7b29061ec845fb58521848f3739e466efd8250b4b7b98c1b6c5bf4d40b419b7ewebcolors-24.11.1.tar.gz"
    sha256 "ecb3d768f32202af770477b8b65f318fa4f566c22948673a977b00d589dd80f6"
  end

  resource "webencodings" do
    url "https:files.pythonhosted.orgpackages0b02ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  resource "websocket-client" do
    url "https:files.pythonhosted.orgpackagese630fba0d96b4b5fbf5948ed3f4681f7da2f9f64512e1d303f94b4cc174c24a5websocket_client-1.8.0.tar.gz"
    sha256 "3239df9f44da632f96012472805d40a23281a991027ce11d2f45a6f24ac4c3da"
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
    rm_r(libexec"sharejupyterkernels")

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

  service do
    run [opt_bin"jupyter-lab"]
    keep_alive true
    log_path var"logjupyterlab.log"
    error_log_path var"logjupyterlab.log"
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
      set timeout 60
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