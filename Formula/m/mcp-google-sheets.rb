class McpGoogleSheets < Formula
  include Language::Python::Virtualenv

  desc "MCP server integrates with your Google Drive and Google Sheets"
  homepage "https://github.com/xing5/mcp-google-sheets"
  url "https://files.pythonhosted.org/packages/b2/cb/ba262f74fc2665442837cb88a9a9662ff360d6d8614600e525225edbdb2f/mcp_google_sheets-0.5.1.tar.gz"
  sha256 "9ba9d779baf47c383eec5246d52c19af580f236999a7e99f4a02e8545e31cff7"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f50062e7bf26799dd2828a3fc35c78543c7c14801477eeda0cdef803858a6e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "782553590cd44821298b97bfb649d32556eb55a4cd169648586b71b9e4ac6f84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "375112a2230752c290d00c51a4145b5c0a94f08f839540bb04a049286f5c25e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "928116dd2b67d641700ec9a8983809b608712920fcf5e7c40c2d038b8c29bef1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99e648b117eba1337c684ab300eb17b817bfdca78af13a0eaa349ec9b1ee0541"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b24d7ab4e4d15267db9f1e1ba79bcc760712552a58d6cdc6e12995f30439bb5c"
  end

  depends_on "certifi" => :no_linkage
  depends_on "pydantic-core" => :no_linkage
  depends_on "python@3.14"
  depends_on "rpds-py" => :no_linkage

  pypi_packages exclude_packages: ["certifi", "pydantic-core", "rpds-py"]

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/c6/78/7d432127c41b50bccba979505f272c16cbcadcc33645d5fa3a738110ae75/anyio-4.11.0.tar.gz"
    sha256 "82a8d0b81e318cc5ce71a5f1f8b5c4e63619620b63141ef8c995fa0db95a57c4"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/cc/7e/b975b5814bd36faf009faebe22c1072a1fa1168db34d285ef0ba071ad78c/cachetools-6.2.1.tar.gz"
    sha256 "3f391e4bd8f8bf0931169baf7456cc822705f4e2a31f840d218f445b9a854201"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/46/61/de6cd827efad202d7057d93e0fed9294b96952e188f7384832791c7b2254/click-8.3.0.tar.gz"
    sha256 "e7b8232224eba16f4ebe410c25ced9f7875cb5f3263ffc93cc3e8da705e229c4"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/61/da/83d7043169ac2c8c7469f0e375610d78ae2160134bf1b80634c482fa079c/google_api_core-2.28.1.tar.gz"
    sha256 "2b405df02d68e68ce0fbc138559e6036559e685159d148ae5861013dc201baf8"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/8e/5a/6f9b49d67ea91376305fdb8bbf2877c746d756e45fd8fb7d2e32d6dad19b/google_api_python_client-2.185.0.tar.gz"
    sha256 "aa1b338e4bb0f141c2df26743f6b46b11f38705aacd775b61971cbc51da089c3"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/11/75/28881e9d7de9b3d61939bc9624bd8fa594eb787a00567aba87173c790f09/google_auth-2.42.0.tar.gz"
    sha256 "9bbbeef3442586effb124d1ca032cfb8fb7acd8754ab79b55facd2b8f3ab2802"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/56/be/217a598a818567b28e859ff087f347475c807a5649296fb5a817c58dacef/google-auth-httplib2-0.2.0.tar.gz"
    sha256 "38aa7badf48f974f1eb9861794e9c0cb2a0511a4ec0679b1f886d108f5640e05"
  end

  resource "google-auth-oauthlib" do
    url "https://files.pythonhosted.org/packages/fb/87/e10bf24f7bcffc1421b84d6f9c3377c30ec305d082cd737ddaa6d8f77f7c/google_auth_oauthlib-1.2.2.tar.gz"
    sha256 "11046fb8d3348b296302dd939ace8af0a724042e8029c1b872d87fabc9f41684"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/30/43/b25abe02db2911397819003029bef768f68a974f2ece483e6084d1a5f754/googleapis_common_protos-1.71.0.tar.gz"
    sha256 "1aec01e574e29da63c80ba9f7bbf1ccfaacf1da877f23609fe236ca7c72a2e2e"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/52/77/6653db69c1f7ecfe5e3f9726fdadc981794656fcd7d98c4209fecfea9993/httplib2-0.31.0.tar.gz"
    sha256 "ac7ab497c50975147d4f7b1ade44becc7df2f8954d42b38b3d69c515f531135c"
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

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/74/69/f7185de793a29082a9f3c7728268ffb31cb5095131a9c139a74078e27336/jsonschema-4.25.1.tar.gz"
    sha256 "e4a9655ce0da0c0b67a085847e00a3a51449e1157f4f75e9fb5aa545e122eb85"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "mcp" do
    url "https://files.pythonhosted.org/packages/69/2b/916852a5668f45d8787378461eaa1244876d77575ffef024483c94c0649c/mcp-1.19.0.tar.gz"
    sha256 "213de0d3cd63f71bc08ffe9cc8d4409cc87acffd383f6195d2ce0457c021b5c1"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/0b/5f/19930f824ffeb0ad4372da4812c50edbd1434f678c90c2733e1188edfc63/oauthlib-3.3.1.tar.gz"
    sha256 "0f0f8aa759826a193cf66c12ea1af1637f87b9b4622d46e866952bb022e538c9"
  end

  resource "proto-plus" do
    url "https://files.pythonhosted.org/packages/f4/ac/87285f15f7cce6d4a008f33f1757fb5a13611ea8914eb58c3d0d26243468/proto_plus-1.26.1.tar.gz"
    sha256 "21a515a4c4c0088a773899e23c7bbade3d18f9c66c73edd4c7ee3816bc96a012"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/19/ff/64a6c8f420818bb873713988ca5492cba3a7946be57e027ac63495157d97/protobuf-6.33.0.tar.gz"
    sha256 "140303d5c8d2037730c548f8c7b93b20bb1dc301be280c378b82b8894589c954"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/ba/e9/01f1a64245b89f039897cb0130016d79f77d52669aae6ee7b159a6c4c018/pyasn1-0.6.1.tar.gz"
    sha256 "6f580d2bdd84365380830acf45550f2511469f673cb4a5ae3857a3170128b034"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/e9/e6/78ebbb10a8c8e4b61a59249394a4a594c1a7af95593dc933a349c8d00964/pyasn1_modules-0.4.2.tar.gz"
    sha256 "677091de870a80aae844b1ca6134f54652fa2c8c5a52aa396440ac3106e941e6"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/f3/1e/4f0a3233767010308f2fd6bd0814597e3f63f1dc98304a9112b8759df4ff/pydantic-2.12.3.tar.gz"
    sha256 "1da1c82b0fc140bb0103bc1441ffe062154c8d38491189751ee00fd8ca65ce74"
  end

  resource "pydantic-settings" do
    url "https://files.pythonhosted.org/packages/20/c5/dbbc27b814c71676593d1c3f718e6cd7d4f00652cefa24b75f7aa3efb25e/pydantic_settings-2.11.0.tar.gz"
    sha256 "d0e87a1c7d33593beb7194adb8470fc426e95ba02af83a0f23474a04c9a08180"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/f2/a5/181488fc2b9d093e3972d2a472855aae8a03f000592dbfce716a512b3359/pyparsing-3.2.5.tar.gz"
    sha256 "2df8d5b7b2802ef88e8d016a2eb9c7aeaa923529cd251ed0fe4608275d4105b6"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/f0/26/19cadc79a718c5edbec86fd4919a6b6d3f681039a2f6d66d14be94e75fb9/python_dotenv-1.2.1.tar.gz"
    sha256 "42667e897e16ab0d66954af0e60a9caa94f0fd4ecf3aaf6d2d260eec1aa36ad6"
  end

  resource "python-multipart" do
    url "https://files.pythonhosted.org/packages/f3/87/f44d7c9f274c7ee665a29b885ec97089ec5dc034c7f3fafa03da9e39a09e/python_multipart-0.0.20.tar.gz"
    sha256 "8dd0cab45b8e23064ae09147625994d090fa46f5b0d1e13af944c331a7fa9d13"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/22/f5/df4e9027acead3ecc63e50fe1e36aca1523e1719559c499951bb4b53188f/referencing-0.37.0.tar.gz"
    sha256 "44aefc3142c5b842538163acb373e24cce6632bd54bdb01b21ad5863489f50d8"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/42/f2/05f29bc3913aea15eb670be136045bf5c5bbf4b99ecb839da9b422bb2c85/requests-oauthlib-2.0.0.tar.gz"
    sha256 "b3dffaebd884d8cd778494369603a9e7b58d29111bf6b41bdc2dcd87203af4e9"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/da/8a/22b7beea3ee0d44b1916c0c1cb0ee3af23b700b6da9f04991899d0c555d4/rsa-4.9.1.tar.gz"
    sha256 "e7bdbfdb5497da4c07dfd35530e1a902659db6ff241e39d9953cad06ebd0ae75"
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
    url "https://files.pythonhosted.org/packages/1b/3f/507c21db33b66fb027a332f2cb3abbbe924cc3a79ced12f01ed8645955c9/starlette-0.49.1.tar.gz"
    sha256 "481a43b71e24ed8c43b11ea02f5353d77840e01480881b8cb5a26b8cae64a8cb"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/55/e3/70399cb7dd41c10ac53367ae42139cf4b1ca5f36bb3dc6c9d33acdb43655/typing_inspection-0.4.2.tar.gz"
    sha256 "ba561c48a67c5958007083d386c3295464928b01faa735ab8547c5692e87f464"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/98/60/f174043244c5306c9988380d2cb10009f91563fc4b31293d27e17201af56/uritemplate-4.2.0.tar.gz"
    sha256 "480c2ed180878955863323eea31b0ede668795de182617fef9c6ca09e6ec9d0e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/cb/ce/f06b84e2697fef4688ca63bdb2fdf113ca0a3be33f94488f2cadb690b0cf/uvicorn-0.38.0.tar.gz"
    sha256 "fd97093bdd120a2609fc0d3afe931d4d4ad688b6e75f0f929fde1bc36fe0e91d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["GOOGLE_APPLICATION_CREDENTIALS"] = testpath/"credentials.json"
    (testpath/"credentials.json").write ""

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output("#{bin}/mcp-google-sheets 2>&1", json, 1)
    assert_match "Error using Application Default Credentials", output
  end
end