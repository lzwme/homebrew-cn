class AwsSamCli < Formula
  include Language::Python::Virtualenv

  desc "CLI tool to build, test, debug, and deploy Serverless applications using AWS SAM"
  homepage "https://aws.amazon.com/serverless/sam/"
  url "https://files.pythonhosted.org/packages/6d/20/42c2a7076a9e181aa5fdb199b7231244c16831517ccaeed44ec5163b6f88/aws_sam_cli-1.143.0.tar.gz"
  sha256 "18438b9405532d696a2af9e0ac6cae30a6b238f0f35f3e6f02c6c41248e15c55"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0c612036106f45a97b8191a62b11a42cc776db21081938f423e90b66ce791c4d"
    sha256 cellar: :any,                 arm64_sonoma:  "1ff2ec3f929cbbf5e1e611bf25feccac9fbad8e7702c90c789cf8501ebd74695"
    sha256 cellar: :any,                 arm64_ventura: "fe34df34a86758f00508c249c4459ebd95bd694a09bccc88a212a07ba465b32a"
    sha256 cellar: :any,                 sonoma:        "1f1d321ecd99c46144f0e9ad595ee878df642beb6de974ff7e24978402bba968"
    sha256 cellar: :any,                 ventura:       "f2df0a13445b746118402ac147f402d7aeb4aa3a04e00527e24a2280a9c10b2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "730c0ec50b2d5e22ca06d03af55e4bf5b07b4b1b13d71282619ef0ba43bc345e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4db4a3854b3e0843cd228d239bbd5a6768c72b80a8da846e37a8aa3d6bddcc5"
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
    url "https://files.pythonhosted.org/packages/41/24/ad7762e1fc6e13fcebadccbf533502095ee34d29e72e3d437b2d8393e5e4/aws_lambda_builders-1.57.0.tar.gz"
    sha256 "e72ae97b63d5f5fb56f9483800eb3eeceee74f7771b92d6c39ecdfb014727517"
  end

  resource "aws-sam-translator" do
    url "https://files.pythonhosted.org/packages/ef/78/ac6761ff3f37a1e989ddb62c9a58c4d289ad2ca2bdb3bed1319f4ae49e16/aws_sam_translator-1.99.0.tar.gz"
    sha256 "be326054a7ee2f535fcd914db85e5d50bdf4054313c14888af69b6de3187cdf8"
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
    url "https://files.pythonhosted.org/packages/d3/1d/e7928de166f328d5c7993924c4df048de1c8de759f8d088aab0fa1a0e6b5/boto3-1.40.15.tar.gz"
    sha256 "271b379ce5ad35ca82f1009e917528a182eed0e2de197ccffb0c51acadec5c79"
  end

  resource "boto3-stubs" do
    url "https://files.pythonhosted.org/packages/05/5c/17b36b423d9ee8bd48fe9ac52abec13ce259245f0276f007936fa2b08df7/boto3_stubs-1.39.7.tar.gz"
    sha256 "1c07c3c9c59f17c29b45d14f8c0c52fdae5986a87ae78467d5171052f49bae4e"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/f0/ed/b99cdd9d415f8dcb6313e64458958ba5e305927896068e1b69fed5979e50/botocore-1.40.15.tar.gz"
    sha256 "4960800e4c5a7b43db22550979c22f5a324cbaf75ef494bbb2cf400ef1e6aca7"
  end

  resource "botocore-stubs" do
    url "https://files.pythonhosted.org/packages/05/45/27cabc7c3022dcb12de5098cc646b374065f5e72fae13600ff1756f365ee/botocore_stubs-1.38.46.tar.gz"
    sha256 "a04e69766ab8bae338911c1897492f88d05cd489cd75f06e6eb4f135f9da8c7b"
  end

  resource "cfn-lint" do
    url "https://files.pythonhosted.org/packages/5f/59/fce3fc232899608e24665531bb29a355fc41ac12b4e0d8198dab3b650b67/cfn_lint-1.38.3.tar.gz"
    sha256 "954fe80fdcd7676db48a2cee0680bcecc517a2677b49058fd5d71c3d21e9f00a"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/83/2d/5fd176ceb9b2fc619e63405525573493ca23441330fcdaee6bef9460e924/charset_normalizer-3.4.3.tar.gz"
    sha256 "6fce4b8500244f6fcb71465d4a4930d132ba9ab8e71a7859e6a5d59851068d14"
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
    url "https://files.pythonhosted.org/packages/74/69/f7185de793a29082a9f3c7728268ffb31cb5095131a9c139a74078e27336/jsonschema-4.25.1.tar.gz"
    sha256 "e4a9655ce0da0c0b67a085847e00a3a51449e1157f4f75e9fb5aa545e122eb85"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/bf/ce/46fbd9c8119cfc3581ee5643ea49464d168028cfb5caff5fc0596d0cf914/jsonschema_specifications-2025.4.1.tar.gz"
    sha256 "630159c9f4dbea161a6a2205c3011cc4f18ff381b189fff48bb39b9bf26ae608"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
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
    url "https://files.pythonhosted.org/packages/d9/32/fff8b2a5f68fe491722ccc2beeb5f6d8c193e8c63af2b47452685383b322/mypy_boto3_apigateway-1.39.0.tar.gz"
    sha256 "3b7c9736c368029af5809a1040c960aa0bafd18848a192c7807c1de2f4193e77"
  end

  resource "mypy-boto3-cloudformation" do
    url "https://files.pythonhosted.org/packages/dc/1c/57ca59b5a7ad1560beaf8b6a3a22cfe22f355f3b67a7bd47ab77faad08fe/mypy_boto3_cloudformation-1.39.0.tar.gz"
    sha256 "734a9432dd9dbc58262424da6d04a4962cac6810c17a9933e6438180d2254129"
  end

  resource "mypy-boto3-ecr" do
    url "https://files.pythonhosted.org/packages/9a/2a/c4c09609d8bf1de6efe0dddf74ea87a575933c28df633f848ccd3c52cca2/mypy_boto3_ecr-1.39.11.tar.gz"
    sha256 "d6d231a2eba3e459a0532cfe5b9bdf6d5611307e45902601479a1e7213bdb57a"
  end

  resource "mypy-boto3-iam" do
    url "https://files.pythonhosted.org/packages/0f/9f/10db7d8f6591fc56901126c2dae8de5ef3bbe74f36f062c6efd24724ab25/mypy_boto3_iam-1.39.0.tar.gz"
    sha256 "6c2e3ec653222eb65993a80de8cc1f5c9e76fc15a66ad1537431cee241b1b15d"
  end

  resource "mypy-boto3-kinesis" do
    url "https://files.pythonhosted.org/packages/c4/17/a043312c11eb7e1b626438757a130dddb5581fd307654cc0e6f43e9e7129/mypy_boto3_kinesis-1.39.0.tar.gz"
    sha256 "cf9b01d8a1944299fea65be74d72b32b1a5210fa9681387184af2e2c2f4cea04"
  end

  resource "mypy-boto3-lambda" do
    url "https://files.pythonhosted.org/packages/33/e9/afbced105bfaac4b47b89aa6f9009cec78755ce22dd1d2d1ced3f174305c/mypy_boto3_lambda-1.39.11.tar.gz"
    sha256 "a9867ba54ced8cfd1e977afaee053d1264c8d64ef215fe8d132b9a3a4736fe07"
  end

  resource "mypy-boto3-s3" do
    url "https://files.pythonhosted.org/packages/3f/42/e6cb54fb2eeaf53fe74d4cab03e6979dabd2b8df6f94ab405a1f8dd7ffbc/mypy_boto3_s3-1.39.5.tar.gz"
    sha256 "b339a9128e96eaf74f87c40ee42711db82d31a45085ba78b262ae7683cb9e5f0"
  end

  resource "mypy-boto3-schemas" do
    url "https://files.pythonhosted.org/packages/ac/6b/911519a5f8ce42df327c76c0450aa74a4a93e0a146c519d5fe53bfca51d6/mypy_boto3_schemas-1.39.0.tar.gz"
    sha256 "a96ebfcc167aa8e7108a9454f62f4bc0583be6f310c28b7bf7563028f070a235"
  end

  resource "mypy-boto3-secretsmanager" do
    url "https://files.pythonhosted.org/packages/11/5f/04ba159d9f6ed9f02e6c8dc217b7272c76ba9e5544d52788d06fcd5ae7c6/mypy_boto3_secretsmanager-1.39.0.tar.gz"
    sha256 "e054bd86e942cf26c13596564a156d9f4dac4dc72479f1c5d1fafa9cf231290d"
  end

  resource "mypy-boto3-signer" do
    url "https://files.pythonhosted.org/packages/61/f4/ff1de2a3734ebf00d728f880b7a06f16801687d0fb8bbabeeb261c3ddc85/mypy_boto3_signer-1.39.0.tar.gz"
    sha256 "1d2f17c9e5db015974dc5df2d79180ebbe92605348b559ed11a5a13ba454c70e"
  end

  resource "mypy-boto3-sqs" do
    url "https://files.pythonhosted.org/packages/82/7d/cd6f63cc5c834d8e5cf1f6861d01739668accdbe2734fc8401dce4f12dea/mypy_boto3_sqs-1.39.14.tar.gz"
    sha256 "6057006cdf86f2c2f3676ed6574c412990fd12a4412b3a0b9556a7c922493ca7"
  end

  resource "mypy-boto3-stepfunctions" do
    url "https://files.pythonhosted.org/packages/40/97/50253d3ce589ad3d294c3db4af1aa278a589900c498d8d07cdd9dbc348d0/mypy_boto3_stepfunctions-1.39.8.tar.gz"
    sha256 "e9e2d2163c1f504e81158c9825e9328f93f931bc01a88401311ca6d6903aeec9"
  end

  resource "mypy-boto3-sts" do
    url "https://files.pythonhosted.org/packages/c2/cc/fe45576272b5f0f00a9d94de04afb589929c83acb938819c1c2a09cd3798/mypy_boto3_sts-1.39.0.tar.gz"
    sha256 "738a28cce009f15a254156aa38ac82841b77c7933f742c499cad4880b39b6102"
  end

  resource "mypy-boto3-xray" do
    url "https://files.pythonhosted.org/packages/9f/22/a12cd43a5318a07734f1f0d43bd7a0e3c6cdeb310416e7782448bf6f31b8/mypy_boto3_xray-1.39.0.tar.gz"
    sha256 "07a98b880a542e59cbfb8256400cf4b916a809d2bc03e27480eacb08c7ebf079"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/6c/4f/ccdb8ad3a38e583f214547fd2f7ff1fc160c43a75af88e6aec213404b96a/networkx-3.5.tar.gz"
    sha256 "d4c6f9cf81f52d69230866796b82afbccdec3db7ae4fbd1b65ea750feed50037"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/00/dd/4325abf92c39ba8623b5af936ddb36ffcfe0beae70405d456ab1fb2f5b8c/pydantic-2.11.7.tar.gz"
    sha256 "d989c3c6cb79469287b1569f7447a17848c998458d49ebe294e975b9baf0f0db"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/ad/88/5f2260bdfae97aabf98f1778d43f69574390ad787afb646292a638c923d4/pydantic_core-2.33.2.tar.gz"
    sha256 "7cb8bc3605c29176e1b105350d2e6474142d7c1bd1d9327c4a9bdb46bf827acc"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/04/8c/cd89ad05804f8e3c17dea8f178c3f40eeab5694c30e0c9f5bcd49f576fc3/pyopenssl-25.1.0.tar.gz"
    sha256 "8d031884482e0c67ee92bf9a4d8cceb08d92aba7136432ffb0703c5280fc205b"
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
    url "https://files.pythonhosted.org/packages/0b/de/e13fa6dc61d78b30ba47481f99933a3b49a57779d625c392d8036770a60d/regex-2025.7.34.tar.gz"
    sha256 "9ead9765217afd04a86822dfcd4ed2747dfe426e887da413b15ff0ac2457e21a"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/fe/75/af448d8e52bf1d8fa6a9d089ca6c07ff4453d86c65c145d0a300bb073b9b/rich-14.1.0.tar.gz"
    sha256 "e497a48b844b0320d45007cdebfeaeed8db2a4f4bcf49f15e455cfc4af11eaa8"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/1e/d9/991a0dee12d9fc53ed027e26a26a64b151d77252ac477e22666b9688bc16/rpds_py-0.27.0.tar.gz"
    sha256 "8b23cf252f180cda89220b378d917180f29d313cd6a07b2431c0d3b776aae86f"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/3e/db/f3950f5e5031b618aae9f423a39bf81a55c148aecd15a34527898e752cf4/ruamel.yaml-0.18.15.tar.gz"
    sha256 "dbfca74b018c4c3fba0b9cc9ee33e53c371194a9000e694995e620490fd40700"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/20/84/80203abff8ea4993a87d823a5f632e4d92831ef75d404c9fc78d0176d2b5/ruamel.yaml.clib-0.2.12.tar.gz"
    sha256 "6c8fbb13ec503f99a91901ab46e0b07ae7941cd527393187039aec586fdfd36f"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/6d/05/d52bf1e65044b4e5e27d4e63e8d1579dbdec54fce685908ae09bc3720030/s3transfer-0.13.1.tar.gz"
    sha256 "c3fdba22ba1bd367922f27ec8032d6a1cf5f10c934fb5d68cf60fd5a23d936cf"
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
    url "https://files.pythonhosted.org/packages/56/ce/5d84526a39f44c420ce61b16654193f8437d74b54f21597ea2ac65d89954/types_awscrt-0.27.6.tar.gz"
    sha256 "9d3f1865a93b8b2c32f137514ac88cb048b5bc438739945ba19d972698995bfb"
  end

  resource "types-python-dateutil" do
    url "https://files.pythonhosted.org/packages/a3/53/07dac71db45fb6b3c71c2fd29a87cada2239eac7ecfb318e6ebc7da00a3b/types_python_dateutil-2.9.0.20250809.tar.gz"
    sha256 "69cbf8d15ef7a75c3801d65d63466e46ac25a0baa678d89d0a137fc31a608cc1"
  end

  resource "types-s3transfer" do
    url "https://files.pythonhosted.org/packages/42/c1/45038f259d6741c252801044e184fec4dbaeff939a58f6160d7c32bf4975/types_s3transfer-0.13.0.tar.gz"
    sha256 "203dadcb9865c2f68fb44bc0440e1dc05b79197ba4a641c0976c26c9af75ef52"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/98/5a/da40306b885cc8c09109dc2e1abd358d5684b1425678151cdaed4731c822/typing_extensions-4.14.1.tar.gz"
    sha256 "38b39f4aeeab64884ce9f74c94263ef78f3c22467c8724005483154c26648d36"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/f8/b1/0c11f5058406b3af7609f121aaa6b609744687f1d158b3c3a5bf4cc94238/typing_inspection-0.4.1.tar.gz"
    sha256 "6ae134cc0203c33377d43188d4064e9b357dba58cff3185f22924610e70a9d28"
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