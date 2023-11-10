class AwsSamCli < Formula
  include Language::Python::Virtualenv

  desc "CLI tool to build, test, debug, and deploy Serverless applications using AWS SAM"
  homepage "https://aws.amazon.com/serverless/sam/"
  url "https://files.pythonhosted.org/packages/e1/44/a80c7edfa5c68e4d04a666212564b37c8eb3945b043609a6a0866c8c394f/aws-sam-cli-1.101.0.tar.gz"
  sha256 "6121033c182dd9e597b0808cae55725a497957a6f61657810008ab6083171323"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "99bee95a8194d52f287f58f21dfadb0f7d8e1d1b96445b1b62becac2eb547fff"
    sha256 cellar: :any,                 arm64_ventura:  "aac3f77953e46e77151294c71dd481adca2b6bc2b8e2fca69871915914ff9c1c"
    sha256 cellar: :any,                 arm64_monterey: "3015479c5ffa84cd10223c91d3c6ec399324658f70c3a0f64b001d68b78abdad"
    sha256 cellar: :any,                 sonoma:         "ca157e2f93f05203eb434f2d3ec186f5bd5c6fa4c64aa7739189ae2f9bcbd5d0"
    sha256 cellar: :any,                 ventura:        "12c91294724ab35581e9bb655cdfc35a38cb94b4c70118e2d519a29b8bad1d20"
    sha256 cellar: :any,                 monterey:       "e468d3d6c7d6898b244bbbd6203d8df870c2ff5220d4fcec6cd13e92e097d565"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c265fde773e04c2200ded93b01ab77e22ca03bcd3a6a2d8ace31ac725dedaa1"
  end

  depends_on "rust" => :build # for rpds-py
  depends_on "cffi"
  depends_on "pycparser"
  depends_on "pygments"
  depends_on "python-certifi"
  depends_on "python-cryptography"
  depends_on "python-packaging"
  depends_on "python-pytz"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/67/fe/8c7b275824c6d2cd17c93ee85d0ee81c090285b6d52f4876ccc47cf9c3c4/annotated_types-0.6.0.tar.gz"
    sha256 "563339e807e53ffd9c267e99fc6d9ea23eb8443c08f112651963e24e22f84a5d"
  end

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/2e/00/0f6e8fcdb23ea632c866620cc872729ff43ed91d284c866b515c6342b173/arrow-1.3.0.tar.gz"
    sha256 "d4540617648cb5f895730f1ad8c82a65f2dad0166f57b75f3ca54759c4d67a85"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "aws-lambda-builders" do
    url "https://files.pythonhosted.org/packages/e5/a8/44338c67afea22fbf302b6f3b66a42135b0383de158beb6d6012b5b590f5/aws_lambda_builders-1.40.0.tar.gz"
    sha256 "a48f083f750d62d5a5cf0bac1fe224682b5ed83dd821d794802c791ec22e077b"
  end

  resource "aws-sam-translator" do
    url "https://files.pythonhosted.org/packages/79/3d/7168d757744fc624115a9fbfd9a8b387bf94db6077a1f831c2792d84b8b2/aws-sam-translator-1.79.0.tar.gz"
    sha256 "990f3043d00b6fd801b38ad780ecd058c315b7581b2e43fc013c9b6253f876e8"
  end

  resource "binaryornot" do
    url "https://files.pythonhosted.org/packages/a7/fe/7ebfec74d49f97fc55cd38240c7a7d08134002b1e14be8c3897c0dd5e49b/binaryornot-0.4.4.tar.gz"
    sha256 "359501dfc9d40632edc9fac890e19542db1a287bbcfa58175b66658392018061"
  end

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/a1/13/6df5fc090ff4e5d246baf1f45fe9e5623aa8565757dfa5bd243f6a545f9e/blinker-1.7.0.tar.gz"
    sha256 "e6820ff6fa4e4d1d8e2747c2283749c3f547e4fee112b98555cdcdae32996182"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/21/98/3c48312b9008f89116ad3e5f435649a242ca63624175a162c2759aa74507/boto3-1.28.83.tar.gz"
    sha256 "489c4967805b677b7a4030460e4c06c0903d6bc0f6834453611bf87efbd8d8a3"
  end

  resource "boto3-stubs" do
    url "https://files.pythonhosted.org/packages/66/53/ddb29650ffac8743fcf95ad1214f690b6792ea9dea6a4794160dd03ae815/boto3-stubs-1.28.80.tar.gz"
    sha256 "544bcf2e1c32f34ca445948d7594af37325704476765c01bf5934cedc8efd8bc"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/8c/07/b8485712b1c4c12fc27575ac04e8db2f9a7ed171b2a960950275a8adcdce/botocore-1.31.83.tar.gz"
    sha256 "40914b0fb28f13d709e1f8a4481e278350b77a3987be81acd23715ec8d5fedca"
  end

  resource "botocore-stubs" do
    url "https://files.pythonhosted.org/packages/e4/0d/be712b2319b7fe4e97d2e1c4a14e9d6e0704e4ba13c33854f39ca68f99cd/botocore_stubs-1.31.83.tar.gz"
    sha256 "b79220731c6d5c377a56e6c8afbaecf52b425646233ab8c8b7221699cf81e0bd"
  end

  resource "cfn-lint" do
    url "https://files.pythonhosted.org/packages/ba/a6/f708a4c4bfafd9a8769137a20cdb2374142bf971597bcb4ce7625528dad6/cfn-lint-0.83.1.tar.gz"
    sha256 "9629138f98d83898c7ffc63f67a3106af67f267d6cee7943253f1f813655293d"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "chevron" do
    url "https://files.pythonhosted.org/packages/15/1f/ca74b65b19798895d63a6e92874162f44233467c9e7c1ed8afd19016ebe9/chevron-0.14.0.tar.gz"
    sha256 "87613aafdf6d77b6a90ff073165a61ae5086e21ad49057aa0e53681601800ebf"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "cookiecutter" do
    url "https://files.pythonhosted.org/packages/48/7e/5d9dba54ddd4301f2e50e857b9aea01dd8312f97eb87cd690817ee3bc421/cookiecutter-2.4.0.tar.gz"
    sha256 "6d1494e66a784f23324df9d593f3e43af3db4f4b926b9e49e6ff060169fc042a"
  end

  resource "dateparser" do
    url "https://files.pythonhosted.org/packages/7e/16/e95f1d2f8014bac38e00d037e192222e52de7db7c71268ed3b2e12d4893c/dateparser-1.1.8.tar.gz"
    sha256 "86b8b7517efcc558f085a142cdb7620f0921543fcabdb538c8a4c4001d8178e3"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/f0/73/f7c9a14e88e769f38cb7fb45aa88dfd795faa8e18aea11bababf6e068d5e/docker-6.1.3.tar.gz"
    sha256 "aa6d17830045ba5ef0168d5eaa34d37beeb113948c413affe1d5991fc11f9a20"
  end

  resource "flask" do
    url "https://files.pythonhosted.org/packages/d8/09/c1a7354d3925a3c6c8cfdebf4245bae67d633ffda1ba415add06ffc839c5/flask-3.0.0.tar.gz"
    sha256 "cfadcdb638b609361d29ec22360d6070a77d7463dcb3ab08d2c2f2f168845f58"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/7f/a1/d3fb83e7a61fa0c0d3d08ad0a94ddbeff3731c05212617dff3a94e097f08/itsdangerous-2.1.2.tar.gz"
    sha256 "5dbbc68b317e5e42f327f9021763545dc3fc3bfe22e6deb96aaf1fc38874156a"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "jschema-to-python" do
    url "https://files.pythonhosted.org/packages/1d/7f/5ae3d97ddd86ec33323231d68453afd504041efcfd4f4dde993196606849/jschema_to_python-1.2.3.tar.gz"
    sha256 "76ff14fe5d304708ccad1284e4b11f96a658949a31ee7faed9e0995279549b91"
  end

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/42/78/18813351fe5d63acad16aec57f94ec2b70a09e53ca98145589e185423873/jsonpatch-1.33.tar.gz"
    sha256 "9fcd4009c41e6d12348b4a0ff2563ba56a2923a7dfee731d004e212e1ee5030c"
  end

  resource "jsonpickle" do
    url "https://files.pythonhosted.org/packages/6e/92/62fdc2f6b468b870dd171ad21748ef0ec2bff1b258c25ce6db3545cccc90/jsonpickle-3.0.2.tar.gz"
    sha256 "e37abba4bfb3ca4a4647d28bb9f4706436f7b46c8a8333b4a718abafa8e46b37"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/8f/5e/67d3ab449818b629a0ffe554bb7eb5c030a71f7af5d80fbf670d7ebe62bc/jsonpointer-2.4.tar.gz"
    sha256 "585cee82b70211fa9e6043b7bb89db6e1aa49524340dde8ad6b63206ea689d88"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/95/18/618159fb2efbe3fb2cd32b16c40278954cde94744957734ef0482286a052/jsonschema-4.19.2.tar.gz"
    sha256 "c9ff4d7447eed9592c23a12ccee508baf0dd0d59650615e847feb6cdca74f392"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/12/ce/eb5396b34c28cbac19a6a8632f0e03d309135d77285536258b82120198d8/jsonschema_specifications-2023.7.1.tar.gz"
    sha256 "c91a50404e88a1f6ba40636778e2ee08f6e24c5613fe4c53ac24578a5a7f72bb"
  end

  resource "junit-xml" do
    url "https://files.pythonhosted.org/packages/98/af/bc988c914dd1ea2bc7540ecc6a0265c2b6faccc6d9cdb82f20e2094a8229/junit-xml-1.9.tar.gz"
    sha256 "de16a051990d4e25a3982b2dd9e89d671067548718866416faec14d9de56db9f"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/6d/7c/59a3248f411813f8ccba92a55feaac4bf360d29e2ff05ee7d8e1ef2d7dbf/MarkupSafe-2.1.3.tar.gz"
    sha256 "af598ed32d6ae86f1b747b82783958b1a4ab8f617b06fe68795c7f026abbdcad"
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
    url "https://files.pythonhosted.org/packages/e2/5a/8e9af94dca5d4766b23cd97eae8b648f70eea78809191795a5ca4b57099c/mypy-boto3-apigateway-1.28.36.tar.gz"
    sha256 "e460e5b40b28fbe292f842993e7bf3ad514d0073774b30f1c5e137de6abac681"
  end

  resource "mypy-boto3-cloudformation" do
    url "https://files.pythonhosted.org/packages/a4/d2/a8ac3ee9c4cd717750f0c6d6da3b36f2d50c237c93db40485bb7859e2cae/mypy-boto3-cloudformation-1.28.83.tar.gz"
    sha256 "a5d9eb52b32f49b0f9c8343365699bae08a1f5daf725b47c2761c2c8153e559c"
  end

  resource "mypy-boto3-ecr" do
    url "https://files.pythonhosted.org/packages/00/8d/29ae794c78ff339231583aabc6fd021b1782eae2cc4ec4ea3e1b8d750f99/mypy-boto3-ecr-1.28.45.tar.gz"
    sha256 "3584a19a018bacd7b6e8147bc9ef6932967815c0918c6cf3929ff55f1c9be601"
  end

  resource "mypy-boto3-iam" do
    url "https://files.pythonhosted.org/packages/14/48/4d0ca1b50ec188567cbc568ac2e61b3d4eb3194311fde3504b364cdfc05a/mypy-boto3-iam-1.28.79.tar.gz"
    sha256 "b5f8bce0d34966c917445e002c51c7e0cde553bfa62f44b131ceb52d82fec45e"
  end

  resource "mypy-boto3-kinesis" do
    url "https://files.pythonhosted.org/packages/91/be/d10c82251a0032a296910f6459a12e6aaf4cf47587e69453007f1b606744/mypy-boto3-kinesis-1.28.36.tar.gz"
    sha256 "43713c0ce8f63b2cbd181132e71371031bd90eac250aef7357b239d4da6b8504"
  end

  resource "mypy-boto3-lambda" do
    url "https://files.pythonhosted.org/packages/f2/ba/b08d81a43a1d3633bb15ef103de90e702d53d40867e6c50628d1e6c654fd/mypy-boto3-lambda-1.28.83.tar.gz"
    sha256 "ff9d47bee0a15ccf5b798ed5a33f80e2dad0e2ea960ea5f74186390498ff8432"
  end

  resource "mypy-boto3-s3" do
    url "https://files.pythonhosted.org/packages/18/39/faa8e38b928baf0a8b78eddf5582ba0370bd303c058c04a2903e97cc9e57/mypy-boto3-s3-1.28.55.tar.gz"
    sha256 "b008809f448e74075012d4fc54b0176de0b4f49bc38e39de30ca0e764eb75056"
  end

  resource "mypy-boto3-schemas" do
    url "https://files.pythonhosted.org/packages/bb/ff/931e29e422bb586a8e9e8cb89224fa9998010647cbdf2ca3d6f4d1526020/mypy-boto3-schemas-1.28.36.tar.gz"
    sha256 "82af1ad64d0c1275c576607920f13dcc7605d6b7e8483dd58aced8395c824d5f"
  end

  resource "mypy-boto3-secretsmanager" do
    url "https://files.pythonhosted.org/packages/70/eb/2a6999ce9bb078156685516928dae15fee96e3f449571e5205af00be9ea3/mypy-boto3-secretsmanager-1.28.67.tar.gz"
    sha256 "37d34d2e038164bda8beb605bcc7133ef49f058e08102f5699f8d20790ead3f0"
  end

  resource "mypy-boto3-signer" do
    url "https://files.pythonhosted.org/packages/32/7f/d8c9860b9bf609f3fc95cc3128ab36972db3e761510c770110cbb26f8955/mypy-boto3-signer-1.28.36.tar.gz"
    sha256 "e008e2f4bf8023aea207d35a8ae57de9879fba8109d2cf813ddb0ebbf5300e93"
  end

  resource "mypy-boto3-sqs" do
    url "https://files.pythonhosted.org/packages/28/88/e6f3a9acc2859935bedcd78b442ec953b71d82c04c9446066f046134e034/mypy-boto3-sqs-1.28.82.tar.gz"
    sha256 "491073a9c0cf10874c34fc61248f488136298c93d7d5351dd1ad1004ee837716"
  end

  resource "mypy-boto3-stepfunctions" do
    url "https://files.pythonhosted.org/packages/49/49/cec0697f3a58dd3a2a4eb6c10a0e245ac4a7ce1e8e87f6e766df977003f4/mypy-boto3-stepfunctions-1.28.36.tar.gz"
    sha256 "8c794e98abc5ca23ef13e351f46bb849de634baca6f35286e31e58dede40b687"
  end

  resource "mypy-boto3-sts" do
    url "https://files.pythonhosted.org/packages/1b/2c/fb20dfe37be29cb4a9356496adb24b9c3305e624cf248f0f7648a7008ffb/mypy-boto3-sts-1.28.58.tar.gz"
    sha256 "beffec705f1f0b449da3c1f52ac7658627bb289aecec1a4408266479c46e053b"
  end

  resource "mypy-boto3-xray" do
    url "https://files.pythonhosted.org/packages/74/f6/44fae37678a47e10190c467a9235b4bea3532aeab1d0ac7e02a3d7db678a/mypy-boto3-xray-1.28.64.tar.gz"
    sha256 "0657a2317de5e296fe4e0c784a3594c4c8bd8d63f801594650472e773a9619de"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/c4/80/a84676339aaae2f1cfdf9f418701dd634aef9cc76f708ef55c36ff39c3ca/networkx-3.2.1.tar.gz"
    sha256 "9f1bb5cf3409bf324e0a722c20bdb4c20ee39bf1c30ce8ae499c8502b0b5e0c6"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/8d/c2/ee43b3b11bf2b40e56536183fc9f22afbb04e882720332b6276ee2454c24/pbr-6.0.0.tar.gz"
    sha256 "d1377122a5a00e2f940ee482999518efe16d745d423a670c27773dfbc3c9a7d9"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/df/e8/4f94ebd6972eff3babcea695d9634a4d60bea63955b9a4a413ec2fd3dd41/pydantic-2.4.2.tar.gz"
    sha256 "94f336138093a5d7f426aac732dcfe7ab4eb4da243c88f891d65deb4a2556ee7"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/af/31/8e466c6ed47cddf23013d2f2ccf3fdb5b908ffa1d5c444150c41690d6eca/pydantic_core-2.10.1.tar.gz"
    sha256 "0f8682dbdd2f67f8e1edddcbffcc29f60a6182b4901c367fc8c1c40d30bb0a82"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/bf/a0/e667c3c43b65a188cc3041fa00c50655315b93be45182b2c94d185a2610e/pyOpenSSL-23.3.0.tar.gz"
    sha256 "6b2cba5cc46e822750ec3e5a81ee12819850b11303630d575e98108a079c2b12"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "python-slugify" do
    url "https://files.pythonhosted.org/packages/de/63/0f60208d0d3dde1a87d30a82906fa9b00e902b57f1ae9565d780de4b41d1/python-slugify-8.0.1.tar.gz"
    sha256 "ce0d46ddb668b3be82f4ed5e503dbc33dd815d83e2eb6824211310d3fb172a27"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/e1/43/d3f6cf3e1ec9003520c5fb31dc363ee488c517f09402abd2a1c90df63bbb/referencing-0.30.2.tar.gz"
    sha256 "794ad8003c65938edcdbc027f1933215e0d0ccc0291e3ce20a4d87432b59efc0"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/6b/38/49d968981b5ec35dbc0f742f8219acab179fc1567d9c22444152f950cf0d/regex-2023.10.3.tar.gz"
    sha256 "3fef4f844d2290ee0ba57addcec17eec9e3df73f10a2748485dfd6a3a188cc0f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/b1/0e/e5aa3ab6857a16dadac7a970b2e1af21ddf23f03c99248db2c01082090a3/rich-13.6.0.tar.gz"
    sha256 "5c14d22737e6d5084ef4771b62d5d4363165b403455a30a1c8ca39dc7b644bef"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/75/be/e3f366aa4cd1e3a814f136773e506fc5423eff903ef0372a251df34e6e45/rpds_py-0.12.0.tar.gz"
    sha256 "7036316cc26b93e401cedd781a579be606dad174829e6ad9e9c5a0da6e036f80"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/82/43/fa976e03a4a9ae406904489119cd7dd4509752ca692b2e0a19491ca1782c/ruamel.yaml-0.18.5.tar.gz"
    sha256 "61917e3a35a569c1133a8f772e1226961bf5a1198bea7e23f06a0841dea1ab0e"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/46/ab/bab9eb1566cd16f060b54055dd39cf6a34bfa0240c53a7218c43e974295b/ruamel.yaml.clib-0.2.8.tar.gz"
    sha256 "beb2e0404003de9a4cab9753a8805a8fe9320ee6673136ed7f04255fe60bb512"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/3f/ff/5fd9375f3fe467263cff9cad9746fd4c4e1399440ea9563091c958ff90b5/s3transfer-0.7.0.tar.gz"
    sha256 "fd3889a66f5fe17299fe75b82eae6cf722554edca744ca5d5fe308b104883d2e"
  end

  resource "sarif-om" do
    url "https://files.pythonhosted.org/packages/ba/de/bbdd93fe456d4011500784657c5e4a31e3f4fcbb276255d4db1213aed78c/sarif_om-1.0.4.tar.gz"
    sha256 "cd5f416b3083e00d402a92e449a7ff67af46f11241073eea0461802a3b5aef98"
  end

  resource "sympy" do
    url "https://files.pythonhosted.org/packages/e5/57/3485a1a3dff51bfd691962768b14310dae452431754bfc091250be50dd29/sympy-1.12.tar.gz"
    sha256 "ebf595c8dac3e0fdc4152c51878b498396ec7f30e7a914d6071e674d49420fb8"
  end

  resource "text-unidecode" do
    url "https://files.pythonhosted.org/packages/ab/e2/e9a00f0ccb71718418230718b3d900e71a5d16e701a3dae079a21e9cd8f8/text-unidecode-1.3.tar.gz"
    sha256 "bad6603bb14d279193107714b288be206cac565dfa49aa5b105294dd5c4aab93"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/9b/93/93f12cdd3b9da81e94f2435d01fe6b3e9edc7704a25d4ad260ce7906ca62/tomlkit-0.12.2.tar.gz"
    sha256 "df32fab589a81f0d7dc525a4267b6d7a64ee99619cbd1eeb0fae32c1dd426977"
  end

  resource "types-awscrt" do
    url "https://files.pythonhosted.org/packages/15/b1/dc74541db967e41b42f26800565dcddc135f8e082762119163596d2bafbf/types_awscrt-0.19.9.tar.gz"
    sha256 "bd59e8f2a97b7bd3745e3f8600b0ed80064146b37537155c50826e28d2486430"
  end

  resource "types-python-dateutil" do
    url "https://files.pythonhosted.org/packages/1b/2d/f189e5c03c22700c4ce5aece4b51bb73fa8adcfd7848629de0fb78af5f6f/types-python-dateutil-2.8.19.14.tar.gz"
    sha256 "1f4f10ac98bb8b16ade9dbee3518d9ace017821d94b057a425b069f834737f4b"
  end

  resource "types-s3transfer" do
    url "https://files.pythonhosted.org/packages/d0/7f/bcb4025a389d53d1cfc9d592d710bff173ac98945ac28c67b58bd98089fe/types_s3transfer-0.7.0.tar.gz"
    sha256 "aca0f2486d0a3a5037cd5b8f3e20a4522a29579a8dd183281ff0aa1c4e2c8aa7"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/04/d3/c19d65ae67636fe63953b20c2e4a8ced4497ea232c43ff8d01db16de8dc0/tzlocal-5.2.tar.gz"
    sha256 "8d399205578f1a9342816409cc1e46a93ebd5755e39ea2d85334bea911bf0e6e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  resource "watchdog" do
    url "https://files.pythonhosted.org/packages/95/a6/d6ef450393dac5734c63c40a131f66808d2e6f59f6165ab38c98fbe4e6ec/watchdog-3.0.0.tar.gz"
    sha256 "4d98a320595da7a7c5a18fc48cb633c2e73cda78f93cac2ef42d42bf609a33f9"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/cb/eb/19eadbb717ef032749853ef5eb1c28e9ca974711e28bccd4815913ba5546/websocket-client-1.6.4.tar.gz"
    sha256 "b3324019b3c28572086c4a319f91d1dcd44e6e11cd340232978c684a7650d0df"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/0d/cc/ff1904eb5eb4b455e442834dabf9427331ac0fa02853bf83db817a7dd53d/werkzeug-3.0.1.tar.gz"
    sha256 "507e811ecea72b18a404947aded4b3390e1db8f826b494d76550ef45bb3b1dcc"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/fb/d0/0b4c18a0b85c20233b0c3bc33f792aefd7f12a5832b4da77419949ff6fd9/wheel-0.41.3.tar.gz"
    sha256 "4d4987ce51a49370ea65c0bfd2234e8ce80a12780820d9dc462597a6e60d0841"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/sam validate 2>&1", 1)
    assert_match "SAM Template Not Found", output

    assert_match version.to_s, shell_output("#{bin}/sam --version")
  end
end