class AwsSamCli < Formula
  include Language::Python::Virtualenv

  desc "CLI tool to build, test, debug, and deploy Serverless applications using AWS SAM"
  homepage "https://aws.amazon.com/serverless/sam/"
  url "https://files.pythonhosted.org/packages/65/43/f871c15eec7a22efe3573be104afccbee1e699503cf5291c1e8feeb2a478/aws-sam-cli-1.96.0.tar.gz"
  sha256 "19f3795ffc1c084121e60c3b6047a090df8a42fc1b804fef8518eb64228a655e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d93e5f2419f80bc7dc12b4cf33a2f01381efa25ae189b681b5d8313fcc6c886"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7600e7bd9b8256a6e1780b9a6c62b249f1d968a78621709abb97f8422ebe5d5b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "30469068c564b4d72c1c63f2fc7342ec6934f99b00a218d0a51608448f312c2a"
    sha256 cellar: :any_skip_relocation, ventura:        "e443429598d1613cb4d5a7a0f69f6e26c86d7d2f11cac553b1571057ecac85c4"
    sha256 cellar: :any_skip_relocation, monterey:       "48abb81fd4ef5c23029cd24cd5064a18674133e3acfbd2d65aade3347289a97e"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d10b2829a1f8aaae85cb01ca536ad379b6c88db77ec4d7fdd462036948d858c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46ce15906a5ffc43412a65d94deca31a137d30257f5c2d0a9c0f8cb0144a49d0"
  end

  depends_on "cffi"
  depends_on "pycparser"
  depends_on "pygments"
  depends_on "python-certifi"
  depends_on "python-cryptography"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/7f/c0/c601ea7811f422700ef809f167683899cdfddec5aa3f83597edf97349962/arrow-1.2.3.tar.gz"
    sha256 "3934b30ca1b9f292376d9db15b19446088d12ec58629bc3f0da28fd55fb633a1"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "aws-lambda-builders" do
    url "https://files.pythonhosted.org/packages/40/71/39770b9c106126590f7f6e3f1f416beeb082647324615b95f4a2ac0eb8ff/aws_lambda_builders-1.36.0.tar.gz"
    sha256 "b673b13d72ab9a85523e70a0980a8df86868bcf285d1ae1c032bb747bfc5b5d1"
  end

  resource "aws-sam-translator" do
    url "https://files.pythonhosted.org/packages/75/8c/ef4fa9ca2e395489c74c53cbc0084791e00b79940a8396622fcc00facc5f/aws-sam-translator-1.71.0.tar.gz"
    sha256 "a3ea80aeb116d7978b26ac916d2a5a24d012b742bf28262b17769c4b886e8fba"
  end

  resource "binaryornot" do
    url "https://files.pythonhosted.org/packages/a7/fe/7ebfec74d49f97fc55cd38240c7a7d08134002b1e14be8c3897c0dd5e49b/binaryornot-0.4.4.tar.gz"
    sha256 "359501dfc9d40632edc9fac890e19542db1a287bbcfa58175b66658392018061"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/c8/5d/e756d85addf5fa41be97df86a556eeb9fc89c9af0b51413a0f77cce95d7e/boto3-1.28.23.tar.gz"
    sha256 "839deb868d1278dd5a3f87208cfc4a8e259c95ca3cbe607cc322d435f02f63b0"
  end

  resource "boto3-stubs" do
    url "https://files.pythonhosted.org/packages/4b/22/dc64fd66d68a40e5eee506bb2fe39aa704f62208d671051e0e0d1563848b/boto3-stubs-1.28.2.tar.gz"
    sha256 "b140f56315cd99c659a2cbae32dc4ae1ee44073b4250e1ad391d03ecf4b5eb40"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/21/08/c197cf6660b7015595361224a48ea98597f4cb0143acb59ab672a1ce50e4/botocore-1.31.23.tar.gz"
    sha256 "f3258feaebce48f138eb2675168c4d33cc3d99e9f45af13cb8de47bdc2b9c573"
  end

  resource "botocore-stubs" do
    url "https://files.pythonhosted.org/packages/85/a5/8bfe4a669eec17d6c82eacf773e6b9f15bbc45e7e11e36b28d5e7ff67cec/botocore_stubs-1.31.23.tar.gz"
    sha256 "bf1e7130f47ab20087b59b4bebb4d21498bfa5fbd097aa0e8a580ddb18406746"
  end

  resource "cfn-lint" do
    url "https://files.pythonhosted.org/packages/68/ad/bc3193f294200753b938a75982c5efb5019da3b24dd8d0897decf6b8fb65/cfn-lint-0.79.6.tar.gz"
    sha256 "09fc9cc497fc6d15e8b822a98fa0628ed6f8e9bcce6c289d95b2fc71d50aa63f"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "chevron" do
    url "https://files.pythonhosted.org/packages/15/1f/ca74b65b19798895d63a6e92874162f44233467c9e7c1ed8afd19016ebe9/chevron-0.14.0.tar.gz"
    sha256 "87613aafdf6d77b6a90ff073165a61ae5086e21ad49057aa0e53681601800ebf"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "cookiecutter" do
    url "https://files.pythonhosted.org/packages/96/43/65a3dad94dceaaaa12807ce4d4eff1064db6e91a8c6fb6945e3e61e63552/cookiecutter-2.1.1.tar.gz"
    sha256 "f3982be8d9c53dac1261864013fdec7f83afd2e42ede6f6dd069c5e149c540d5"
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
    url "https://files.pythonhosted.org/packages/5f/76/a4d2c4436dda4b0a12c71e075c508ea7988a1066b06a575f6afe4fecc023/Flask-2.2.5.tar.gz"
    sha256 "edee9b0a7ff26621bd5a8c10ff484ae28737a2410d99b0bb9a6850c7fb977aa0"
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

  resource "jinja2-time" do
    url "https://files.pythonhosted.org/packages/de/7c/ee2f2014a2a0616ad3328e58e7dac879251babdb4cb796d770b5d32c469f/jinja2-time-0.2.0.tar.gz"
    sha256 "d14eaa4d315e7688daa4969f616f226614350c48730bfa1692d2caebd8c90d40"
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
    url "https://files.pythonhosted.org/packages/2b/3f/dd9bc9c1c9e57c687e8ebc4723e76c48980004244cf8db908a7b2543bd53/jsonpickle-3.0.1.tar.gz"
    sha256 "032538804795e73b94ead410800ac387fdb6de98f8882ac957fcd247e3a85200"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/8f/5e/67d3ab449818b629a0ffe554bb7eb5c030a71f7af5d80fbf670d7ebe62bc/jsonpointer-2.4.tar.gz"
    sha256 "585cee82b70211fa9e6043b7bb89db6e1aa49524340dde8ad6b63206ea689d88"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/36/3d/ca032d5ac064dff543aa13c984737795ac81abc9fb130cd2fcff17cfabc7/jsonschema-4.17.3.tar.gz"
    sha256 "0f864437ab8b6076ba6707453ef8f98a6a0d512a80e93f8abdb676f737ecb60d"
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
    url "https://files.pythonhosted.org/packages/85/ca/be97a048085f24def34e507af7cce7ae4b390bf0cee831f7225bbb459628/mypy-boto3-apigateway-1.28.16.tar.gz"
    sha256 "82491d942530ab9dabc4c811e188c6ab546c3e658c5718bab58fb45cadef6d0b"
  end

  resource "mypy-boto3-cloudformation" do
    url "https://files.pythonhosted.org/packages/61/3d/85ac19d0b5b28d95e705b5489fbac86b883918946d5cbd40832ca3d502d1/mypy-boto3-cloudformation-1.28.19.tar.gz"
    sha256 "efb08a2a6d7c744d0d8d60f04514c531355aa7972b53f025d9e08e3adf3a5504"
  end

  resource "mypy-boto3-ecr" do
    url "https://files.pythonhosted.org/packages/5e/d5/fbea6a04b261f85a80acb6c5f0ea032812bd0898339f5e53c5e8952f7e76/mypy-boto3-ecr-1.28.16.tar.gz"
    sha256 "b3252c5eda47ca1e90980e0158410e8a76c8acdfbda0907f545ddfddaea95258"
  end

  resource "mypy-boto3-iam" do
    url "https://files.pythonhosted.org/packages/90/8e/38c9501d9613a739903a7e8a3a6083de5bc4fce5d7519f4deb0710baa120/mypy-boto3-iam-1.28.16.tar.gz"
    sha256 "8ef9ef9a9fabcc1058a46bbd6b1408960a70d72e45a024862676e5a896c446b3"
  end

  resource "mypy-boto3-lambda" do
    url "https://files.pythonhosted.org/packages/d8/95/0d9e0604016356242c9746f1ac7cee5d0c069bf15a71ca30bf57bd9c4ccd/mypy-boto3-lambda-1.28.19.tar.gz"
    sha256 "955b7702f02f2037ba4c058f6dcebfcce50090ac13c9d031a0052fa9136ec59e"
  end

  resource "mypy-boto3-s3" do
    url "https://files.pythonhosted.org/packages/49/4b/a7e25e68ed7dfb7ecaa1bc42b9b6c08fb7df0f0f0ef53f6181c66bb83a7a/mypy-boto3-s3-1.28.19.tar.gz"
    sha256 "b8104b191924d8672068d21d748c0f8ae0b0e1950324cb315ec8a1ceed9d23ac"
  end

  resource "mypy-boto3-schemas" do
    url "https://files.pythonhosted.org/packages/f3/51/09ebda7cb9b0bb9be73ab6e78d34e5246ef9c893385ae1c7ef6cc2687227/mypy-boto3-schemas-1.28.16.tar.gz"
    sha256 "4f4b4fc784452b5186ab31199e4cb5546d314f3fc666cb698c960ba89e33448e"
  end

  resource "mypy-boto3-secretsmanager" do
    url "https://files.pythonhosted.org/packages/86/d5/3d4d108b7a1a47321bd8a1b52c8b8c2afecf83b24ea5fc7873522192b084/mypy-boto3-secretsmanager-1.28.16.tar.gz"
    sha256 "07f443b31d2114ac363cfbdbc5f4b97934ca48fb99734bbd06d5c39bce244b83"
  end

  resource "mypy-boto3-signer" do
    url "https://files.pythonhosted.org/packages/95/56/ed5ec438f5e80283f31a3821de2c8e8abdab372795222644af74c54a6a54/mypy-boto3-signer-1.28.16.tar.gz"
    sha256 "a67206f20189105a24deee995ab130123fa1af75c39c13c17e404ff74b9ec1fc"
  end

  resource "mypy-boto3-stepfunctions" do
    url "https://files.pythonhosted.org/packages/27/af/e28e1d64af3c1bd7ecd396fe38548530e768e8da97657a58d699210783f1/mypy-boto3-stepfunctions-1.28.16.tar.gz"
    sha256 "8b2b6578ca38dc0f13d73292b92afd7f3cf11a8999a33886d4c4ab6822f0020a"
  end

  resource "mypy-boto3-sts" do
    url "https://files.pythonhosted.org/packages/aa/11/4e85e20f316611bf628d2587a175f50bda0e40294e5daaf1a1e66cb8c710/mypy-boto3-sts-1.28.16.tar.gz"
    sha256 "7cd388a7451611813730b83c78179759eb5701b849618d82c3ec7e95576bedb9"
  end

  resource "mypy-boto3-xray" do
    url "https://files.pythonhosted.org/packages/c0/34/505cdbc2905cd0c3d626fa9a1a99ab47abad325067a0072b6fdd56e2380d/mypy-boto3-xray-1.28.16.tar.gz"
    sha256 "6ddd4acccf272bf663522c5fcd31b9b7dacbed4a01c91e44e4e8c0abb2343c0a"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/fd/a1/47b974da1a73f063c158a1f4cc33ed0abf7c04f98a19050e80c533c31f0c/networkx-3.1.tar.gz"
    sha256 "de346335408f84de0eada6ff9fafafff9bcda11f0a0dfaa931133debb146ab61"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/02/d8/acee75603f31e27c51134a858e0dea28d321770c5eedb9d1d673eb7d3817/pbr-5.11.1.tar.gz"
    sha256 "aefc51675b0b533d56bb5fd1c8c6c0522fe31896679882e1c4c63d5e4a0fccb3"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/3b/9b/a7631bf35e55326fd74654fe6bd896478f47d65e97ca69e60ddb1b3823ee/pydantic-1.10.12.tar.gz"
    sha256 "0fe8a415cea8f340e7a9af9c54fc71a649b43e8ca3cc732986116b3cb135d303"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/be/df/75a6525d8988a89aed2393347e9db27a56cb38a3e864314fac223e905aef/pyOpenSSL-23.2.0.tar.gz"
    sha256 "276f931f55a452e7dea69c7173e984eb2a4407ce413c918aa34b55f82f9b8bac"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/bf/90/445a7dbd275c654c268f47fa9452152709134f61f09605cf776407055a89/pyrsistent-0.19.3.tar.gz"
    sha256 "1a2994773706bbb4995c31a97bc94f1418314923bd1048c6d964837040376440"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "python-slugify" do
    url "https://files.pythonhosted.org/packages/de/63/0f60208d0d3dde1a87d30a82906fa9b00e902b57f1ae9565d780de4b41d1/python-slugify-8.0.1.tar.gz"
    sha256 "ce0d46ddb668b3be82f4ed5e503dbc33dd815d83e2eb6824211310d3fb172a27"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/5e/32/12032aa8c673ee16707a9b6cdda2b09c0089131f35af55d443b6a9c69c1d/pytz-2023.3.tar.gz"
    sha256 "1d8ce29db189191fb55338ee6d0387d82ab59f3d00eac103412d64e0ebd0c588"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/4f/1d/6998ba539616a4c8f58b07fd7c9b90c6b0f0c0ecbe8db69095a6079537a7/regex-2023.8.8.tar.gz"
    sha256 "fcbdc5f2b0f1cd0f6a56cdb46fe41d2cce1e644e3b68832f3eeebc5fb0f7712e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/e3/12/67d0098eb77005f5e068de639e6f4cfb8f24e6fcb0fd2037df0e1d538fee/rich-13.4.2.tar.gz"
    sha256 "d653d6bccede5844304c605d5aac802c7cf9621efd700b46c7ec2b51ea914898"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/63/dd/b4719a290e49015536bd0ab06ab13e3b468d8697bec6c2f668ac48b05661/ruamel.yaml-0.17.32.tar.gz"
    sha256 "ec939063761914e14542972a5cba6d33c23b0859ab6342f61cf070cfc600efc2"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/d5/31/a3e6411947eb7a4f1c669f887e9e47d61a68f9d117f10c3c620296694a0b/ruamel.yaml.clib-0.2.7.tar.gz"
    sha256 "1f08fd5a2bea9c4180db71678e850b995d2a5f4537be0e94557668cf0f5f9497"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/49/bd/def2ab4c04063a5e114963aae90bcd3e3aca821a595124358b3b00244407/s3transfer-0.6.1.tar.gz"
    sha256 "640bb492711f4c0c0905e1f62b6aaeb771881935ad27884852411f8e9cacbca9"
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
    url "https://files.pythonhosted.org/packages/10/37/dd53019ccb72ef7d73fff0bee9e20b16faff9658b47913a35d79e89978af/tomlkit-0.11.8.tar.gz"
    sha256 "9330fc7faa1db67b541b28e62018c17d20be733177d290a13b24c62d1614e0c3"
  end

  resource "types-awscrt" do
    url "https://files.pythonhosted.org/packages/06/77/7580eb28b57a9eb849301d0f80c6e1863a71f66f52236c0239675ad7d8e4/types_awscrt-0.17.0.tar.gz"
    sha256 "4214783a747af900a5f98ec020d52ecae5910b470fd636813637a45b82a97516"
  end

  resource "types-s3transfer" do
    url "https://files.pythonhosted.org/packages/e2/ce/d5754d2b30292d0e8e37ec677c9175f0a773f2c608ceb2ef35bd645131d2/types_s3transfer-0.6.1.tar.gz"
    sha256 "75ac1d7143d58c1e6af467cfd4a96c67ee058a3adf7c249d9309999e1f5f41e4"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/89/e7/5fc01b31d9df0b914d5bbbea6f5d80ff76c6b5cf11bf23a8beca8407a0f1/tzlocal-3.0.tar.gz"
    sha256 "f4e6e36db50499e0d92f79b67361041f048e2609d166e93456b50746dc4aef12"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e2/7d/539e6f0cf9f0b95b71dd701a56dae89f768cd39fd8ce0096af3546aeb5a3/urllib3-1.26.16.tar.gz"
    sha256 "8f135f6502756bde6b2a9b28989df5fbe87c9970cecaa69041edcce7f0589b14"
  end

  resource "watchdog" do
    url "https://files.pythonhosted.org/packages/ad/9e/df37da9de16e02d8a4230dcd09d4bf7ced6cd97e1f421cbade133a011e3f/watchdog-2.1.2.tar.gz"
    sha256 "0237db4d9024859bea27d0efb59fe75eef290833fd988b8ead7a879b0308c2db"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/b1/34/3a5cae1e07d9566ad073fa6d169bf22c03a3ba7b31b3c3422ec88d039108/websocket-client-1.6.1.tar.gz"
    sha256 "c951af98631d24f8df89ab1019fc365f2227c0892f12fd150e935607c79dd0dd"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/d1/7e/c35cea5749237d40effc50ed1a1c7518d9f2e768fcf30b4e9ea119e74975/Werkzeug-2.3.6.tar.gz"
    sha256 "98c774df2f91b05550078891dee5f0eb0cb797a522c757a2452b9cee5b202330"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/c9/3d/02a14af2b413d7abf856083f327744d286f4468365cddace393a43d9d540/wheel-0.41.1.tar.gz"
    sha256 "12b911f083e876e10c595779709f8a88a59f45aacc646492a67fe9ef796c1b47"
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