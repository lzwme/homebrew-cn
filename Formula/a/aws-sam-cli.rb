class AwsSamCli < Formula
  include Language::Python::Virtualenv

  desc "CLI tool to build, test, debug, and deploy Serverless applications using AWS SAM"
  homepage "https://aws.amazon.com/serverless/sam/"
  url "https://files.pythonhosted.org/packages/e3/17/d3dd17e1b64a50ae1cf04b2a2a39f76169c81ee2fa89f03a83d20644d029/aws_sam_cli-1.146.0.tar.gz"
  sha256 "46369a3f70ee23cb4a4305af7a626d15ef9d3d1322bb17da2fd378e75eb14de4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "46fd44bf5ce85f3fb7165e6acbd205b4c82774d5378f95646c287390f3bf0e4e"
    sha256 cellar: :any,                 arm64_sequoia: "9f0eb4c73b1e3f52d4399a6a66463b250f9625d7edbddbdaf126a78bbf03d4d4"
    sha256 cellar: :any,                 arm64_sonoma:  "383e1317ddada4af0fbe6f6b14293bff5e1fe87a7a29a92eeffc26f415f8bfbb"
    sha256 cellar: :any,                 sonoma:        "575c09a648b392e0252bab05b20ab2cd6e6f98bca69c59983edd5c93f98bdca0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06d7ffef44adb1935120865db2fa9e00984cedba48945ca6d75a37510664a5ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d08bda3efb6a4ba445a129b8103cacd9a5bdca3bdaadb3c7ca931107757b2a1"
  end

  depends_on "pkgconf" => :build
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"
  depends_on "rpds-py" => :no_linkage

  uses_from_macos "libffi"

  pypi_packages exclude_packages: %w[certifi cryptography pydantic rpds-py]

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/b9/33/032cdc44182491aa708d06a68b62434140d8c50820a087fac7af37703357/arrow-1.4.0.tar.gz"
    sha256 "ed0cc050e98001b8779e84d461b0098c4ac597e88704a655582b21d116e526d7"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
  end

  resource "aws-lambda-builders" do
    url "https://files.pythonhosted.org/packages/38/7e/84108e376c3cf8779f2f0757f03e3b9667790236f2b68aa386184d3adff9/aws_lambda_builders-1.59.0.tar.gz"
    sha256 "d863db6b6fcf1377bd6e4b2eb5443874b839ffa65d4cde2b531c8c2120bd99e3"
  end

  resource "aws-sam-translator" do
    url "https://files.pythonhosted.org/packages/e8/7f/db344c656949fa286ff8a14ff2c64355b6ca0cb6ebaf260678041acb8d9c/aws_sam_translator-1.101.0.tar.gz"
    sha256 "234c1ca29d47f2cd276858371d4a646bc5cdb0de1e07724721d9358d6de005aa"
  end

  resource "binaryornot" do
    url "https://files.pythonhosted.org/packages/a7/fe/7ebfec74d49f97fc55cd38240c7a7d08134002b1e14be8c3897c0dd5e49b/binaryornot-0.4.4.tar.gz"
    sha256 "359501dfc9d40632edc9fac890e19542db1a287bbcfa58175b66658392018061"
  end

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/21/28/9b3f50ce0e048515135495f198351908d99540d69bfdc8c1d15b73dc55ce/blinker-1.9.0.tar.gz"
    sha256 "b4ce2265a7abece45e7cc896e98dbebe6cead56bcf805a3d23136d145f5445bf"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/df/3e/6c8ab966798f4e07651009ad08efc3ed4ffccf2662318790574695c740f7/boto3-1.40.68.tar.gz"
    sha256 "c7994989e5bbba071b7c742adfba35773cf03e87f5d3f9f2b0a18c1664417b61"
  end

  resource "boto3-stubs" do
    url "https://files.pythonhosted.org/packages/5f/d2/86697de17c884b95e4d2bb7691e08c32c463cef4ffaf6f6dd034b9f224d8/boto3_stubs-1.40.61.tar.gz"
    sha256 "1837e1c29d79d7a8d096d60235cb89cff9f4142466d9ee310cc1f8562da340ee"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/eb/df/b0300da4cc1fe3e37c8d7a44d835518004454c7d21b579fce9ef2cd691ce/botocore-1.40.68.tar.gz"
    sha256 "28f41b463d9f012a711ee8b61d4e26cd14ee3b450b816d5dee849aa79155e856"
  end

  resource "botocore-stubs" do
    url "https://files.pythonhosted.org/packages/7f/30/588ab9ca87ba6a7ef307cd9941fb7c95abb5820d02bb3f2b818fe5eab4fd/botocore_stubs-1.40.68.tar.gz"
    sha256 "47c8e99e30b1d65ca78be51e6dea994c06c3da9b35521891f8910e641da2b95b"
  end

  resource "cfn-lint" do
    url "https://files.pythonhosted.org/packages/07/32/9355c1309345622aaee6e997e1417dcd2382e05c14e09c49584c4fbe83a7/cfn_lint-1.40.4.tar.gz"
    sha256 "7c8bcf3cf5f2cf8d96fd30fdee1115bfc2480a4c619afc8bce36d551fbb228e1"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "chevron" do
    url "https://files.pythonhosted.org/packages/15/1f/ca74b65b19798895d63a6e92874162f44233467c9e7c1ed8afd19016ebe9/chevron-0.14.0.tar.gz"
    sha256 "87613aafdf6d77b6a90ff073165a61ae5086e21ad49057aa0e53681601800ebf"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "cookiecutter" do
    url "https://files.pythonhosted.org/packages/52/17/9f2cd228eb949a91915acd38d3eecdc9d8893dde353b603f0db7e9f6be55/cookiecutter-2.6.0.tar.gz"
    sha256 "db21f8169ea4f4fdc2408d48ca44859349de2647fbe494a9d6c3edfc0542c21c"
  end

  resource "dateparser" do
    url "https://files.pythonhosted.org/packages/a9/30/064144f0df1749e7bb5faaa7f52b007d7c2d08ec08fed8411aba87207f68/dateparser-1.2.2.tar.gz"
    sha256 "986316f17cb8cdc23ea8ce563027c5ef12fc725b6fb1d137c14ca08777c5ecf7"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/91/9b/4a2ea29aeba62471211598dac5d96825bb49348fa07e906ea930394a83ce/docker-7.1.0.tar.gz"
    sha256 "ad8c70e6e3f8926cb8a92619b832b4ea5299e2831c14284663184e200546fa6c"
  end

  resource "flask" do
    url "https://files.pythonhosted.org/packages/dc/6d/cfe3c0fcc5e477df242b98bfe186a4c34357b4847e87ecaef04507332dab/flask-3.1.2.tar.gz"
    sha256 "bf656c15c80190ed628ad08cdfd3aaa35beb087855e2f494910aa3774cc4fd87"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
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

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/42/78/18813351fe5d63acad16aec57f94ec2b70a09e53ca98145589e185423873/jsonpatch-1.33.tar.gz"
    sha256 "9fcd4009c41e6d12348b4a0ff2563ba56a2923a7dfee731d004e212e1ee5030c"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/6a/0a/eebeb1fa92507ea94016a2a790b93c2ae41a7e18778f85471dc54475ed25/jsonpointer-3.0.0.tar.gz"
    sha256 "2b2d729f2091522d61c3b31f82e11870f60b68f43fbc705cb76bf4b832af59ef"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/74/69/f7185de793a29082a9f3c7728268ffb31cb5095131a9c139a74078e27336/jsonschema-4.25.1.tar.gz"
    sha256 "e4a9655ce0da0c0b67a085847e00a3a51449e1157f4f75e9fb5aa545e122eb85"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "mpmath" do
    url "https://files.pythonhosted.org/packages/e0/47/dd32fa426cc72114383ac549964eecb20ecfd886d1e5ccf5340b55b02f57/mpmath-1.3.0.tar.gz"
    sha256 "7a28eb2a9774d00c7bc92411c19a89209d5da7c4c9a9e227be8330a23a25b91f"
  end

  resource "mypy-boto3-apigateway" do
    url "https://files.pythonhosted.org/packages/51/5b/ef018c33a50af709944bfcccf7f04d7cca5aac5095bd3924ee12c48b3ca9/mypy_boto3_apigateway-1.40.63.tar.gz"
    sha256 "5f6c3191e298bcd0866e01700368d64ab01d3e0e4f73b5c23af4daba26652da4"
  end

  resource "mypy-boto3-cloudformation" do
    url "https://files.pythonhosted.org/packages/12/54/8b3dbd022d8601db51708ff0f69e1383f16bd7e50446a4b3090406750388/mypy_boto3_cloudformation-1.40.57.tar.gz"
    sha256 "fc951f5891fa345b5256973f38a8436d80a4289c5c621d52fe9cb7bf64348b7e"
  end

  resource "mypy-boto3-ecr" do
    url "https://files.pythonhosted.org/packages/28/fc/c47f5a6dbeed692c70d99b9d1c14f04bd9c5b0eaa87959e021ae86261411/mypy_boto3_ecr-1.40.58.tar.gz"
    sha256 "3191a420ec4df1ecb5d2bdc2a4de2e97e983dffae9c4e138c2aa4d283912a985"
  end

  resource "mypy-boto3-iam" do
    url "https://files.pythonhosted.org/packages/6b/01/99e4ac4f59bbcb1246a3f15b30117f1ece9acdb26751e762e6929a526726/mypy_boto3_iam-1.40.60.tar.gz"
    sha256 "8ade5e06096f591e76ae0c72615e58e10d57780767b0e469161799dd92dfa02a"
  end

  resource "mypy-boto3-kinesis" do
    url "https://files.pythonhosted.org/packages/7e/cc/f178e14e7fadc9bb24c604a725d5ffc387bcba517fe6007bfa6e0474a203/mypy_boto3_kinesis-1.40.64.tar.gz"
    sha256 "e60fca2c1ebd143f7f9688dd6794b7bd63ee1c181d3a3cab5f1c8387445977c9"
  end

  resource "mypy-boto3-lambda" do
    url "https://files.pythonhosted.org/packages/04/fb/04b8477be870722593b56e57c458f83a00c7357f07cdb8254c8aa6d5f042/mypy_boto3_lambda-1.40.64.tar.gz"
    sha256 "c38c68c83d7012661c9f5579ce3360d89e59c5ee3941f7c22accfda90d14091f"
  end

  resource "mypy-boto3-s3" do
    url "https://files.pythonhosted.org/packages/a8/1e/27cebe8c95fa9899f4e4ee5f4d3d15fe946ca2dfac43470bc427069f30c4/mypy_boto3_s3-1.40.61.tar.gz"
    sha256 "2655db143cae37fbc68b53aae34fbc5c904925d04b0f263ae7c38fb560b6a85f"
  end

  resource "mypy-boto3-schemas" do
    url "https://files.pythonhosted.org/packages/61/3a/965e0be1d8f0186d969e323df8a37c8e5853fd9a8bf2f75fa696876e4b48/mypy_boto3_schemas-1.40.63.tar.gz"
    sha256 "415d2a311f0d7610f1e16477a244c6a58be4a2c65f0f742c9667a0bef3f2bd94"
  end

  resource "mypy-boto3-secretsmanager" do
    url "https://files.pythonhosted.org/packages/39/59/d2a4c5935a6feb1e9f036106aa8c972e07d117df01c984ad6ca42d0b7efc/mypy_boto3_secretsmanager-1.40.60.tar.gz"
    sha256 "286c77f528b85a87851ec313b9daf71e6bbf79a7d2b1d0d7607dab7547436c61"
  end

  resource "mypy-boto3-signer" do
    url "https://files.pythonhosted.org/packages/38/8a/dbd8aa981b72b4481441d2f7c0e4d21522b6b0aec3d296cf05d6b2966147/mypy_boto3_signer-1.40.55.tar.gz"
    sha256 "07ad05fd0d8594bb8d08666ec5267703d41200c14c80538ed0014bce64ddca85"
  end

  resource "mypy-boto3-sqs" do
    url "https://files.pythonhosted.org/packages/f0/af/23331e9b9ae0e317efca924e7a2aabb8142835b4ae8322bc1ffdb0249cbd/mypy_boto3_sqs-1.40.61.tar.gz"
    sha256 "16d34db653dcf28618b4e422ae32eb2d34f3f937dcee5edd4ca4de3ddb9c3857"
  end

  resource "mypy-boto3-stepfunctions" do
    url "https://files.pythonhosted.org/packages/b7/1b/11492756266bc428208797511da37979828ce46a44b23d27de32c7872e35/mypy_boto3_stepfunctions-1.40.60.tar.gz"
    sha256 "cc337ea66a6d523abd0a773a53b9a65aa6ade8f8925b12626e012e62ad4ff7a4"
  end

  resource "mypy-boto3-sts" do
    url "https://files.pythonhosted.org/packages/8c/17/a17c90ab4c9d2f19fc26b1002746104a20cef61e148c8fe7b87b91d1af3f/mypy_boto3_sts-1.40.63.tar.gz"
    sha256 "3b74ecc506700eb0502993f624caaa286559e35ec7e05ad38ee3f1751e0a0a24"
  end

  resource "mypy-boto3-xray" do
    url "https://files.pythonhosted.org/packages/0c/a5/516493bad1bc11b15a2b43c2c98be0d4ed7e3e7a1a72f79388576b5670e7/mypy_boto3_xray-1.40.61.tar.gz"
    sha256 "14402542efbd1a175daf8a5e10eeb36e11ccf4b37afda259ffeb5d30a1c7f1b3"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/6c/4f/ccdb8ad3a38e583f214547fd2f7ff1fc160c43a75af88e6aec213404b96a/networkx-3.5.tar.gz"
    sha256 "d4c6f9cf81f52d69230866796b82afbccdec3db7ae4fbd1b65ea750feed50037"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/80/be/97b83a464498a79103036bc74d1038df4a7ef0e402cfaf4d5e113fb14759/pyopenssl-25.3.0.tar.gz"
    sha256 "c981cb0a3fd84e8602d7afc209522773b94c1c2446a3c710a75b06fe1beae329"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-slugify" do
    url "https://files.pythonhosted.org/packages/87/c7/5e1547c44e31da50a460df93af11a535ace568ef89d7a811069ead340c4a/python-slugify-8.0.4.tar.gz"
    sha256 "59202371d1d05b54a9e7720c5e038f928f45daaffe41dd10822f3907b937c856"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/f8/bf/abbd3cdfb8fbc7fb3d4d38d320f2441b1e7cbe29be4f23797b4a2b5d8aac/pytz-2025.2.tar.gz"
    sha256 "360b9e3dbb49a209c21ad61809c7fb453643e048b38924c765813546746e81c3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/22/f5/df4e9027acead3ecc63e50fe1e36aca1523e1719559c499951bb4b53188f/referencing-0.37.0.tar.gz"
    sha256 "44aefc3142c5b842538163acb373e24cce6632bd54bdb01b21ad5863489f50d8"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/cc/a9/546676f25e573a4cf00fe8e119b78a37b6a8fe2dc95cda877b30889c9c45/regex-2025.11.3.tar.gz"
    sha256 "1fedc720f9bb2494ce31a58a1631f9c82df6a09b49c19517ea5cc280b4541e01"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/fb/d2/8920e102050a0de7bfabeb4c4614a49248cf8d5d7a8d01885fbb24dc767a/rich-14.2.0.tar.gz"
    sha256 "73ff50c7c0c1c77c8243079283f4edb376f0f6442433aecb8ce7e6d0b92d1fe4"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/9f/c7/ee630b29e04a672ecfc9b63227c87fd7a37eb67c1bf30fe95376437f897c/ruamel.yaml-0.18.16.tar.gz"
    sha256 "a6e587512f3c998b2225d68aa1f35111c29fad14aed561a26e73fab729ec5e5a"
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

  resource "text-unidecode" do
    url "https://files.pythonhosted.org/packages/ab/e2/e9a00f0ccb71718418230718b3d900e71a5d16e701a3dae079a21e9cd8f8/text-unidecode-1.3.tar.gz"
    sha256 "bad6603bb14d279193107714b288be206cac565dfa49aa5b105294dd5c4aab93"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/cc/18/0bbf3884e9eaa38819ebe46a7bd25dcd56b67434402b66a58c4b8e552575/tomlkit-0.13.3.tar.gz"
    sha256 "430cf247ee57df2b94ee3fbe588e71d362a941ebb545dec29b53961d61add2a1"
  end

  resource "types-awscrt" do
    url "https://files.pythonhosted.org/packages/86/65/f92debc7c9ff9e6e51cf1495248f0edd2fa7123461acf5d07ec1688d8ac1/types_awscrt-0.28.2.tar.gz"
    sha256 "4349b6fc7b1cd9c9eb782701fb213875db89ab1781219c0e947dd7c4d9dcd65e"
  end

  resource "types-s3transfer" do
    url "https://files.pythonhosted.org/packages/8e/9b/8913198b7fc700acc1dcb84827137bb2922052e43dde0f4fb0ed2dc6f118/types_s3transfer-0.14.0.tar.gz"
    sha256 "17f800a87c7eafab0434e9d87452c809c290ae906c2024c24261c564479e9c95"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/95/32/1a225d6164441be760d75c2c42e2780dc0873fe382da3e98a2e1e48361e5/tzdata-2025.2.tar.gz"
    sha256 "b60a638fcc0daffadf82fe0f57e53d06bdec2f36c4df66280ae79bce6bd6f2b9"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/8b/2e/c14812d3d4d9cd1773c6be938f89e5735a1f11a9f184ac3639b93cef35d5/tzlocal-5.3.1.tar.gz"
    sha256 "cceffc7edecefea1f595541dbd6e990cb1ea3d19bf01b2809f362a03dd7921fd"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "watchdog" do
    url "https://files.pythonhosted.org/packages/4f/38/764baaa25eb5e35c9a043d4c4588f9836edfe52a708950f4b6d5f714fd42/watchdog-4.0.2.tar.gz"
    sha256 "b4dfbb6c49221be4535623ea4474a4d6ee0a9cef4a80b20c28db4d858b64e270"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/9f/69/83029f1f6300c5fb2471d621ab06f6ec6b3324685a2ce0f9777fd4a8b71e/werkzeug-3.1.3.tar.gz"
    sha256 "60723ce945c19328679790e3282cc758aa4a6040e4bb330f53d30fa546d44746"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/8a/98/2d9906746cdc6a6ef809ae6338005b3f21bb568bea3165cfc6a243fdc25c/wheel-0.45.1.tar.gz"
    sha256 "661e1abd9198507b1409a20c02106d9670b2576e916d58f520316666abca6729"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"sam", shell_parameter_format: :click)
  end

  test do
    output = shell_output("#{bin}/sam validate 2>&1", 1)
    assert_match "SAM Template Not Found", output

    assert_match version.to_s, shell_output("#{bin}/sam --version")
  end
end