class MistralVibe < Formula
  include Language::Python::Virtualenv

  desc "Minimal CLI coding agent"
  homepage "https://github.com/mistralai/mistral-vibe"
  url "https://files.pythonhosted.org/packages/c5/85/51df99727639d090820a740c50a22e25a6e195cacff3864e30e2bc573aff/mistral_vibe-2.3.0.tar.gz"
  sha256 "f8c03d0edb1378e3814dfbe08cf5b649d02ec2360fbe002da7ec5cefbff5e60d"
  license "Apache-2.0"
  head "https://github.com/mistralai/mistral-vibe.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "097ab41468104b278f85cd220c37815d7653e4d0cf0fe4125d6f59d0a20615fb"
    sha256 cellar: :any,                 arm64_sequoia: "0fddc6b8e84dd7daa190f85167eff6a23925f87099fbe09cb568cff9812e89d2"
    sha256 cellar: :any,                 arm64_sonoma:  "baf0798dc9319abb41101ed1b2c24b440c14e624e409614e9e22d229c6cc0e38"
    sha256 cellar: :any,                 sonoma:        "8a1f09a70530306e026a5e40ec7339a571e7d51fe3e07de77775bbfa493ed477"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6bc24c49c244cc24ebe4f47f7353f433003970e37e203eb76d88ac3342ed640c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0313dfc7c078bfc62a9e7c2013ff673f994b552075127ab0a6382dcc77bd1c43"
  end

  depends_on "rust" => :build
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"
  depends_on "rpds-py" => :no_linkage

  pypi_packages exclude_packages: %w[certifi cryptography pydantic rpds-py]

  resource "agent-client-protocol" do
    url "https://files.pythonhosted.org/packages/1b/7b/7cdac86db388809d9e3bc58cac88cc7dfa49b7615b98fab304a828cd7f8a/agent_client_protocol-0.8.1.tar.gz"
    sha256 "1bbf15663bf51f64942597f638e32a6284c5da918055d9672d3510e965143dbd"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/96/f0/5eb65b2bb0d09ac6776f2eb54adee6abe8228ea05b20a5ad0e4945de8aac/anyio-4.12.1.tar.gz"
    sha256 "41cfcc3a4c85d3f05c932da7c26d0201ac36f72abd4435ba90d0464a3ffed703"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/c3/b0/1c6a16426d389813b48d95e26898aff79abbde42ad353958ad95cc8c9b21/beautifulsoup4-4.14.3.tar.gz"
    sha256 "6292b1c5186d356bba669ef9f7f051757099565ad9ada5dd630bd9de5fa7fb86"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/d4/07/56595285564e90777d758ebd383d6b0b971b87729bbe2184a849932a3736/cachetools-7.0.1.tar.gz"
    sha256 "e31e579d2c5b6e2944177a0397150d312888ddf4e16e12f1016068f0c03b8341"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "eval-type-backport" do
    url "https://files.pythonhosted.org/packages/fb/a3/cafafb4558fd638aadfe4121dc6cefb8d743368c085acb2f521df0f3d9d7/eval_type_backport-0.3.1.tar.gz"
    sha256 "57e993f7b5b69d271e37482e62f74e76a0276c82490cf8e4f0dffeb6b332d5ed"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/72/94/63b0fc47eb32792c7ba1fe1b694daec9a63620db1e313033d18140c2320a/gitdb-4.0.12.tar.gz"
    sha256 "5ef71f855d191a3326fcfbc0d5da835f26b13fbcba60c32c21091c349ffdb571"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/df/b5/59d16470a1f0dfe8c793f9ef56fd3826093fc52b3bd96d6b9d6c26c7e27b/gitpython-3.1.46.tar.gz"
    sha256 "400124c7d0ef4ea03f7310ac2fbf7151e09ff97f2a3288d64a440c584a29c37f"
  end

  resource "giturlparse" do
    url "https://files.pythonhosted.org/packages/09/35/7f25a604a406be7d7d0f849bfcbc1603df084e9e58fe6170980c231138e4/giturlparse-0.14.0.tar.gz"
    sha256 "0a13208cb3f60e067ee3d09d28e01f9c936065986004fa2d5cd6db7758e9f6e6"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/0c/41/242044323fbd746615884b1c16639749e73665b718209946ebad7ba8a813/google_auth-2.48.0.tar.gz"
    sha256 "4f7e706b0cd3208a3d940a19a822c37a476ddba5450156c3e6624a71f7c841ce"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/e5/7b/adfd75544c415c487b33061fe7ae526165241c1ea133f9a9125a56b39fd8/googleapis_common_protos-1.72.0.tar.gz"
    sha256 "e55a601c1b32b52d7a3e65f43563e2aa61bcd737998ee672ac9b951cd49319f5"
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
    url "https://files.pythonhosted.org/packages/0f/4c/751061ffa58615a32c31b2d82e8482be8dd4a89154f003147acee90f2be9/httpx_sse-0.4.3.tar.gz"
    sha256 "9b1ed0127459a66014aec3c56bebd93da3c1bc8bb6618c8082039a44889a755d"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/f3/49/3b30cad09e7771a4982d9975a8cbf64f00d4a1ececb53297f1d9a7be1b10/importlib_metadata-8.7.1.tar.gz"
    sha256 "49fef1ae6440c182052f407c8d34a68f72efc36db9ca90dc0113398f2fdde8bb"
  end

  resource "invoke" do
    url "https://files.pythonhosted.org/packages/de/bd/b461d3424a24c80490313fd77feeb666ca4f6a28c7e72713e3d9095719b4/invoke-2.2.1.tar.gz"
    sha256 "515bf49b4a48932b79b024590348da22f39c4942dff991ad1fb8b8baea1be707"
  end

  resource "jaraco-classes" do
    url "https://files.pythonhosted.org/packages/06/c0/ed4a27bc5571b99e3cff68f8a9fa5b56ff7df1c2251cc715a652ddd26402/jaraco.classes-3.4.0.tar.gz"
    sha256 "47a024b51d0239c0dd8c8540c6c7f484be3b8fcf0b2d85c13825780d3b3f3acd"
  end

  resource "jaraco-context" do
    url "https://files.pythonhosted.org/packages/cb/9c/a788f5bb29c61e456b8ee52ce76dbdd32fd72cd73dd67bc95f42c7a8d13c/jaraco_context-6.1.0.tar.gz"
    sha256 "129a341b0a85a7db7879e22acd66902fda67882db771754574338898b2d5d86f"
  end

  resource "jaraco-functools" do
    url "https://files.pythonhosted.org/packages/0f/27/056e0638a86749374d6f57d0b0db39f29509cce9313cf91bdc0ac4d91084/jaraco_functools-4.4.0.tar.gz"
    sha256 "da21933b0417b89515562656547a77b4931f98176eb173644c0d35032a33d6bb"
  end

  resource "jeepney" do
    url "https://files.pythonhosted.org/packages/7b/6f/357efd7602486741aa73ffc0617fb310a29b588ed0fd69c2399acbb85b0c/jeepney-0.9.0.tar.gz"
    sha256 "cf0e9e845622b81e4a28df94c40345400256ec608d0e55bb8a3feaa9163f5732"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/b3/fc/e067678238fa451312d4c62bf6e6cf5ec56375422aee02f9cb5f909b3047/jsonschema-4.26.0.tar.gz"
    sha256 "0c26707e2efad8aa1bfc5b7ce170f3fccc2e4918ff85989ba9ffa9facb2be326"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/43/4b/674af6ef2f97d56f0ab5153bf0bfa28ccb6c3ed4d1babf4305449668807b/keyring-25.7.0.tar.gz"
    sha256 "fe01bd85eb3f8fb3dd0405defdeac9a5b4f6f0439edbb3149577f244a2e8245b"
  end

  resource "linkify-it-py" do
    url "https://files.pythonhosted.org/packages/2a/ae/bb56c6828e4797ba5a4821eec7c43b8bf40f69cda4d4f5f8c8a2810ec96a/linkify-it-py-2.0.3.tar.gz"
    sha256 "68cda27e162e9215c17d786649d1da0021a451bdc436ef9e0fa0ba5234b9b048"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "markdownify" do
    url "https://files.pythonhosted.org/packages/3f/bc/c8c8eea5335341306b0fa7e1cb33c5e1c8d24ef70ddd684da65f41c49c92/markdownify-1.2.2.tar.gz"
    sha256 "b274f1b5943180b031b699b199cbaeb1e2ac938b75851849a31fd0c3d6603d09"
  end

  resource "mcp" do
    url "https://files.pythonhosted.org/packages/fc/6d/62e76bbb8144d6ed86e202b5edd8a4cb631e7c8130f3f4893c3f90262b10/mcp-1.26.0.tar.gz"
    sha256 "db6e2ef491eecc1a0d93711a76f28dec2e05999f93afd48795da1c1137142c66"
  end

  resource "mdit-py-plugins" do
    url "https://files.pythonhosted.org/packages/b2/fd/a756d36c0bfba5f6e39a1cdbdbfdd448dc02692467d83816dff4592a1ebc/mdit_py_plugins-0.5.0.tar.gz"
    sha256 "f4918cb50119f50446560513a8e311d574ff6aaed72606ddae6d35716fe809c6"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "mistralai" do
    url "https://files.pythonhosted.org/packages/aa/12/c3476c53e907255b5f485f085ba50dd9a84b40fe662e9a888d6ded26fa7b/mistralai-1.12.4.tar.gz"
    sha256 "e52b53bab58025dcd208eeac13e3c3df5778d4112eeca1f08124096c7738929f"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/ea/5d/38b681d3fce7a266dd9ab73c66959406d565b3e85f21d5e66e1181d93721/more_itertools-10.8.0.tar.gz"
    sha256 "f638ddf8a1a0d134181275fb5d58b086ead7c6a72429ad725c67503f13ba30bd"
  end

  resource "opentelemetry-api" do
    url "https://files.pythonhosted.org/packages/97/b9/3161be15bb8e3ad01be8be5a968a9237c3027c5be504362ff800fca3e442/opentelemetry_api-1.39.1.tar.gz"
    sha256 "fbde8c80e1b937a2c61f20347e91c0c18a1940cecf012d62e65a7caf08967c9c"
  end

  resource "opentelemetry-exporter-otlp-proto-common" do
    url "https://files.pythonhosted.org/packages/e9/9d/22d241b66f7bbde88a3bfa6847a351d2c46b84de23e71222c6aae25c7050/opentelemetry_exporter_otlp_proto_common-1.39.1.tar.gz"
    sha256 "763370d4737a59741c89a67b50f9e39271639ee4afc999dadfe768541c027464"
  end

  resource "opentelemetry-exporter-otlp-proto-http" do
    url "https://files.pythonhosted.org/packages/80/04/2a08fa9c0214ae38880df01e8bfae12b067ec0793446578575e5080d6545/opentelemetry_exporter_otlp_proto_http-1.39.1.tar.gz"
    sha256 "31bdab9745c709ce90a49a0624c2bd445d31a28ba34275951a6a362d16a0b9cb"
  end

  resource "opentelemetry-proto" do
    url "https://files.pythonhosted.org/packages/49/1d/f25d76d8260c156c40c97c9ed4511ec0f9ce353f8108ca6e7561f82a06b2/opentelemetry_proto-1.39.1.tar.gz"
    sha256 "6c8e05144fc0d3ed4d22c2289c6b126e03bcd0e6a7da0f16cedd2e1c2772e2c8"
  end

  resource "opentelemetry-sdk" do
    url "https://files.pythonhosted.org/packages/eb/fb/c76080c9ba07e1e8235d24cdcc4d125ef7aa3edf23eb4e497c2e50889adc/opentelemetry_sdk-1.39.1.tar.gz"
    sha256 "cf4d4563caf7bff906c9f7967e2be22d0d6b349b908be0d90fb21c8e9c995cc6"
  end

  resource "opentelemetry-semantic-conventions" do
    url "https://files.pythonhosted.org/packages/91/df/553f93ed38bf22f4b999d9be9c185adb558982214f33eae539d3b5cd0858/opentelemetry_semantic_conventions-0.60b1.tar.gz"
    sha256 "87c228b5a0669b748c76d76df6c364c369c28f1c465e50f661e39737e84bc953"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/65/ee/299d360cdc32edc7d2cf530f3accf79c4fca01e96ffc950d8a52213bd8e4/packaging-26.0.tar.gz"
    sha256 "00243ae351a257117b6a241061796684b084ed1c516a08c48a3f7e147a9d80b4"
  end

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/42/92/cc564bf6381ff43ce1f4d06852fc19a2f11d180f23dc32d9588bee2f149d/pexpect-4.9.0.tar.gz"
    sha256 "ee7d41123f3c9911050ea2c2dac107568dc43b2d3b0c7557a33212c398ead30f"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/1b/04/fea538adf7dbbd6d186f551d595961e564a3b6715bdf276b477460858672/platformdirs-4.9.2.tar.gz"
    sha256 "9a33809944b9db043ad67ca0db94b14bf452cc6aeaac46a88ea55b26e2e9d291"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/ba/25/7c72c307aafc96fa87062aa6291d9f7c94836e43214d43722e86037aac02/protobuf-6.33.5.tar.gz"
    sha256 "6ddcac2a081f8b7b9642c09406bc6a4290128fce5f471cddd165960bb9119e5c"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/20/e5/16ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4e/ptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/fe/b6/6e630dff89739fcd427e3f72b3d905ce0acb85a45d4ec3e2678718a3487f/pyasn1-0.6.2.tar.gz"
    sha256 "9b59a2b25ba7e4f8197db7686c09fb33e658b98339fadb826e9512629017833b"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/e9/e6/78ebbb10a8c8e4b61a59249394a4a594c1a7af95593dc933a349c8d00964/pyasn1_modules-0.4.2.tar.gz"
    sha256 "677091de870a80aae844b1ca6134f54652fa2c8c5a52aa396440ac3106e941e6"
  end

  resource "pydantic-settings" do
    url "https://files.pythonhosted.org/packages/52/6d/fffca34caecc4a3f97bda81b2098da5e8ab7efc9a66e819074a11955d87e/pydantic_settings-2.13.1.tar.gz"
    sha256 "b4c11847b15237fb0171e1462bf540e294affb9b86db4d9aa5c01730bdbe4025"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/5c/5a/b46fa56bf322901eee5b0454a34343cdbdae202cd421775a8ee4e42fd519/pyjwt-2.11.0.tar.gz"
    sha256 "35f95c1f0fbe5d5ba6e43f00271c275f7a1a4db1dab27bf708073b75318ea623"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/e8/52/d87eba7cb129b81563019d1679026e7a112ef76855d6159d24754dbd2a51/pyperclip-1.11.0.tar.gz"
    sha256 "244035963e4428530d9e3a6101a1ef97209c6825edab1567beac148ccc1db1b6"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/f0/26/19cadc79a718c5edbec86fd4919a6b6d3f681039a2f6d66d14be94e75fb9/python_dotenv-1.2.1.tar.gz"
    sha256 "42667e897e16ab0d66954af0e60a9caa94f0fd4ecf3aaf6d2d260eec1aa36ad6"
  end

  resource "python-multipart" do
    url "https://files.pythonhosted.org/packages/94/01/979e98d542a70714b0cb2b6728ed0b7c46792b695e3eaec3e20711271ca3/python_multipart-0.0.22.tar.gz"
    sha256 "7340bef99a7e0032613f56dc36027b959fd3b30a787ed62d310e951f7c3a3a58"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/22/f5/df4e9027acead3ecc63e50fe1e36aca1523e1719559c499951bb4b53188f/referencing-0.37.0.tar.gz"
    sha256 "44aefc3142c5b842538163acb373e24cce6632bd54bdb01b21ad5863489f50d8"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/b3/c6/f3b320c27991c46f43ee9d856302c70dc2d0fb2dba4842ff739d5f46b393/rich-14.3.3.tar.gz"
    sha256 "b8daa0b9e4eef54dd8cf7c86c03713f53241884e814f4e2f5fb342fe520f639b"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/da/8a/22b7beea3ee0d44b1916c0c1cb0ee3af23b700b6da9f04991899d0c555d4/rsa-4.9.1.tar.gz"
    sha256 "e7bdbfdb5497da4c07dfd35530e1a902659db6ff241e39d9953cad06ebd0ae75"
  end

  resource "secretstorage" do
    url "https://files.pythonhosted.org/packages/1c/03/e834bcd866f2f8a49a85eaff47340affa3bfa391ee9912a952a1faa68c7b/secretstorage-3.5.0.tar.gz"
    sha256 "f04b8e4689cbce351744d5537bf6b1329c6fc68f91fa666f60a380edddcd11be"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/44/cd/a040c4b3119bbe532e5b0732286f805445375489fceaec1f48306068ee3b/smmap-5.0.2.tar.gz"
    sha256 "26ea65a03958fa0c8a1c7e8c7a58fdc77221b8910f6be2131affade476898ad5"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/7b/ae/2d9c981590ed9999a0d91755b47fc74f74de286b0f5cee14c9269041e6c4/soupsieve-2.8.3.tar.gz"
    sha256 "3267f1eeea4251fb42728b6dfb746edc9acaffc4a45b27e19450b676586e8349"
  end

  resource "sse-starlette" do
    url "https://files.pythonhosted.org/packages/8b/8d/00d280c03ffd39aaee0e86ec81e2d3b9253036a0f93f51d10503adef0e65/sse_starlette-3.2.0.tar.gz"
    sha256 "8127594edfb51abe44eac9c49e59b0b01f1039d0c7461c6fd91d4e03b70da422"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/c4/68/79977123bb7be889ad680d79a40f339082c1978b5cfcf62c2d8d196873ac/starlette-0.52.1.tar.gz"
    sha256 "834edd1b0a23167694292e94f597773bc3f89f362be6effee198165a35d62933"
  end

  resource "textual" do
    url "https://files.pythonhosted.org/packages/f7/08/1e1f705825359590ddfaeda57653bd518c4ff7a96bb2c3239ba1b6fc4c51/textual-8.0.0.tar.gz"
    sha256 "ce48f83a3d686c0fac0e80bf9136e1f8851c653aa6a4502e43293a151df18809"
  end

  resource "textual-speedups" do
    url "https://files.pythonhosted.org/packages/d4/73/bba3e9feae9ca730c32122306ddac61278a8bc47633346eddad9d52a435d/textual_speedups-0.2.1.tar.gz"
    sha256 "72cf0f7bdeede015367b59b70bcf724ba2c3080a8641ebc5eb94b36ad1536824"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/19/75/241269d1da26b624c0d5e110e8149093c759b7a286138f4efd61a60e75fe/tomli_w-1.2.0.tar.gz"
    sha256 "2dd14fac5a47c27be9cd4c976af5a12d87fb1f0b4512f81d69cce3b35ae25021"
  end

  resource "tree-sitter" do
    url "https://files.pythonhosted.org/packages/66/7c/0350cfc47faadc0d3cf7d8237a4e34032b3014ddf4a12ded9933e1648b55/tree-sitter-0.25.2.tar.gz"
    sha256 "fe43c158555da46723b28b52e058ad444195afd1db3ca7720c59a254544e9c20"
  end

  resource "tree-sitter-bash" do
    url "https://files.pythonhosted.org/packages/8e/0e/f0108be910f1eef6499eabce517e79fe3b12057280ed398da67ce2426cba/tree_sitter_bash-0.25.1.tar.gz"
    sha256 "bfc0bdaa77bc1e86e3c6652e5a6e140c40c0a16b84185c2b63ad7cd809b88f14"
  end

  resource "uc-micro-py" do
    url "https://files.pythonhosted.org/packages/91/7a/146a99696aee0609e3712f2b44c6274566bc368dfe8375191278045186b8/uc-micro-py-1.0.3.tar.gz"
    sha256 "d321b92cff673ec58027c04015fcaa8bb1e005478643ff4a500882eaab88c48a"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/32/ce/eeb58ae4ac36fe09e3842eb02e0eb676bf2c53ae062b98f1b2531673efdd/uvicorn-0.41.0.tar.gz"
    sha256 "09d11cf7008da33113824ee5a1c6422d89fbc2ff476540d69a34c87fab8b571a"
  end

  resource "watchfiles" do
    url "https://files.pythonhosted.org/packages/c2/c9/8869df9b2a2d6c59d79220a4db37679e74f807c559ffe5265e08b227a210/watchfiles-1.1.1.tar.gz"
    sha256 "a173cb5c16c4f40ab19cecf48a534c409f7ea983ab8fed0741304a1c0a31b3f2"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/e3/02/0f2892c661036d50ede074e376733dca2ae7c6eb617489437771209d4180/zipp-3.23.0.tar.gz"
    sha256 "a07157588a12518c9d4034df3fbbee09c814741a33ff63c05fa29d26a2404166"
  end

  resource "zstandard" do
    url "https://files.pythonhosted.org/packages/fd/aa/3e0508d5a5dd96529cdc5a97011299056e14c6505b678fd58938792794b1/zstandard-0.25.0.tar.gz"
    sha256 "7713e1179d162cf5c7906da876ec2ccb9c3a9dcbdffef0cc7f70c3667a205f0b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/vibe --workdir /nonexistent/path 2>&1", 1)
    assert_match "does not exist", output
  end
end