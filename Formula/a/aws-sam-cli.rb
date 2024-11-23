class AwsSamCli < Formula
  include Language::Python::Virtualenv

  desc "CLI tool to build, test, debug, and deploy Serverless applications using AWS SAM"
  homepage "https://aws.amazon.com/serverless/sam/"
  url "https://files.pythonhosted.org/packages/d3/13/5180ec17dff0a46cd2d068a0746e06fce9e2e66464301a168b57e5c33470/aws_sam_cli-1.131.0.tar.gz"
  sha256 "e675190d426103007d0da10cdce0f70475cbdefd5a9a4c78b663b0dd0cc438f8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e4a237f98370adfcc2791fcb996f2397a8df3d17bb34aef20ff5d6c7353a9ca3"
    sha256 cellar: :any,                 arm64_sonoma:  "e1a50d5d4805f90b174c49af60502db9d8996dadfac6799b8f6574b96b60ea80"
    sha256 cellar: :any,                 arm64_ventura: "3e7dbaee1dfedc9b319f65461cc2b9e72c5c7c7189c5c7873d812c1e6e9c6bcc"
    sha256 cellar: :any,                 sonoma:        "3e06b56634f101b73957256706eb8b2fe6b33148230d18f2bd6cd245905041e1"
    sha256 cellar: :any,                 ventura:       "7404fe29439a28bbba1bd28be778f7492174cd16c7fa92c356909d324aedec3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62f493d870542c91c3442d91a083742c3393cf1b9c457b8359eb18671782248d"
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
    url "https://files.pythonhosted.org/packages/fc/0f/aafca9af9315aee06a89ffde799a10a582fe8de76c563ee80bbcdc08b3fb/attrs-24.2.0.tar.gz"
    sha256 "5cfb1b9148b5b086569baec03f20d7b6bf3bcacc9a42bebf87ffaaca362f6346"
  end

  resource "aws-lambda-builders" do
    url "https://files.pythonhosted.org/packages/e8/8b/5ef23f75eb04ca39d3466724e360201ad5c8294fcee67ba39df2f67c1357/aws_lambda_builders-1.52.0.tar.gz"
    sha256 "eda67c6a16562ee9774b2ad0d9ece43653ff3f5a7f8176f77c2f94ece0607532"
  end

  resource "aws-sam-translator" do
    url "https://files.pythonhosted.org/packages/ef/2c/69276246bc22293aec595dac217e0ad8299053d05c8ff00a24d1f09395b3/aws_sam_translator-1.94.0.tar.gz"
    sha256 "8ec258d9f7ece72ef91c81f4edb45a2db064c16844b6afac90c575893beaa391"
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
    url "https://files.pythonhosted.org/packages/84/60/9120d532933b1401dd29b9264d8ddd7f30bd2e4e6b6c3fc42e33082ca5c5/boto3-1.35.67.tar.gz"
    sha256 "4eb793c45123fbca1b2b152ce0d18272d19126cf89809cd6698bf2dfc66270fb"
  end

  resource "boto3-stubs" do
    url "https://files.pythonhosted.org/packages/8e/cf/b4116eefdc95102271df2a47bef1db7ac88d1c1b938648c4302fe817150c/boto3_stubs-1.35.63.tar.gz"
    sha256 "cc471636d28f595bf750dc3c2079d16e988c9f518a66f50c9d62b0119c3f72cf"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/d4/7d/e4a141353a360c55a9604dc0c4227623b8908bab8f481b222a9c24668490/botocore-1.35.67.tar.gz"
    sha256 "d782e02f2949889cf97a140a89cd5e9363d0e4b0153db51faf7fc16305c6e0e1"
  end

  resource "botocore-stubs" do
    url "https://files.pythonhosted.org/packages/c0/ea/a8b9ce3696bd6ca33da1b77f4e9173a1b2045f9ec793ebe9c037063292b3/botocore_stubs-1.35.67.tar.gz"
    sha256 "21886510f4fd8f5804e4bb83661ba0e005e4c5236b89f70dd428e6cea68b0ee6"
  end

  resource "cfn-lint" do
    url "https://files.pythonhosted.org/packages/f3/ec/461834eb63deb38a05fedaa6ce563f67b1b883a12ecd01cc5f2709eca388/cfn_lint-1.19.0.tar.gz"
    sha256 "63835e083f7831e54c512bce4808754df221b5895aed9a114c71879d1cc4ebff"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/f2/4f/e1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1e/charset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
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
    url "https://files.pythonhosted.org/packages/52/17/9f2cd228eb949a91915acd38d3eecdc9d8893dde353b603f0db7e9f6be55/cookiecutter-2.6.0.tar.gz"
    sha256 "db21f8169ea4f4fdc2408d48ca44859349de2647fbe494a9d6c3edfc0542c21c"
  end

  resource "dateparser" do
    url "https://files.pythonhosted.org/packages/1a/b2/f6b29ab17d7959eb1a0a5c64f5011dc85051ad4e25e401cbddcc515db00f/dateparser-1.2.0.tar.gz"
    sha256 "7975b43a4222283e0ae15be7b4999d08c9a70e2d378ac87385b1ccf2cffbbb30"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/91/9b/4a2ea29aeba62471211598dac5d96825bb49348fa07e906ea930394a83ce/docker-7.1.0.tar.gz"
    sha256 "ad8c70e6e3f8926cb8a92619b832b4ea5299e2831c14284663184e200546fa6c"
  end

  resource "flask" do
    url "https://files.pythonhosted.org/packages/41/e1/d104c83026f8d35dfd2c261df7d64738341067526406b40190bc063e829a/flask-3.0.3.tar.gz"
    sha256 "ceb27b0af3823ea2737928a4d99d125a06175b8512c445cbd9a9ce200ef76842"
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
    url "https://files.pythonhosted.org/packages/ed/55/39036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5d/jinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
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
    url "https://files.pythonhosted.org/packages/10/db/58f950c996c793472e336ff3655b13fbcf1e3b359dcf52dcf3ed3b52c352/jsonschema_specifications-2024.10.1.tar.gz"
    sha256 "0f38b83639958ce1152d02a7f062902c41c8fd20d558b0c34344292d417ae272"
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
    url "https://files.pythonhosted.org/packages/01/11/9c82f90470f30024aec4a3a441e2da7bb8876268c3612182b149b7bbd524/mypy_boto3_apigateway-1.35.67.tar.gz"
    sha256 "7ee4e0957cd367f72e9aee5abdb2f7b5cefdc1da214e19272ef6741d0200299f"
  end

  resource "mypy-boto3-cloudformation" do
    url "https://files.pythonhosted.org/packages/4f/97/04c21049fb94ea9b5dc52cb5350042b822a5e3f8495e06403e442abc510a/mypy_boto3_cloudformation-1.35.64.tar.gz"
    sha256 "d1a1500df811ac8ebd459640f5b31c14daac784d8a00fc4f67bc6eb391e7b5a8"
  end

  resource "mypy-boto3-ecr" do
    url "https://files.pythonhosted.org/packages/69/1a/d2f342de76a55a3dd459293933a2e7cc7a0ef5a4701bb81ab969f4d9074c/mypy_boto3_ecr-1.35.21.tar.gz"
    sha256 "d7e8c24086ce3b259e4ac2a271fc34ed4effde99c7899ac7d64c2da3cff0acd7"
  end

  resource "mypy-boto3-iam" do
    url "https://files.pythonhosted.org/packages/c8/10/dd881ea65e5c160ffda8d7e0f1ab008ff4706d0632cac4bccc9f4c2bdf67/mypy_boto3_iam-1.35.61.tar.gz"
    sha256 "cf307f7fb2404ceda7fda455f6d4cf3bdf57e12a3b16d27101db6223c59e6fe7"
  end

  resource "mypy-boto3-kinesis" do
    url "https://files.pythonhosted.org/packages/78/10/ab59c97753f624748095bb8545000752eec98c0805559b2514230675e181/mypy_boto3_kinesis-1.35.26.tar.gz"
    sha256 "865f2697f62dfc7d04052436a925bdf0d39a9317cde8c6981a6ac46e659c1c7f"
  end

  resource "mypy-boto3-lambda" do
    url "https://files.pythonhosted.org/packages/b9/4d/aef6f910ca57af66e8d81a1021b15845bdb75e190b94ae26a4de578ca3d6/mypy_boto3_lambda-1.35.67.tar.gz"
    sha256 "6afb734624c8ab819b664c4e39fce4f0547272f383db105ff542b92cf3f03917"
  end

  resource "mypy-boto3-s3" do
    url "https://files.pythonhosted.org/packages/40/ea/159b28600a0d9b9d3136051f37b2e72d11297b3ad457e09956b529db54d0/mypy_boto3_s3-1.35.67.tar.gz"
    sha256 "aed7d2e8e384d40e7d7b1031293b4f99ad94ef2eaa1abc7c1aa060a9996ee99b"
  end

  resource "mypy-boto3-schemas" do
    url "https://files.pythonhosted.org/packages/d0/1d/c5a067eb7847fa88c9d18f4a38ce5369cef6782ee0a1f7e97371ae960c5d/mypy_boto3_schemas-1.35.0.tar.gz"
    sha256 "a63cbf1c5189e29638b7f1522357db080bfd99e142110a06df6192b5d68f0dc8"
  end

  resource "mypy-boto3-secretsmanager" do
    url "https://files.pythonhosted.org/packages/60/c4/66fe1c912c6ebf23c17d3003b77ef47c49250d879deb3ef5a902f94a7dac/mypy_boto3_secretsmanager-1.35.0.tar.gz"
    sha256 "c37d181315ba10d8546872304d7f266e7461429b08e63507c23cc508c3ef4264"
  end

  resource "mypy-boto3-signer" do
    url "https://files.pythonhosted.org/packages/c2/88/cbdb23d4351eedd9cd7ad6848f779ab547489524347a6b7109d509a853bf/mypy_boto3_signer-1.35.0.tar.gz"
    sha256 "06653bbc2b92f0ec390d2622e2a6cbad8a191ac758c21e0803d1151cd18c8232"
  end

  resource "mypy-boto3-sqs" do
    url "https://files.pythonhosted.org/packages/ee/e5/e8228deac8720ddd152c8ff8f55fa5ef27f1c256835dd98063cd754570c7/mypy_boto3_sqs-1.35.0.tar.gz"
    sha256 "61752f1c2bf2efa3815f64d43c25b4a39dbdbd9e472ae48aa18d7c6d2a7a6eb8"
  end

  resource "mypy-boto3-stepfunctions" do
    url "https://files.pythonhosted.org/packages/62/0d/5491e10a8f8c15078d9448a8d02ac2c36d6dd72e96cd940d1f06e079c9c1/mypy_boto3_stepfunctions-1.35.54.tar.gz"
    sha256 "2ee7940aa2bda046197e296a5ba9c0e7ccc5350b509fd7a883f0667c183e3bfe"
  end

  resource "mypy-boto3-sts" do
    url "https://files.pythonhosted.org/packages/18/0a/01f18c7350df047f15dabb47f145f6f0d98e5fe48a088bf506ec4d250276/mypy_boto3_sts-1.35.61.tar.gz"
    sha256 "37465ba1d3202cd39b508c346955f9a5a2597071300791a569cbbc2ad7ab4dd1"
  end

  resource "mypy-boto3-xray" do
    url "https://files.pythonhosted.org/packages/fc/ac/1d17dae0bf54c390436a971a7cc58e1a7b4fb20dfb2145a2646a5fa2bad0/mypy_boto3_xray-1.35.67.tar.gz"
    sha256 "36a4a1b7782777001083551ccd844496f71b42122fe4c3f95fc0a9d512a7317f"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/fd/1d/06475e1cd5264c0b870ea2cc6fdb3e37177c1e565c43f56ff17a10e3937f/networkx-3.4.2.tar.gz"
    sha256 "307c3669428c5362aab27c8a1260aa8f47c4e91d3891f48be0141738d8d053e1"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/c4/bd/7fc610993f616d2398958d0028d15eaf53bde5f80cb2edb7aa4f1feaf3a7/pydantic-2.10.1.tar.gz"
    sha256 "a4daca2dc0aa429555e0656d6bf94873a7dc5f54ee42b1f5873d666fb3f35560"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/a6/9f/7de1f19b6aea45aeb441838782d68352e71bfa98ee6fa048d5041991b33e/pydantic_core-2.27.1.tar.gz"
    sha256 "62a763352879b84aa31058fc931884055fd75089cccbd9d58bb6afd01141b235"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/8e/62/8336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31/pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/5d/70/ff56a63248562e77c0c8ee4aefc3224258f1856977e0c1472672b62dadb8/pyopenssl-24.2.1.tar.gz"
    sha256 "4247f0dbe3748d560dcbb2ff3ea01af0f9a1a001ef5f7c4c647956ed8cbf0e95"
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
    url "https://files.pythonhosted.org/packages/3a/31/3c70bf7603cc2dca0f19bdc53b4537a797747a58875b552c8c413d963a3f/pytz-2024.2.tar.gz"
    sha256 "2aa355083c50a0f93fa581709deac0c9ad65cca8a9e9beac660adcbd493c798a"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/99/5b/73ca1f8e72fff6fa52119dbd185f73a907b1989428917b24cff660129b6d/referencing-0.35.1.tar.gz"
    sha256 "25b42124a6c8b632a425174f24087783efb348a6f1e0008e63cd4466fedf703c"
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
    url "https://files.pythonhosted.org/packages/23/80/afdf96daf9b27d61483ef05b38f282121db0e38f5fd4e89f40f5c86c2a4f/rpds_py-0.21.0.tar.gz"
    sha256 "ed6378c9d66d0de903763e7706383d60c33829581f0adff47b6535f1802fa6db"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/29/81/4dfc17eb6ebb1aac314a3eb863c1325b907863a1b8b1382cdffcb6ac0ed9/ruamel.yaml-0.18.6.tar.gz"
    sha256 "8b27e6a217e786c6fbe5634d8f3f11bc63e0f80f6a5890f28863d9c45aac311b"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/c0/0a/1cdbabf9edd0ea7747efdf6c9ab4e7061b085aa7f9bfc36bb1601563b069/s3transfer-0.10.4.tar.gz"
    sha256 "29edc09801743c21eb5ecbc617a152df41d3c287f67b615f73e5f750583666a7"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/43/54/292f26c208734e9a7f067aea4a7e282c080750c4546559b58e2e45413ca0/setuptools-75.6.0.tar.gz"
    sha256 "8199222558df7c86216af4f84c30e9b34a61d8ba19366cc914424cdbd28252f6"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "sympy" do
    url "https://files.pythonhosted.org/packages/11/8a/5a7fd6284fa8caac23a26c9ddf9c30485a48169344b4bd3b0f02fef1890f/sympy-1.13.3.tar.gz"
    sha256 "b27fd2c6530e0ab39e275fc9b683895367e51d5da91baa8d3d64db2565fec4d9"
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
    url "https://files.pythonhosted.org/packages/dd/23/7de2052a76ec03cdc56cb425efbcb80e9d779a188cd1ae44e8524c717c35/types_awscrt-0.23.0.tar.gz"
    sha256 "3fd1edeac923d1956c0e907c973fb83bda465beae7f054716b371b293f9b5fdc"
  end

  resource "types-python-dateutil" do
    url "https://files.pythonhosted.org/packages/31/f8/f6ee4c803a7beccffee21bb29a71573b39f7037c224843eff53e5308c16e/types-python-dateutil-2.9.0.20241003.tar.gz"
    sha256 "58cb85449b2a56d6684e41aeefb4c4280631246a0da1a719bdbe6f3fb0317446"
  end

  resource "types-s3transfer" do
    url "https://files.pythonhosted.org/packages/dd/8f/5cf8bea1470f9d0af8a8a8e232bc9d94eb2b8c040f1c19e673fcd3ba488c/types_s3transfer-0.10.4.tar.gz"
    sha256 "03123477e3064c81efe712bf9d372c7c72f2790711431f9baa59cf96ea607267"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/04/d3/c19d65ae67636fe63953b20c2e4a8ced4497ea232c43ff8d01db16de8dc0/tzlocal-5.2.tar.gz"
    sha256 "8d399205578f1a9342816409cc1e46a93ebd5755e39ea2d85334bea911bf0e6e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ed/63/22ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260/urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
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
    url "https://files.pythonhosted.org/packages/e7/52/fd4516fb8f7d11a08e3f9cd69eb1558f098ab67e79f32d920c4974ee550f/wheel-0.45.0.tar.gz"
    sha256 "a57353941a3183b3d5365346b567a260a0602a0f8a635926a7dede41b94c674a"
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