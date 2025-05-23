class AwsSamCli < Formula
  include Language::Python::Virtualenv

  desc "CLI tool to build, test, debug, and deploy Serverless applications using AWS SAM"
  homepage "https://aws.amazon.com/serverless/sam/"
  url "https://files.pythonhosted.org/packages/8a/80/e586d9468f5fe497efe05e881fef8842ffaac03809bbcfe2bca3f7cbc793/aws_sam_cli-1.139.0.tar.gz"
  sha256 "c112a0b87404aa925acd6618422bce5197df2763005e67a1e7ef5e00fc48f873"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5aa5e370edd520169fa16df40ad24a3e2f8a14255c4e6960f0743c54b5f8a393"
    sha256 cellar: :any,                 arm64_sonoma:  "8113db5392329d6ccc8a9a4fa2138a0ae8217a0c1aea522d10cbde862710eef0"
    sha256 cellar: :any,                 arm64_ventura: "0339a4cfd96a0c7598045bfd5b7a982cd8f2c6a30c4d2892ceb62c3f71384650"
    sha256 cellar: :any,                 sonoma:        "90b55d0f5f5d3c607d5a33b8d599ec8c407a5c6eb2d44b3fab7c25c67523c34b"
    sha256 cellar: :any,                 ventura:       "007c924661067d2e70e1c46f8f91149246fc7b01c27dc462e6b8834943f7f6ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7899bbd90107addc44f170b21d0bd830480ea3286672ba472503257ab0f7330a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1b0e2ee192f94287e47b4890846d31c3b90fc6ab10db484d5a084ae2d8d050c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.13"

  uses_from_macos "libffi"

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/2e/00/0f6e8fcdb23ea632c866620cc872729ff43ed91d284c866b515c6342b173/arrow-1.3.0.tar.gz"
    sha256 "d4540617648cb5f895730f1ad8c82a65f2dad0166f57b75f3ca54759c4d67a85"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/5a/b0/1367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24/attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "aws-lambda-builders" do
    url "https://files.pythonhosted.org/packages/d0/dc/8272ad7a2db5676eb1b1e2c9c12afa79f29bf315ccc85bfb22dcdbf04562/aws_lambda_builders-1.54.0.tar.gz"
    sha256 "c74353b6f4dfda981f3b01aa1e39180a492cbd323852122b6f6451faeb4d15f0"
  end

  resource "aws-sam-translator" do
    url "https://files.pythonhosted.org/packages/13/01/3a9a3fea6ed942239f22c4fa9b3cd9d8b69545607f257fbb47d28d115dde/aws_sam_translator-1.97.0.tar.gz"
    sha256 "6f7ec94de0a9b220dd1f1a0bf7e2df95dd44a85592301ee830744da2f209b7e6"
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
    url "https://files.pythonhosted.org/packages/d0/e5/4623171284e125ebfef850a21c2af22b0515b08f5cd05e77a79a1085f663/boto3-1.38.22.tar.gz"
    sha256 "008f6a7c2f9f306984f9bd00c331d70341124aaa7dfebcb0466ecbda6619884a"
  end

  resource "boto3-stubs" do
    url "https://files.pythonhosted.org/packages/9f/85/86243ad2792f8506b567c645d97ece548258203c55bcc165fd5801f4372f/boto3_stubs-1.35.71.tar.gz"
    sha256 "50e20fa74248c96b3e3498b2d81388585583e38b9f0609d2fa58257e49c986a5"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/02/ed/b75b99f64c8ce365213abc2e3124e7712ab7c691170718d1c3086c44aaea/botocore-1.38.22.tar.gz"
    sha256 "3b464984674f97367ca1dfa29bdbce499327571208aaec2f9743f66e54d9ba05"
  end

  resource "botocore-stubs" do
    url "https://files.pythonhosted.org/packages/43/70/6204c97f8d8362364f11c16085566abdcaa114c264d3a4d709ff697b203b/botocore_stubs-1.38.19.tar.gz"
    sha256 "84f67a42bb240a8ea0c5fe4f05d497cc411177db600bc7012182e499ac24bf19"
  end

  resource "cfn-lint" do
    url "https://files.pythonhosted.org/packages/73/42/5dd6fdad1382d37143a2c84dd2143c7dd3d065a64e55b51e23e20b8f8b14/cfn_lint-1.34.2.tar.gz"
    sha256 "d340a6f816676489fac6f2fae3609e266c48d031abed04b978b07db7adf05f75"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e4/33/89c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12d/charset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
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
    url "https://files.pythonhosted.org/packages/bd/3f/d3207a05f5b6a78c66d86631e60bfba5af163738a599a5b9aa2c2737a09e/dateparser-1.2.1.tar.gz"
    sha256 "7e4919aeb48481dbfc01ac9683c8e20bfe95bb715a38c1e9f6af889f4f30ccc3"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/91/9b/4a2ea29aeba62471211598dac5d96825bb49348fa07e906ea930394a83ce/docker-7.1.0.tar.gz"
    sha256 "ad8c70e6e3f8926cb8a92619b832b4ea5299e2831c14284663184e200546fa6c"
  end

  resource "flask" do
    url "https://files.pythonhosted.org/packages/c0/de/e47735752347f4128bcf354e0da07ef311a78244eba9e3dc1d4a5ab21a98/flask-3.1.1.tar.gz"
    sha256 "284c7b8f2f58cb737f0cf1c30fd7eaf0ccfcde196099d24ecede3fc2005aa59e"
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

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/42/78/18813351fe5d63acad16aec57f94ec2b70a09e53ca98145589e185423873/jsonpatch-1.33.tar.gz"
    sha256 "9fcd4009c41e6d12348b4a0ff2563ba56a2923a7dfee731d004e212e1ee5030c"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/6a/0a/eebeb1fa92507ea94016a2a790b93c2ae41a7e18778f85471dc54475ed25/jsonpointer-3.0.0.tar.gz"
    sha256 "2b2d729f2091522d61c3b31f82e11870f60b68f43fbc705cb76bf4b832af59ef"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/38/2e/03362ee4034a4c917f697890ccd4aec0800ccf9ded7f511971c75451deec/jsonschema-4.23.0.tar.gz"
    sha256 "d71497fef26351a33265337fa77ffeb82423f3ea21283cd9467bb03999266bc4"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/bf/ce/46fbd9c8119cfc3581ee5643ea49464d168028cfb5caff5fc0596d0cf914/jsonschema_specifications-2025.4.1.tar.gz"
    sha256 "630159c9f4dbea161a6a2205c3011cc4f18ff381b189fff48bb39b9bf26ae608"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
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
    url "https://files.pythonhosted.org/packages/e0/3d/c5dc7a750d9fdba2bf704d3d963be9ad4ed617fe5bb98e5c88374a3d8d69/mypy_boto3_apigateway-1.35.93.tar.gz"
    sha256 "df90957c5f2c219663f825b905cb53b9f53fd7982e01bb21da65f5757c3d5d41"
  end

  resource "mypy-boto3-cloudformation" do
    url "https://files.pythonhosted.org/packages/f3/26/e59425e30fb1783aa718f1a8ac93cdc415e279e175c953ee0a72310f7490/mypy_boto3_cloudformation-1.35.93.tar.gz"
    sha256 "57dc112ff3e2ddc1e9e621e428490b904c0da8c1532d30e9fa2a19aefde9f719"
  end

  resource "mypy-boto3-ecr" do
    url "https://files.pythonhosted.org/packages/92/ae/1598bf3dc7069f0e48a60a482dffa71885e1558aa076243375820de2792f/mypy_boto3_ecr-1.35.93.tar.gz"
    sha256 "57295a72a9473b8542578ab15eb0a4909cad6f2cee1da41ce6a8a40ab7051438"
  end

  resource "mypy-boto3-iam" do
    url "https://files.pythonhosted.org/packages/c7/24/7cb0b26c3af8207496880155441cfd7f5d8c5404d4669e39385eb307672d/mypy_boto3_iam-1.35.93.tar.gz"
    sha256 "2595c8dac406e4e771d3b7d7835faacb936d20449b9cdd17a53f076219cc7712"
  end

  resource "mypy-boto3-kinesis" do
    url "https://files.pythonhosted.org/packages/7d/c3/eb9f1aeaf42ea55c473b0281fe5813aafe3283733ad84fbd27c370416753/mypy_boto3_kinesis-1.35.93.tar.gz"
    sha256 "f0718f5b54b955761790b4b33bdcab8d0c779bd50cc671c6862a8e0554515bda"
  end

  resource "mypy-boto3-lambda" do
    url "https://files.pythonhosted.org/packages/f0/ef/b90e51be87b5c226005c765a7109a26b5ce39cf349f2603336bd5c365863/mypy_boto3_lambda-1.35.93.tar.gz"
    sha256 "c11b047743c7635ea8385abffaf97788a108b71479612e9b5e7d0bb19029d7a4"
  end

  resource "mypy-boto3-s3" do
    url "https://files.pythonhosted.org/packages/15/53/99667aad21b236612ecb50eee09fdc4de6fbe39c3a75a6bad387d108ed1f/mypy_boto3_s3-1.35.93.tar.gz"
    sha256 "b4529e57a8d5f21d4c61fe650fa6764fee2ba7ab524a455a34ba2698ef6d27a8"
  end

  resource "mypy-boto3-schemas" do
    url "https://files.pythonhosted.org/packages/c9/f7/63c5b0db122b99265a14f179f41ab01566610c78abe14e63a4df3ebca7fa/mypy_boto3_schemas-1.35.93.tar.gz"
    sha256 "7f2255ddd6d531101ec67fbd1afca8be02568f4e5787d1631199aa25b58a480f"
  end

  resource "mypy-boto3-secretsmanager" do
    url "https://files.pythonhosted.org/packages/d8/c6/1c69c3ac9fadeb6cc01da5a90edd5f36cbf09a4fa66e8cef638917eba4d1/mypy_boto3_secretsmanager-1.35.93.tar.gz"
    sha256 "b6c4bc88a5fe4143124272728d41342e01c778b406db9d647a20dad0de7d6f47"
  end

  resource "mypy-boto3-signer" do
    url "https://files.pythonhosted.org/packages/d1/00/954104765b3414b0221cf18efebcee656f7b8be603866682a0dcf9e00ecf/mypy_boto3_signer-1.35.93.tar.gz"
    sha256 "f12c7c7025cc25804146431f639f3eb9db664a4695bf28d2a87f58111fc7f888"
  end

  resource "mypy-boto3-sqs" do
    url "https://files.pythonhosted.org/packages/29/5b/040ba82c53d5edf578ad0aafcac501b91a259b40f296ef6662db975b6595/mypy_boto3_sqs-1.35.93.tar.gz"
    sha256 "8ea7f63e0878544705c31996ae4c064095fbb4f780f8323a84f7a75281d643fe"
  end

  resource "mypy-boto3-stepfunctions" do
    url "https://files.pythonhosted.org/packages/ec/f9/44a59a6c84edfd94477e5427befcbecdb4f92ae34d897536671dc4994e23/mypy_boto3_stepfunctions-1.35.93.tar.gz"
    sha256 "20230615c42e7aabbd43b62657ca3534e96767245705d12d42672ac87cd1b59c"
  end

  resource "mypy-boto3-sts" do
    url "https://files.pythonhosted.org/packages/9f/fc/652992367bad0bae7d1c8d8bd5fa455570de77337f8d0c2021263dc4e695/mypy_boto3_sts-1.35.97.tar.gz"
    sha256 "6df698f6a400a82ebcc2f10adb43557f66278467200e0f75588e7de3e4a1622d"
  end

  resource "mypy-boto3-xray" do
    url "https://files.pythonhosted.org/packages/b6/98/1ffe456cf073fe6ee1826f053943793d4082fe02412a109c72c0f414a66c/mypy_boto3_xray-1.35.93.tar.gz"
    sha256 "7e0af9474f06da1923aa37c8639b051042cc3a56d1a36b0141124d9de7be6709"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/fd/1d/06475e1cd5264c0b870ea2cc6fdb3e37177c1e565c43f56ff17a10e3937f/networkx-3.4.2.tar.gz"
    sha256 "307c3669428c5362aab27c8a1260aa8f47c4e91d3891f48be0141738d8d053e1"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/f0/86/8ce9040065e8f924d642c58e4a344e33163a07f6b57f836d0d734e0ad3fb/pydantic-2.11.5.tar.gz"
    sha256 "7f853db3d0ce78ce8bbb148c401c2cdd6431b3473c0cdff2755c7690952a7b7a"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/ad/88/5f2260bdfae97aabf98f1778d43f69574390ad787afb646292a638c923d4/pydantic_core-2.33.2.tar.gz"
    sha256 "7cb8bc3605c29176e1b105350d2e6474142d7c1bd1d9327c4a9bdb46bf827acc"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/7c/2d/c3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84/pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/c1/d4/1067b82c4fc674d6f6e9e8d26b3dff978da46d351ca3bac171544693e085/pyopenssl-24.3.0.tar.gz"
    sha256 "49f7a019577d834746bc55c5fce6ecbcec0f2b4ec5ce1cf43a9a173b8138bb36"
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
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/2f/db/98b5c277be99dd18bfd91dd04e1b759cad18d1a338188c936e92f921c7e2/referencing-0.36.2.tar.gz"
    sha256 "df2e89862cd09deabbdba16944cc3f10feb6b3e6f18e902f7cc25609a34775aa"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/8e/5f/bd69653fbfb76cf8604468d3b4ec4c403197144c7bfe0e6a5fc9e02a07cb/regex-2024.11.6.tar.gz"
    sha256 "7ab159b063c52a0333c884e4679f8d7a85112ee3078fe3d9004b2dd875585519"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/ab/3a/0316b28d0761c6734d6bc14e770d85506c986c85ffb239e688eeaab2c2bc/rich-13.9.4.tar.gz"
    sha256 "439594978a49a09530cff7ebc4b5c7103ef57baf48d5ea3184f21d9a2befa098"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/8c/a6/60184b7fc00dd3ca80ac635dd5b8577d444c57e8e8742cecabfacb829921/rpds_py-0.25.1.tar.gz"
    sha256 "8960b6dac09b62dac26e75d7e2c4a22efb835d827a7278c34f72b2b84fa160e3"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/ea/46/f44d8be06b85bc7c4d8c95d658be2b68f27711f279bf9dd0612a5e4794f5/ruamel.yaml-0.18.10.tar.gz"
    sha256 "20c86ab29ac2153f80a428e1254a8adf686d3383df04490514ca3b79a362db58"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/ed/5d/9dcc100abc6711e8247af5aa561fc07c4a046f72f659c3adea9a449e191a/s3transfer-0.13.0.tar.gz"
    sha256 "f5e6db74eb7776a37208001113ea7aa97695368242b364d73e91c981ac522177"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/8d/d2/ec1acaaff45caed5c2dedb33b67055ba9d4e96b091094df90762e60135fe/setuptools-80.8.0.tar.gz"
    sha256 "49f7af965996f26d43c8ae34539c8d99c5042fbff34302ea151eaa9c207cd257"
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
    url "https://files.pythonhosted.org/packages/b1/09/a439bec5888f00a54b8b9f05fa94d7f901d6735ef4e55dcec9bc37b5d8fa/tomlkit-0.13.2.tar.gz"
    sha256 "fff5fe59a87295b278abd31bec92c15d9bc4a06885ab12bcea52c71119392e79"
  end

  resource "types-awscrt" do
    url "https://files.pythonhosted.org/packages/36/6c/583522cfb3c330e92e726af517a91c13247e555e021791a60f1b03c6ff16/types_awscrt-0.27.2.tar.gz"
    sha256 "acd04f57119eb15626ab0ba9157fc24672421de56e7bd7b9f61681fedee44e91"
  end

  resource "types-python-dateutil" do
    url "https://files.pythonhosted.org/packages/ef/88/d65ed807393285204ab6e2801e5d11fbbea811adcaa979a2ed3b67a5ef41/types_python_dateutil-2.9.0.20250516.tar.gz"
    sha256 "13e80d6c9c47df23ad773d54b2826bd52dbbb41be87c3f339381c1700ad21ee5"
  end

  resource "types-s3transfer" do
    url "https://files.pythonhosted.org/packages/fb/d5/830e9efe91a26601a2bebde6f299239d2d26e542f5d4b3bc7e8c23c81a3f/types_s3transfer-0.12.0.tar.gz"
    sha256 "f8f59201481e904362873bf0be3267f259d60ad946ebdfcb847d092a1fa26f98"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/37/23083fcd6e35492953e8d2aaaa68b860eb422b34627b13f2ce3eb6106061/typing_extensions-4.13.2.tar.gz"
    sha256 "e6c81219bd689f51865d9e372991c540bda33a0379d5573cddb9a3a23f7caaef"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/f8/b1/0c11f5058406b3af7609f121aaa6b609744687f1d158b3c3a5bf4cc94238/typing_inspection-0.4.1.tar.gz"
    sha256 "6ae134cc0203c33377d43188d4064e9b357dba58cff3185f22924610e70a9d28"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/04/d3/c19d65ae67636fe63953b20c2e4a8ced4497ea232c43ff8d01db16de8dc0/tzlocal-5.2.tar.gz"
    sha256 "8d399205578f1a9342816409cc1e46a93ebd5755e39ea2d85334bea911bf0e6e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8a/78/16493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0/urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
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

    generate_completions_from_executable(bin/"sam", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    output = shell_output("#{bin}/sam validate 2>&1", 1)
    assert_match "SAM Template Not Found", output

    assert_match version.to_s, shell_output("#{bin}/sam --version")
  end
end