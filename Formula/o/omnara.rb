class Omnara < Formula
  include Language::Python::Virtualenv

  desc "Talk to Your AI Agents from Anywhere"
  homepage "https://omnara.com/"
  url "https://files.pythonhosted.org/packages/49/57/af3e082f36ed7a450776580b4011f3aede952267610b06fd353a55365968/omnara-1.5.2.tar.gz"
  sha256 "39edca0d3a2bf10ec91c1a5c66a3c114d24eea004fb63b2662d59b0bbdb257d4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "52ed0aeeb73a50ab85b54d3ed71a298f84f63a0ecb7ae3a39cea9f8222212ed0"
    sha256 cellar: :any,                 arm64_sonoma:  "724a3e524d05ec1cec6349011cffe86061e01fd7c191600b6e9dde1a63c6cac1"
    sha256 cellar: :any,                 arm64_ventura: "358634f190472458949ef789a89218f3310963577f996d731bf38dd00e1cfff5"
    sha256 cellar: :any,                 sonoma:        "8dab6735e0097730e6aaab41564118cddd11ef22c18ba1875dd95246064350d7"
    sha256 cellar: :any,                 ventura:       "f8108faf85b7f37c44f740f7e77d7de8af92742e913f6e2da5415bb0546f0966"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96112a84aa862060678dd2d26ed83edbfc165bafb692ac18d3d3478805f6bd50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ff267aebef62985ff6791b05a500d41fdfd7b9adf8383b081d7169c18a1ea2d"
  end

  depends_on "rust" => :build # for pydantic-core
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/26/30/f84a107a9c4331c14b2b586036f40965c128aa4fee4dda5d3d51cb14ad54/aiohappyeyeballs-2.6.1.tar.gz"
    sha256 "c3f9d0113123803ccadfdf3f0faa505bc78e6a72d1cc4806cbd719826e943558"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/9b/e7/d92a237d8802ca88483906c388f7c201bbe96cd80a165ffd0ac2f6a8d59f/aiohttp-3.12.15.tar.gz"
    sha256 "4fc61385e9c98d72fcdf47e6dd81833f47b2f77c114c29cd64a361be57a763a2"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/61/62/06741b579156360248d1ec624842ad0edf697050bbaf7c3e46394e106ad1/aiosignal-1.4.0.tar.gz"
    sha256 "f47eecd9468083c2029cc99945502cb7708b082c232f9aca65da147157b251c7"
  end

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/f1/b4/636b3b65173d3ce9a38ef5f0522789614e590dab6a8d505340a4efe4c567/anyio-4.10.0.tar.gz"
    sha256 "3f3fae35c96039744587aa5b8371e7e8e603c0702999535961dd336026973ba6"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/5a/b0/1367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24/attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "authlib" do
    url "https://files.pythonhosted.org/packages/8e/a1/d8d1c6f8bc922c0b87ae0d933a8ed57be1bef6970894ed79c2852a153cd3/authlib-1.6.1.tar.gz"
    sha256 "4dffdbb1460ba6ec8c17981a4c67af7d8af131231b5a36a88a1e8c80c111cdfd"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/83/2d/5fd176ceb9b2fc619e63405525573493ca23441330fcdaee6bef9460e924/charset_normalizer-3.4.3.tar.gz"
    sha256 "6fce4b8500244f6fcb71465d4a4930d132ba9ab8e71a7859e6a5d59851068d14"
  end

  resource "claude-code-sdk" do
    url "https://files.pythonhosted.org/packages/6b/c3/d40cf8bab3a5c75051914094990cff0a36ad13e4a2fe9ed85dbb4233a225/claude_code_sdk-0.0.20.tar.gz"
    sha256 "5f9872f105563db8975de48ddc88c948d9c5e1244addca02241d6fcd2a47b3d6"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/60/6c/8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbc/click-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "cyclopts" do
    url "https://files.pythonhosted.org/packages/a3/d5/24c6c894f3833bc93d4944c2064309dfd633c0becf93e16fc79d76edd388/cyclopts-3.22.5.tar.gz"
    sha256 "fa2450b9840abc41c6aa37af5eaeafc7a1264e08054e3a2fe39d49aa154f592a"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/b5/4a/263763cb2ba3816dd94b08ad3a33d5fdae34ecb856678773cc40a3605829/dnspython-2.7.0.tar.gz"
    sha256 "ce9c432eda0dc91cf618a5cedf1a4e142651196bbcd2c80e89ed5a907e5cfaf1"
  end

  resource "docstring-parser" do
    url "https://files.pythonhosted.org/packages/b2/9d/c3b43da9515bd270df0f80548d9944e389870713cc1fe2b8fb35fe2bcefd/docstring_parser-0.17.0.tar.gz"
    sha256 "583de4a309722b3315439bb31d64ba3eebada841f2e2cee23b99df001434c912"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/e9/86/5b41c32ecedcfdb4c77b28b6cb14234f252075f8cdb254531727a35547dd/docutils-0.22.tar.gz"
    sha256 "ba9d57750e92331ebe7c08a1bbf7a7f8143b86c476acd51528b042216a6aad0f"
  end

  resource "email-validator" do
    url "https://files.pythonhosted.org/packages/48/ce/13508a1ec3f8bb981ae4ca79ea40384becc868bfae97fd1c942bb3a001b1/email_validator-2.2.0.tar.gz"
    sha256 "cb690f344c617a714f22e66ae771445a1ceb46821152df8e165c5f9a364582b7"
  end

  resource "exceptiongroup" do
    url "https://files.pythonhosted.org/packages/0b/9f/a65090624ecf468cdca03533906e7c69ed7588582240cfe7cc9e770b50eb/exceptiongroup-1.3.0.tar.gz"
    sha256 "b241f5885f560bc56a59ee63ca4c6a8bfa46ae4ad651af316d4e81817bb9fd88"
  end

  resource "fastapi" do
    url "https://files.pythonhosted.org/packages/78/d7/6c8b3bfe33eeffa208183ec037fee0cce9f7f024089ab1c5d12ef04bd27c/fastapi-0.116.1.tar.gz"
    sha256 "ed52cbf946abfd70c5a0dccb24673f0670deeb517a88b3544d03c2a6bf283143"
  end

  resource "fastmcp" do
    url "https://files.pythonhosted.org/packages/06/80/13aec687ec21727b0fe6d26c6fe2febb33ae24e24c980929a706db3a8bc2/fastmcp-2.11.3.tar.gz"
    sha256 "e8e3834a3e0b513712b8e63a6f0d4cbe19093459a1da3f7fbf8ef2810cfd34e3"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/79/b1/b64018016eeb087db503b038296fd782586432b9c077fc5c7839e9cb6ef6/frozenlist-1.7.0.tar.gz"
    sha256 "2e310d81923c2437ea8670467121cc3e9b0f76d3043cc1d2331d56c7fb7a3a8f"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "httpx-sse" do
    url "https://files.pythonhosted.org/packages/6e/fa/66bd985dd0b7c109a3bcb89272ee0bfb7e2b4d06309ad7b38ff866734b2a/httpx_sse-0.4.1.tar.gz"
    sha256 "8f44d34414bc7b21bf3602713005c5df4917884f76072479b21f68befa4ea26e"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/54/4d/e940025e2ce31a8ce1202635910747e5a87cc3a6a6bb2d00973375014749/isodate-0.7.2.tar.gz"
    sha256 "4cd1aa0f43ca76f4a6c6c0292a85f40b35ec2e43e315b59f06e6d32171a953e6"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/d5/00/a297a868e9d0784450faa7365c2172a7d6110c763e30ba861867c32ae6a9/jsonschema-4.25.0.tar.gz"
    sha256 "e63acf5c11762c0e6672ffb61482bdf57f0876684d8d249c0fe2d730d48bc55f"
  end

  resource "jsonschema-path" do
    url "https://files.pythonhosted.org/packages/6e/45/41ebc679c2a4fced6a722f624c18d658dee42612b83ea24c1caf7c0eb3a8/jsonschema_path-0.3.4.tar.gz"
    sha256 "8365356039f16cc65fddffafda5f58766e34bebab7d6d105616ab52bc4297001"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/bf/ce/46fbd9c8119cfc3581ee5643ea49464d168028cfb5caff5fc0596d0cf914/jsonschema_specifications-2025.4.1.tar.gz"
    sha256 "630159c9f4dbea161a6a2205c3011cc4f18ff381b189fff48bb39b9bf26ae608"
  end

  resource "lazy-object-proxy" do
    url "https://files.pythonhosted.org/packages/57/f9/1f56571ed82fb324f293661690635cf42c41deb8a70a6c9e6edc3e9bb3c8/lazy_object_proxy-1.11.0.tar.gz"
    sha256 "18874411864c9fbbbaa47f9fc1dd7aea754c86cfde21278ef427639d1dd78e9c"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "mcp" do
    url "https://files.pythonhosted.org/packages/d3/a8/564c094de5d6199f727f5d9f5672dbec3b00dfafd0f67bf52d995eaa5951/mcp-1.13.0.tar.gz"
    sha256 "70452f56f74662a94eb72ac5feb93997b35995e389b3a3a574e078bed2aa9ab3"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/ce/a0/834b0cebabbfc7e311f30b46c8188790a37f89fc8d756660346fe5abfd09/more_itertools-10.7.0.tar.gz"
    sha256 "9fddd5403be01a94b204faadcff459ec3568cf110265d3c54323e1e866ad29d3"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/69/7f/0652e6ed47ab288e3756ea9c0df8b14950781184d4bd7883f4d87dd41245/multidict-6.6.4.tar.gz"
    sha256 "d2d4e4787672911b48350df02ed3fa3fffdc2f2e8ca06dd6afdf34189b76a9dd"
  end

  resource "openapi-core" do
    url "https://files.pythonhosted.org/packages/b1/35/1acaa5f2fcc6e54eded34a2ec74b479439c4e469fc4e8d0e803fda0234db/openapi_core-0.19.5.tar.gz"
    sha256 "421e753da56c391704454e66afe4803a290108590ac8fa6f4a4487f4ec11f2d3"
  end

  resource "openapi-pydantic" do
    url "https://files.pythonhosted.org/packages/02/2e/58d83848dd1a79cb92ed8e63f6ba901ca282c5f09d04af9423ec26c56fd7/openapi_pydantic-0.5.1.tar.gz"
    sha256 "ff6835af6bde7a459fb93eb93bb92b8749b754fc6e51b2f1590a19dc3005ee0d"
  end

  resource "openapi-schema-validator" do
    url "https://files.pythonhosted.org/packages/8b/f3/5507ad3325169347cd8ced61c232ff3df70e2b250c49f0fe140edb4973c6/openapi_schema_validator-0.6.3.tar.gz"
    sha256 "f37bace4fc2a5d96692f4f8b31dc0f8d7400fd04f3a937798eaf880d425de6ee"
  end

  resource "openapi-spec-validator" do
    url "https://files.pythonhosted.org/packages/82/af/fe2d7618d6eae6fb3a82766a44ed87cd8d6d82b4564ed1c7cfb0f6378e91/openapi_spec_validator-0.7.2.tar.gz"
    sha256 "cc029309b5c5dbc7859df0372d55e9d1ff43e96d678b9ba087f7c56fc586f734"
  end

  resource "parse" do
    url "https://files.pythonhosted.org/packages/4f/78/d9b09ba24bb36ef8b83b71be547e118d46214735b6dfb39e4bfde0e9b9dd/parse-1.20.2.tar.gz"
    sha256 "b41d604d16503c79d81af5165155c0b20f6c8d6c559efa66b4b695c3e5a0a0ce"
  end

  resource "pathable" do
    url "https://files.pythonhosted.org/packages/67/93/8f2c2075b180c12c1e9f6a09d1a985bc2036906b13dff1d8917e395f2048/pathable-0.4.4.tar.gz"
    sha256 "6905a3cd17804edfac7875b5f6c9142a218c7caef78693c2dbbbfbac186d88b2"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/a6/16/43264e4a779dd8588c21a70f0709665ee8f611211bdd2c87d952cfa7c776/propcache-0.3.2.tar.gz"
    sha256 "20d7d62e4e7ef05f221e0db2856b979540686342e7dd9973b815599c7057e168"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/00/dd/4325abf92c39ba8623b5af936ddb36ffcfe0beae70405d456ab1fb2f5b8c/pydantic-2.11.7.tar.gz"
    sha256 "d989c3c6cb79469287b1569f7447a17848c998458d49ebe294e975b9baf0f0db"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/ad/88/5f2260bdfae97aabf98f1778d43f69574390ad787afb646292a638c923d4/pydantic_core-2.33.2.tar.gz"
    sha256 "7cb8bc3605c29176e1b105350d2e6474142d7c1bd1d9327c4a9bdb46bf827acc"
  end

  resource "pydantic-settings" do
    url "https://files.pythonhosted.org/packages/68/85/1ea668bbab3c50071ca613c6ab30047fb36ab0da1b92fa8f17bbc38fd36c/pydantic_settings-2.10.1.tar.gz"
    sha256 "06f0062169818d0f5524420a360d632d5857b83cffd4d42fe29597807a1614ee"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/30/23/2f0a3efc4d6a32f3b63cdff36cd398d9701d26cda58e3ab97ac79fb5e60d/pyperclip-1.9.0.tar.gz"
    sha256 "b7de0142ddc81bfc5c7507eea19da920b92252b548b96186caf94a5e2527d310"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/f6/b0/4bc07ccd3572a2f9df7e6782f52b0c6c90dcbb803ac4a167702d7d0dfe1e/python_dotenv-1.1.1.tar.gz"
    sha256 "a8a6399716257f45be6a007360200409fce5cda2661e3dec71d23dc15f6189ab"
  end

  resource "python-multipart" do
    url "https://files.pythonhosted.org/packages/f3/87/f44d7c9f274c7ee665a29b885ec97089ec5dc034c7f3fafa03da9e39a09e/python_multipart-0.0.20.tar.gz"
    sha256 "8dd0cab45b8e23064ae09147625994d090fa46f5b0d1e13af944c331a7fa9d13"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/2f/db/98b5c277be99dd18bfd91dd04e1b759cad18d1a338188c936e92f921c7e2/referencing-0.36.2.tar.gz"
    sha256 "df2e89862cd09deabbdba16944cc3f10feb6b3e6f18e902f7cc25609a34775aa"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e1/0a/929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8/requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "rfc3339-validator" do
    url "https://files.pythonhosted.org/packages/28/ea/a9387748e2d111c3c2b275ba970b735e04e15cdb1eb30693b6b5708c4dbd/rfc3339_validator-0.1.4.tar.gz"
    sha256 "138a2abdf93304ad60530167e51d2dfb9549521a836871b88d7f4695d0022f6b"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/fe/75/af448d8e52bf1d8fa6a9d089ca6c07ff4453d86c65c145d0a300bb073b9b/rich-14.1.0.tar.gz"
    sha256 "e497a48b844b0320d45007cdebfeaeed8db2a4f4bcf49f15e455cfc4af11eaa8"
  end

  resource "rich-rst" do
    url "https://files.pythonhosted.org/packages/b0/69/5514c3a87b5f10f09a34bb011bc0927bc12c596c8dae5915604e71abc386/rich_rst-1.3.1.tar.gz"
    sha256 "fad46e3ba42785ea8c1785e2ceaa56e0ffa32dbe5410dec432f37e4107c4f383"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/1e/d9/991a0dee12d9fc53ed027e26a26a64b151d77252ac477e22666b9688bc16/rpds_py-0.27.0.tar.gz"
    sha256 "8b23cf252f180cda89220b378d917180f29d313cd6a07b2431c0d3b776aae86f"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "sse-starlette" do
    url "https://files.pythonhosted.org/packages/42/6f/22ed6e33f8a9e76ca0a412405f31abb844b779d52c5f96660766edcd737c/sse_starlette-3.0.2.tar.gz"
    sha256 "ccd60b5765ebb3584d0de2d7a6e4f745672581de4f5005ab31c3a25d10b52b3a"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/04/57/d062573f391d062710d4088fa1369428c38d51460ab6fedff920efef932e/starlette-0.47.2.tar.gz"
    sha256 "6ae9aa5db235e4846decc1e7b79c4f346adf41e9777aebeb49dfd09bbd7023d8"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/98/5a/da40306b885cc8c09109dc2e1abd358d5684b1425678151cdaed4731c822/typing_extensions-4.14.1.tar.gz"
    sha256 "38b39f4aeeab64884ce9f74c94263ef78f3c22467c8724005483154c26648d36"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/f8/b1/0c11f5058406b3af7609f121aaa6b609744687f1d158b3c3a5bf4cc94238/typing_inspection-0.4.1.tar.gz"
    sha256 "6ae134cc0203c33377d43188d4064e9b357dba58cff3185f22924610e70a9d28"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/5e/42/e0e305207bb88c6b8d3061399c6a961ffe5fbb7e2aa63c9234df7259e9cd/uvicorn-0.35.0.tar.gz"
    sha256 "bc662f087f7cf2ce11a1d7fd70b90c9f98ef2e2831556dd078d131b96cc94a01"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/32/af/d4502dc713b4ccea7175d764718d5183caf8d0867a4f0190d5d4a45cea49/werkzeug-3.1.1.tar.gz"
    sha256 "8cd39dfbdfc1e051965f156163e2974e52c210f130810e9ad36858f0fd3edad4"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/3c/fb/efaa23fa4e45537b827620f04cf8f3cd658b76642205162e072703a5b963/yarl-1.20.1.tar.gz"
    sha256 "d017a4997ee50c91fd5466cef416231bb82177b93b029906cefc542ce14c35ac"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/omnara --version")

    output = shell_output("#{bin}/omnara --api-key dummy 2>&1", 1)
    assert_match "Error: Authentication failed", output

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output("#{bin}/omnara mcp --api-key test 2>&1", json, 0)
    assert_match "Starting Omnara MCP server (stdio)", output
  end
end