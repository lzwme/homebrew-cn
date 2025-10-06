class Moto < Formula
  include Language::Python::Virtualenv

  desc "Mock AWS services"
  homepage "http://getmoto.org/"
  url "https://files.pythonhosted.org/packages/c0/d9/ec94955a1b14ef45ccbda81f2256b30bf1f21ae5c5739fca14130bb1f048/moto-5.1.14.tar.gz"
  sha256 "450690abb0b152fea7f93e497ac2172f15d8a838b15f22b514db801a6b857ae4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "41310ad586d9d86f59456c565320a1a0ada128fc7ccbd46c5673de2d4583c8b9"
    sha256 cellar: :any,                 arm64_sequoia: "9ece5603ba195a3d478e84477b88b49ffacb8881ed64051eaaf05c2d8b32b489"
    sha256 cellar: :any,                 arm64_sonoma:  "0fed701d6293c290f25d9cd6f4aca8d26fb2c0c4d2d496978ee4d0139ee08918"
    sha256 cellar: :any,                 sonoma:        "887e1592c7923bd2ff019f4cdee8ed3cb7be4de6b8095e56cc3fe179351db5ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "056ba48447919abd236ea457ce8c4bc2a62a694307c6752292a778362caae15c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "490bda48c917817ca015e436a0c735c19b0dfb9589421f1810d2827da61e36a9"
  end

  depends_on "rust" => :build # for pydantic_core
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "antlr4-python3-runtime" do
    url "https://files.pythonhosted.org/packages/33/5f/2cdf6f7aca3b20d3f316e9f505292e1f256a32089bd702034c29ebde6242/antlr4_python3_runtime-4.13.2.tar.gz"
    sha256 "909b647e1d2fc2b70180ac586df3933e38919c85f98ccc656a96cd3f25ef3916"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/5a/b0/1367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24/attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "aws-sam-translator" do
    url "https://files.pythonhosted.org/packages/0b/63/2f0ef6d6612a16e8eb293d4724d9cdd07b713677d66999dfc93e084ebc87/aws_sam_translator-1.100.0.tar.gz"
    sha256 "be4fb7eef864c971eb305af09de8e4e0bfe98a4eca122a00c069f6346aa00410"
  end

  resource "aws-xray-sdk" do
    url "https://files.pythonhosted.org/packages/e0/6c/8e7fb2a45f20afc5c19d52807b560793fb48b0feca1de7de116b62a7893e/aws_xray_sdk-2.14.0.tar.gz"
    sha256 "aab843c331af9ab9ba5cefb3a303832a19db186140894a523edafc024cc0493c"
  end

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/21/28/9b3f50ce0e048515135495f198351908d99540d69bfdc8c1d15b73dc55ce/blinker-1.9.0.tar.gz"
    sha256 "b4ce2265a7abece45e7cc896e98dbebe6cead56bcf805a3d23136d145f5445bf"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/19/22/97605e64b8661a13f1dd9412c7989b3d78673bc79d91ca61d8237e90b503/boto3-1.40.45.tar.gz"
    sha256 "e8d794dc1f01729d93dc188c90cf63cd0d32df8818a82ac46e641f6ffcea615e"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/0e/19/6c85d5523dd05e060d182cd0e7ce82df60ab738d18b1c8ee2202e4ca02b9/botocore-1.40.45.tar.gz"
    sha256 "cf8b743527a2a7e108702d24d2f617e93c6dc7ae5eb09aadbe866f15481059df"
  end

  resource "cfn-lint" do
    url "https://files.pythonhosted.org/packages/e2/0c/a395e0f9989b778bae6acb1dc8c57f4f2632a8f3c669144ba206e780f095/cfn_lint-1.40.0.tar.gz"
    sha256 "ec3aedb928f04501c99742d8585251aeac073799823c60f2660f96acb9830987"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/83/2d/5fd176ceb9b2fc619e63405525573493ca23441330fcdaee6bef9460e924/charset_normalizer-3.4.3.tar.gz"
    sha256 "6fce4b8500244f6fcb71465d4a4930d132ba9ab8e71a7859e6a5d59851068d14"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/46/61/de6cd827efad202d7057d93e0fed9294b96952e188f7384832791c7b2254/click-8.3.0.tar.gz"
    sha256 "e7b8232224eba16f4ebe410c25ced9f7875cb5f3263ffc93cc3e8da705e229c4"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/91/9b/4a2ea29aeba62471211598dac5d96825bb49348fa07e906ea930394a83ce/docker-7.1.0.tar.gz"
    sha256 "ad8c70e6e3f8926cb8a92619b832b4ea5299e2831c14284663184e200546fa6c"
  end

  resource "flask" do
    url "https://files.pythonhosted.org/packages/dc/6d/cfe3c0fcc5e477df242b98bfe186a4c34357b4847e87ecaef04507332dab/flask-3.1.2.tar.gz"
    sha256 "bf656c15c80190ed628ad08cdfd3aaa35beb087855e2f494910aa3774cc4fd87"
  end

  resource "flask-cors" do
    url "https://files.pythonhosted.org/packages/76/37/bcfa6c7d5eec777c4c7cf45ce6b27631cebe5230caf88d85eadd63edd37a/flask_cors-6.0.1.tar.gz"
    sha256 "d81bcb31f07b0985be7f48406247e9243aced229b7747219160a0559edd678db"
  end

  resource "graphql-core" do
    url "https://files.pythonhosted.org/packages/c4/16/7574029da84834349b60ed71614d66ca3afe46e9bf9c7b9562102acb7d4f/graphql_core-3.2.6.tar.gz"
    sha256 "c08eec22f9e40f0bd61d805907e3b3b1b9a320bc606e23dc145eebca07c8fbab"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/9c/cb/8ac0172223afbccb63986cc25049b154ecfb5e85932587206f42317be31d/itsdangerous-2.2.0.tar.gz"
    sha256 "e0050c0b7da1eea53ffaf149c0cfbb5c6e2e2b69c4bef22c81fa6eb73e5f6173"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "joserfc" do
    url "https://files.pythonhosted.org/packages/b0/79/d63a882c0212e95f3ba8863a115e5ca9a5d39413b02273ddce72058e717f/joserfc-1.3.4.tar.gz"
    sha256 "67d8413c501c239f65eefad5ae685cfbfc401aa63289fc409ef7cc331b007227"
  end

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/42/78/18813351fe5d63acad16aec57f94ec2b70a09e53ca98145589e185423873/jsonpatch-1.33.tar.gz"
    sha256 "9fcd4009c41e6d12348b4a0ff2563ba56a2923a7dfee731d004e212e1ee5030c"
  end

  resource "jsonpath-ng" do
    url "https://files.pythonhosted.org/packages/6d/86/08646239a313f895186ff0a4573452038eed8c86f54380b3ebac34d32fb2/jsonpath-ng-1.7.0.tar.gz"
    sha256 "f6f5f7fd4e5ff79c785f1573b394043b39849fb2bb47bcead935d12b00beab3c"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/6a/0a/eebeb1fa92507ea94016a2a790b93c2ae41a7e18778f85471dc54475ed25/jsonpointer-3.0.0.tar.gz"
    sha256 "2b2d729f2091522d61c3b31f82e11870f60b68f43fbc705cb76bf4b832af59ef"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/74/69/f7185de793a29082a9f3c7728268ffb31cb5095131a9c139a74078e27336/jsonschema-4.25.1.tar.gz"
    sha256 "e4a9655ce0da0c0b67a085847e00a3a51449e1157f4f75e9fb5aa545e122eb85"
  end

  resource "jsonschema-path" do
    url "https://files.pythonhosted.org/packages/6e/45/41ebc679c2a4fced6a722f624c18d658dee42612b83ea24c1caf7c0eb3a8/jsonschema_path-0.3.4.tar.gz"
    sha256 "8365356039f16cc65fddffafda5f58766e34bebab7d6d105616ab52bc4297001"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "lazy-object-proxy" do
    url "https://files.pythonhosted.org/packages/08/a2/69df9c6ba6d316cfd81fe2381e464db3e6de5db45f8c43c6a23504abf8cb/lazy_object_proxy-1.12.0.tar.gz"
    sha256 "1f5a462d92fd0cfb82f1fab28b51bfb209fabbe6aabf7f0d51472c0c124c0c61"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "mpmath" do
    url "https://files.pythonhosted.org/packages/e0/47/dd32fa426cc72114383ac549964eecb20ecfd886d1e5ccf5340b55b02f57/mpmath-1.3.0.tar.gz"
    sha256 "7a28eb2a9774d00c7bc92411c19a89209d5da7c4c9a9e227be8330a23a25b91f"
  end

  resource "multipart" do
    url "https://files.pythonhosted.org/packages/6d/c9/c6f5ab81bae667d4fe42a58df29f4c2db6ad8377cfd0e9baa729e4fa3ebb/multipart-1.3.0.tar.gz"
    sha256 "a46bd6b0eb4c1ba865beb88ddd886012a3da709b6e7b86084fc37e99087e5cf1"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/6c/4f/ccdb8ad3a38e583f214547fd2f7ff1fc160c43a75af88e6aec213404b96a/networkx-3.5.tar.gz"
    sha256 "d4c6f9cf81f52d69230866796b82afbccdec3db7ae4fbd1b65ea750feed50037"
  end

  resource "openapi-schema-validator" do
    url "https://files.pythonhosted.org/packages/8b/f3/5507ad3325169347cd8ced61c232ff3df70e2b250c49f0fe140edb4973c6/openapi_schema_validator-0.6.3.tar.gz"
    sha256 "f37bace4fc2a5d96692f4f8b31dc0f8d7400fd04f3a937798eaf880d425de6ee"
  end

  resource "openapi-spec-validator" do
    url "https://files.pythonhosted.org/packages/82/af/fe2d7618d6eae6fb3a82766a44ed87cd8d6d82b4564ed1c7cfb0f6378e91/openapi_spec_validator-0.7.2.tar.gz"
    sha256 "cc029309b5c5dbc7859df0372d55e9d1ff43e96d678b9ba087f7c56fc586f734"
  end

  resource "pathable" do
    url "https://files.pythonhosted.org/packages/67/93/8f2c2075b180c12c1e9f6a09d1a985bc2036906b13dff1d8917e395f2048/pathable-0.4.4.tar.gz"
    sha256 "6905a3cd17804edfac7875b5f6c9142a218c7caef78693c2dbbbfbac186d88b2"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  resource "py-partiql-parser" do
    url "https://files.pythonhosted.org/packages/58/a1/0a2867e48b232b4f82c4929ef7135f2a5d72c3886b957dccf63c70aa2fcb/py_partiql_parser-0.6.1.tar.gz"
    sha256 "8583ff2a0e15560ef3bc3df109a7714d17f87d81d33e8c38b7fed4e58a63215d"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/ae/54/ecab642b3bed45f7d5f59b38443dcb36ef50f85af192e6ece103dbfe9587/pydantic-2.11.10.tar.gz"
    sha256 "dc280f0982fbda6c38fada4e476dc0a4f3aeaf9c6ad4c28df68a666ec3c61423"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/ad/88/5f2260bdfae97aabf98f1778d43f69574390ad787afb646292a638c923d4/pydantic_core-2.33.2.tar.gz"
    sha256 "7cb8bc3605c29176e1b105350d2e6474142d7c1bd1d9327c4a9bdb46bf827acc"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/f2/a5/181488fc2b9d093e3972d2a472855aae8a03f000592dbfce716a512b3359/pyparsing-3.2.5.tar.gz"
    sha256 "2df8d5b7b2802ef88e8d016a2eb9c7aeaa923529cd251ed0fe4608275d4105b6"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/2f/db/98b5c277be99dd18bfd91dd04e1b759cad18d1a338188c936e92f921c7e2/referencing-0.36.2.tar.gz"
    sha256 "df2e89862cd09deabbdba16944cc3f10feb6b3e6f18e902f7cc25609a34775aa"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/49/d3/eaa0d28aba6ad1827ad1e716d9a93e1ba963ada61887498297d3da715133/regex-2025.9.18.tar.gz"
    sha256 "c5ba23274c61c6fef447ba6a39333297d0c247f53059dba0bca415cac511edc4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "responses" do
    url "https://files.pythonhosted.org/packages/0e/95/89c054ad70bfef6da605338b009b2e283485835351a9935c7bfbfaca7ffc/responses-0.25.8.tar.gz"
    sha256 "9374d047a575c8f781b94454db5cab590b6029505f488d12899ddb10a4af1cf4"
  end

  resource "rfc3339-validator" do
    url "https://files.pythonhosted.org/packages/28/ea/a9387748e2d111c3c2b275ba970b735e04e15cdb1eb30693b6b5708c4dbd/rfc3339_validator-0.1.4.tar.gz"
    sha256 "138a2abdf93304ad60530167e51d2dfb9549521a836871b88d7f4695d0022f6b"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/e9/dd/2c0cbe774744272b0ae725f44032c77bdcab6e8bcf544bffa3b6e70c8dba/rpds_py-0.27.1.tar.gz"
    sha256 "26a1c73171d10b7acccbded82bf6a586ab8203601e565badc74bbbf8bc5a10f8"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/62/74/8d69dcb7a9efe8baa2046891735e5dfe433ad558ae23d9e3c14c633d1d58/s3transfer-0.14.0.tar.gz"
    sha256 "eff12264e7c8b4985074ccce27a3b38a485bb7f7422cc8046fee9be4983e4125"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sympy" do
    url "https://files.pythonhosted.org/packages/83/d3/803453b36afefb7c2bb238361cd4ae6125a569b4db67cd9e79846ba2d68c/sympy-1.14.0.tar.gz"
    sha256 "d3d3fe8df1e5a0b42f0e7bdf50541697dbe7d23746e894990c030e2b05e72517"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/55/e3/70399cb7dd41c10ac53367ae42139cf4b1ca5f36bb3dc6c9d33acdb43655/typing_inspection-0.4.2.tar.gz"
    sha256 "ba561c48a67c5958007083d386c3295464928b01faa735ab8547c5692e87f464"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/9f/69/83029f1f6300c5fb2471d621ab06f6ec6b3324685a2ce0f9777fd4a8b71e/werkzeug-3.1.3.tar.gz"
    sha256 "60723ce945c19328679790e3282cc758aa4a6040e4bb330f53d30fa546d44746"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/95/8f/aeb76c5b46e273670962298c23e7ddde79916cb74db802131d49a85e4b7d/wrapt-1.17.3.tar.gz"
    sha256 "f66eb08feaa410fe4eebd17f2a2c8e2e46d3476e9f8c783daa8e09e0faa666d0"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/6a/aa/917ceeed4dbb80d2f04dbd0c784b7ee7bba8ae5a54837ef0e5e062cd3cfb/xmltodict-1.0.2.tar.gz"
    sha256 "54306780b7c2175a3967cad1db92f218207e5bc1aba697d887807c0fb68b7649"
  end

  def python3
    which("python3.13")
  end

  def install
    virtualenv_install_with_resources
  end

  service do
    run [opt_bin/"moto_server"]
    keep_alive true
    working_dir var
    log_path var/"log/moto.log"
    error_log_path var/"log/moto.log"
  end

  test do
    port = free_port
    pid = fork do
      exec bin/"moto_server", "--port=#{port}"
    end

    expected_output = <<~XML
      <ListAllMyBucketsResult xmlns="http://s3.amazonaws.com/doc/2006-03-01"><Owner><ID>bcaf1ffd86f41161ca5fb16fd081034f</ID><DisplayName>webfile</DisplayName></Owner><Buckets></Buckets></ListAllMyBucketsResult>
    XML
    assert_equal expected_output.strip, shell_output("curl --silent --retry 5 --retry-connrefused 127.0.0.1:#{port}/")
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end