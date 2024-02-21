class Jupyterlab < Formula
  include Language::Python::Virtualenv

  desc "Interactive environments for writing and running code"
  homepage "https:jupyter.org"
  url "https:files.pythonhosted.orgpackages73db7a5191cf9acbead0afca11aaebf63f453d25e54b52e9db44a842ed8b7bfbjupyterlab-4.1.2.tar.gz"
  sha256 "5d6348b3ed4085181499f621b7dfb6eb0b1f57f3586857aadfc8e3bf4c4885f9"
  license all_of: [
    "BSD-3-Clause",
    "MIT", # semver.py
  ]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "958ab23e232df99b25b285f93f5fedbdb32ac3503cf6af1712e1eeaede0d1e74"
    sha256 cellar: :any,                 arm64_ventura:  "1486dbb88ff8a9799bd157e82c5f8d7615f9290e5ccbc7d20210e3644eb981b1"
    sha256 cellar: :any,                 arm64_monterey: "c6e1dfa2fe74d5f8f9550227ad90c175417250f4e260f2527bc84172a4f441a1"
    sha256 cellar: :any,                 sonoma:         "def699222e4cb5a14247e57ec0e8ac6622fa986ca4df28e4a4a2001c097c7175"
    sha256 cellar: :any,                 ventura:        "0d8ce2b399d011cba3f7cd3d7114242b7f04a9e3e9f19c666b05885dec0b8cc7"
    sha256 cellar: :any,                 monterey:       "257b0389d93ca789863f0122f509800cb4b04622218a719270601d3e1b2e2acf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb3fa1b3bfef63744b21beaa6f76a50e0fa185c4f3f2f1b089718d7fff8dd7fe"
  end

  depends_on "python-hatchling" => :build
  depends_on "rust" => :build # for rpds-py
  depends_on "cffi"
  depends_on "ipython"
  depends_on "node"
  depends_on "pandoc"
  depends_on "pycparser"
  depends_on "pygments"
  depends_on "python-certifi"
  depends_on "python-dateutil"
  depends_on "python-jinja"
  depends_on "python-lsp-server"
  depends_on "python-markupsafe"
  depends_on "python-packaging"
  depends_on "python-psutil"
  depends_on "python-requests"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"
  depends_on "zeromq"

  uses_from_macos "expect" => :test
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

  resource "comm" do
    url "https:files.pythonhosted.orgpackagesb940386982b9f3e6b3126c75f6e7939de40f3eb0f5d4f5bf884ba8123454eb3ecomm-0.2.1.tar.gz"
    sha256 "0bc91edae1344d39d3661dcbc36937181fdaddb304790458f8b044dbc064b89a"
  end

  resource "debugpy" do
    url "https:files.pythonhosted.orgpackages5ec7a18e15ed2e53f86de2e1c4162a54ddf1c4f4cee5ca40270c14725ccdd8ffdebugpy-1.8.1.zip"
    sha256 "f696d6be15be87aef621917585f9bb94b1dc9e8aced570db1b8a6fc14e8f9b42"
  end

  resource "defusedxml" do
    url "https:files.pythonhosted.orgpackages0fd5c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
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
    url "https:files.pythonhosted.orgpackagesb1b23c304707d4d3c30b2c87f1b8f8b2eb4a682662fea13bd5ab8f16c4c0eb0bhatch_jupyter_builder-0.8.3.tar.gz"
    sha256 "0dbd14a8aef6636764f88a8fd1fcc9a91921e5c50356e6aab251782f264ae960"
  end

  resource "hatch-nodejs-version" do
    url "https:files.pythonhosted.orgpackagesafb6c9406cfa9edf740c6b3de6173408a159228eac0cee80eead4a5b9cc88848hatch_nodejs_version-0.3.2.tar.gz"
    sha256 "8a7828d817b71e50bbbbb01c9bfc0b329657b7900c56846489b9c958de15b54c"
  end

  resource "httpcore" do
    url "https:files.pythonhosted.orgpackages94f147528a2f465b09c71caad95f5de1d7225e438cf3d1068d278362a4a6bc6ahttpcore-1.0.3.tar.gz"
    sha256 "5c0f9546ad17dac4d0772b0808856eb616eb8b48ce94f49ed819fd6982a8a544"
  end

  resource "httpx" do
    url "https:files.pythonhosted.orgpackagesbd262dc654950920f499bd062a211071925533f821ccdca04fa0c2fd914d5d06httpx-0.26.0.tar.gz"
    sha256 "451b55c30d5185ea6b23c2c793abf9bb237d2a7dfb901ced6ff69ad37ec1dfaf"
  end

  resource "ipykernel" do
    url "https:files.pythonhosted.orgpackages87e46f1b4ab7d7fb9268d67a6c7c4520a7d76a5bbafd7abb716ed43b006153e0ipykernel-6.29.2.tar.gz"
    sha256 "3bade28004e3ff624ed57974948116670604ac5f676d12339693f3142176d3f0"
  end

  resource "isoduration" do
    url "https:files.pythonhosted.orgpackages7c1a3c8edc664e06e6bd06cce40c6b22da5f1429aa4224d0c590f3be21c91eadisoduration-20.11.0.tar.gz"
    sha256 "ac2f9015137935279eac671f94f89eb00584f940f5dc49462a0c4ee692ba1bd9"
  end

  resource "json5" do
    url "https:files.pythonhosted.orgpackages9296ca78f50cffb5fd1995edea469b6c79d9420c8aaeaf7f71f58c823e4f9651json5-0.9.17.tar.gz"
    sha256 "717d99d657fa71b7094877b1d921b1cce40ab444389f6d770302563bb7dfd9ae"
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
    url "https:files.pythonhosted.orgpackages71044418fca04fd65a26771113a0a46220a1a54a6d6bcc6fae4ad6b69eb27dd5jupyter_client-8.6.0.tar.gz"
    sha256 "0642244bb83b4764ae60d07e010e15f0e2d275ec4e918a8f7b80fbbef3ca60c7"
  end

  resource "jupyter-console" do
    url "https:files.pythonhosted.orgpackagesbd2de2fd31e2fc41c14e2bcb6c976ab732597e907523f6b2420305f9fc7fdbdbjupyter_console-6.6.3.tar.gz"
    sha256 "566a4bf31c87adbfadf22cdf846e3069b59a71ed5da71d6ba4d8aaad14a53539"
  end

  resource "jupyter-core" do
    url "https:files.pythonhosted.orgpackagesc3de53a5c189e358dae95d4176c6075127822c9b00193e8d7b1a77003aab253djupyter_core-5.7.1.tar.gz"
    sha256 "de61a9d7fc71240f688b2fb5ab659fbb56979458dc66a71decd098e03c79e218"
  end

  resource "jupyter-events" do
    url "https:files.pythonhosted.orgpackages5536c65c02b5cedd8f326453dd958f299bfb030609f016d4354217a95d5190e1jupyter_events-0.9.0.tar.gz"
    sha256 "81ad2e4bc710881ec274d31c6c50669d71bbaa5dd9d01e600b56faa85700d399"
  end

  resource "jupyter-lsp" do
    url "https:files.pythonhosted.orgpackages510293423994c2e2827a9315118839448330b37dd5063f2fc318ddb294585b5bjupyter-lsp-2.2.2.tar.gz"
    sha256 "256d24620542ae4bba04a50fc1f6ffe208093a07d8e697fea0a8d1b8ca1b7e5b"
  end

  resource "jupyter-server" do
    url "https:files.pythonhosted.orgpackages033cd91c2b9b5a9b4014fd3df0f1e6ffb53401b798d052831d8a0e084b94b854jupyter_server-2.12.5.tar.gz"
    sha256 "0edb626c94baa22809be1323f9770cf1c00a952b17097592e40d03e6a3951689"
  end

  resource "jupyter-server-terminals" do
    url "https:files.pythonhosted.orgpackagese271c07cc931bdf27c808ccbaff693299f7d68612c87ffdac7e28c2a59020070jupyter_server_terminals-0.5.2.tar.gz"
    sha256 "396b5ccc0881e550bf0ee7012c6ef1b53edbde69e67cab1d56e89711b46052e8"
  end

  resource "jupyterlab-pygments" do
    url "https:files.pythonhosted.orgpackages90519187be60d989df97f5f0aba133fa54e7300f17616e065d1ada7d7646b6d6jupyterlab_pygments-0.3.0.tar.gz"
    sha256 "721aca4d9029252b11cfa9d185e5b5af4d54772bb8072f9b7036f4170054d35d"
  end

  resource "jupyterlab-server" do
    url "https:files.pythonhosted.orgpackages21a6909a008b47560359a5aa75a280bd53ff8f337992a2734b0e9215353cc9aejupyterlab_server-2.25.3.tar.gz"
    sha256 "846f125a8a19656611df5b03e5912c8393cea6900859baa64fa515eb64a8dc40"
  end

  resource "mistune" do
    url "https:files.pythonhosted.orgpackagesefc8f0173fe3bf85fd891aee2e7bcd8207dfe26c2c683d727c5a6cc3aec7b628mistune-3.0.2.tar.gz"
    sha256 "fc7f93ded930c92394ef2cb6f04a8aabab4117a91449e72dcc8dfa646a508be8"
  end

  resource "nbclient" do
    url "https:files.pythonhosted.orgpackages00bb5c11c78351430b2aec4cb9e79b4df8c1815e7eb6c38848ff19e8eba317fanbclient-0.9.0.tar.gz"
    sha256 "4b28c207877cf33ef3a9838cdc7a54c5ceff981194a82eac59d558f05487295e"
  end

  resource "nbconvert" do
    url "https:files.pythonhosted.orgpackagesf2e9659ddf313e8248978232b5e30f6e71f78d64f350e2e5428402b3b7bd2fcanbconvert-7.16.1.tar.gz"
    sha256 "e79e6a074f49ba3ed29428ed86487bf51509d9aab613bd8522ac08f6d28fd7fd"
  end

  resource "nbformat" do
    url "https:files.pythonhosted.orgpackages54d831dceef56952da6ea2c43405a83c9759a22a86cb530197988cfa8599b178nbformat-5.9.2.tar.gz"
    sha256 "5f98b5ba1997dff175e77e0c17d5c10a96eaed2cbd1de3533d1fc35d5e111192"
  end

  resource "nest-asyncio" do
    url "https:files.pythonhosted.orgpackages83f851569ac65d696c8ecbee95938f89d4abf00f47d58d48f6fbabfe8f0baefenest_asyncio-1.6.0.tar.gz"
    sha256 "6f172d5449aca15afd6c646851f4e31e02c598d553a667e38cafa997cfec55fe"
  end

  resource "notebook" do
    url "https:files.pythonhosted.orgpackages58ac4513fdfb233330b570d91c1694352e6ee6fbb96d67f8d59df09e171eddaenotebook-7.1.0.tar.gz"
    sha256 "99caf01ff166b1cc86355c9b37c1ba9bf566c1d7fc4ab57bb6f8f24e36c4260e"
  end

  resource "notebook-shim" do
    url "https:files.pythonhosted.orgpackages54d292fa3243712b9a3e8bafaf60aac366da1cada3639ca767ff4b5b3654ec28notebook_shim-0.2.4.tar.gz"
    sha256 "b4b2cfa1b65d98307ca24361f5b30fe785b53c3fd07b7a47e89acb5e6ac638cb"
  end

  resource "overrides" do
    url "https:files.pythonhosted.orgpackages3686b585f53236dec60aba864e050778b25045f857e17f6e5ea0ae95fe80edd2overrides-7.7.0.tar.gz"
    sha256 "55158fa3d93b98cc75299b1e67078ad9003ca27945c76162c1c0766d6f91820a"
  end

  resource "pandocfilters" do
    url "https:files.pythonhosted.orgpackages706f3dd4940bbe001c06a65f88e36bad298bc7a0de5036115639926b0c5c0458pandocfilters-1.5.1.tar.gz"
    sha256 "002b4a555ee4ebc03f8b66307e287fa492e4a77b4ea14d3f934328297bb4939e"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackages96dcc1d911bf5bb0fdc58cc05010e9f3efe3b67970cef779ba7fbc3183b987a8platformdirs-4.2.0.tar.gz"
    sha256 "ef0cc731df711022c174543cb70a9b5bd22e5a9337c8624ef2c2ceb8ddad8768"
  end

  resource "prometheus-client" do
    url "https:files.pythonhosted.orgpackages3d393be07741a33356127c4fe633768ee450422c1231c6d34b951fee1458308dprometheus_client-0.20.0.tar.gz"
    sha256 "287629d00b147a32dcb2be0b9df905da599b2d82f80377083ec8463309a4bb89"
  end

  resource "python-json-logger" do
    url "https:files.pythonhosted.orgpackages4fda95963cebfc578dabd323d7263958dfb68898617912bb09327dd30e9c8d13python-json-logger-2.0.7.tar.gz"
    sha256 "23e7ec02d34237c5aa1e29a070193a4ea87583bb4e7f8fd06d3de8264c4b2e1c"
  end

  resource "pyzmq" do
    url "https:files.pythonhosted.orgpackages3a331a3683fc9a4bd64d8ccc0290da75c8f042184a1a49c146d28398414d3341pyzmq-25.1.2.tar.gz"
    sha256 "93f1aa311e8bb912e34f004cf186407a4e90eec4f0ecc0efd26056bf7eda0226"
  end

  resource "referencing" do
    url "https:files.pythonhosted.orgpackages21c5b99dd501aa72b30a5a87d488d7aa76ec05bdf0e2c7439bc82deb9448dd9areferencing-0.33.0.tar.gz"
    sha256 "c775fedf74bc0f9189c2a3be1c12fd03e8c23f4d371dce795df44e06c5b412f7"
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

  resource "sniffio" do
    url "https:files.pythonhosted.orgpackagescd50d49c388cae4ec10e8109b1b833fd265511840706808576df3ada99ecb0acsniffio-1.3.0.tar.gz"
    sha256 "e60305c5e5d314f5389259b7f22aaa33d8f7dee49763119234af3755c55b9101"
  end

  resource "soupsieve" do
    url "https:files.pythonhosted.orgpackagesce21952a240de1c196c7e3fbcd4e559681f0419b1280c617db21157a0390717bsoupsieve-2.5.tar.gz"
    sha256 "5663d5a7b3bfaeee0bc4372e7fc48f9cff4940b3eec54a6451cc5299f1097690"
  end

  resource "terminado" do
    url "https:files.pythonhosted.orgpackages65ade84a68d77e39bee20c44909a8a0e3d9c30616f6cd1e2825f0c0372f3ca97terminado-0.18.0.tar.gz"
    sha256 "1ea08a89b835dd1b8c0c900d92848147cef2537243361b2e3f4dc15df9b6fded"
  end

  resource "tinycss2" do
    url "https:files.pythonhosted.orgpackages75be24179dfaa1d742c9365cbd0e3f0edc5d3aa3abad415a2327c5a6ff8ca077tinycss2-1.2.1.tar.gz"
    sha256 "8cff3a8f066c2ec677c06dbc7b45619804a6938478d9d73c284b29d14ecb0627"
  end

  resource "tornado" do
    url "https:files.pythonhosted.orgpackagesbda2ea124343e3b8dd7712561fe56c4f92eda26865f5e1040b289203729186f2tornado-6.4.tar.gz"
    sha256 "72291fa6e6bc84e626589f1c29d90a5a6d593ef5ae68052ee2ef000dfd273dee"
  end

  resource "types-python-dateutil" do
    url "https:files.pythonhosted.orgpackages9b472a9e51ae8cf48cea0089ff6d9d13fff60701f8c9bf72adaee0c4e5dc88f9types-python-dateutil-2.8.19.20240106.tar.gz"
    sha256 "1f8db221c3b98e6ca02ea83a58371b22c374f42ae5bbdf186db9c9a76581459f"
  end

  resource "uri-template" do
    url "https:files.pythonhosted.orgpackages31c70336f2bd0bcbada6ccef7aaa25e443c118a704f828a0620c6fa0207c1b64uri-template-1.3.0.tar.gz"
    sha256 "0e00f8eb65e18c7de20d595a14336e9f337ead580c70934141624b6d1ffdacc7"
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

    # link dependent virtualenvs to this one
    site_packages = Language::Python.site_packages(python3)
    paths = %w[ipython python-lsp-server].map do |package_name|
      package = Formula[package_name].opt_libexec
      packagesite_packages
    end
    (libexecsite_packages"homebrew-deps.pth").write paths.join("\n")

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
    sleep 10
    assert_match "<title>JupyterLab<title>",
      shell_output("curl --silent --fail http:localhost:#{port}lab")
  end
end