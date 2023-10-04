class CfnLint < Formula
  include Language::Python::Virtualenv

  desc "Validate CloudFormation templates against the CloudFormation spec"
  homepage "https://github.com/aws-cloudformation/cfn-lint/"
  url "https://files.pythonhosted.org/packages/44/e8/f677fb4b83bbad27986acee442907848ff853c9eedbb465b3936cd390f70/cfn-lint-0.80.4.tar.gz"
  sha256 "53589cc4c2002bdf6c21c91f43e78a17dfbef2e870d7f45b0cbcb57bc76418d0"
  license "MIT-0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f9174c50be1aad6163a8afd0d54097a67a762d3e17598898853551355b9e6990"
    sha256 cellar: :any,                 arm64_ventura:  "277bddc4e799c631a948c52acf645d3c0c3de2f50a4df07dcd868e4bbbb552f6"
    sha256 cellar: :any,                 arm64_monterey: "bb238ace944685eb51ad58f6b2a6779c67b8259add003c3c980b9382d71e5dc5"
    sha256 cellar: :any,                 sonoma:         "3a979c7a9b1137deb87057a18a7f9d2e66fc6afd9657c4c3d82e0a8d6226e27b"
    sha256 cellar: :any,                 ventura:        "fb4411b0c8bcd79649655f84ae422d7410b86f7c61320d3015a2045b0c038ca6"
    sha256 cellar: :any,                 monterey:       "dbc274d83b584e6602efd1ea5a32a4a01fb96bded61be7674ff41ec35379af64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c6f89e35ce31a4ca48ea4b4aaf8c148a05de88ae861898311ebf6a6c9c80edf"
  end

  depends_on "rust" => :build
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/42/97/41ccb6acac36fdd13592a686a21b311418f786f519e5794b957afbcea938/annotated_types-0.5.0.tar.gz"
    sha256 "47cdc3490d9ac1506ce92c7aaa76c579dc3509ff11e098fc867e5130ab7be802"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "aws-sam-translator" do
    url "https://files.pythonhosted.org/packages/bd/29/a3012fcdab2c295703ebf574b8651759bd85ee98d8f265d7fceb8c3e2727/aws-sam-translator-1.76.0.tar.gz"
    sha256 "6d0d68071071bd54c11ec69346a5a52db22cc316bfa2cb6f827a36a9348bbf00"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/a8/23/ef75674c1ef3bf77479a5566a1a7c642206298feec1f7012e4710a5b35f4/boto3-1.28.58.tar.gz"
    sha256 "2f18d2dac5d9229e8485b556eb58b7b95fca91bbf002f63bf9c39209f513f6e6"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/77/1d/bd7a7383a2aff3cbf01c758a5507106ac7459707b241d8afbf336520f142/botocore-1.31.58.tar.gz"
    sha256 "002f8bdca8efde50ae7267f342bc1d03a71d76024ce3949e4ffdd1151581c53e"
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
    url "https://files.pythonhosted.org/packages/e4/43/087b24516db11722c8687e0caf0f66c7785c0b1c51b0ab951dfde924e3f5/jsonschema-4.19.1.tar.gz"
    sha256 "ec84cc37cfa703ef7cd4928db24f9cb31428a5d0fa77747b8b51a847458e0bbf"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/12/ce/eb5396b34c28cbac19a6a8632f0e03d309135d77285536258b82120198d8/jsonschema_specifications-2023.7.1.tar.gz"
    sha256 "c91a50404e88a1f6ba40636778e2ee08f6e24c5613fe4c53ac24578a5a7f72bb"
  end

  resource "junit-xml" do
    url "https://files.pythonhosted.org/packages/98/af/bc988c914dd1ea2bc7540ecc6a0265c2b6faccc6d9cdb82f20e2094a8229/junit-xml-1.9.tar.gz"
    sha256 "de16a051990d4e25a3982b2dd9e89d671067548718866416faec14d9de56db9f"
  end

  resource "mpmath" do
    url "https://files.pythonhosted.org/packages/e0/47/dd32fa426cc72114383ac549964eecb20ecfd886d1e5ccf5340b55b02f57/mpmath-1.3.0.tar.gz"
    sha256 "7a28eb2a9774d00c7bc92411c19a89209d5da7c4c9a9e227be8330a23a25b91f"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/fd/a1/47b974da1a73f063c158a1f4cc33ed0abf7c04f98a19050e80c533c31f0c/networkx-3.1.tar.gz"
    sha256 "de346335408f84de0eada6ff9fafafff9bcda11f0a0dfaa931133debb146ab61"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/02/d8/acee75603f31e27c51134a858e0dea28d321770c5eedb9d1d673eb7d3817/pbr-5.11.1.tar.gz"
    sha256 "aefc51675b0b533d56bb5fd1c8c6c0522fe31896679882e1c4c63d5e4a0fccb3"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/df/e8/4f94ebd6972eff3babcea695d9634a4d60bea63955b9a4a413ec2fd3dd41/pydantic-2.4.2.tar.gz"
    sha256 "94f336138093a5d7f426aac732dcfe7ab4eb4da243c88f891d65deb4a2556ee7"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/af/31/8e466c6ed47cddf23013d2f2ccf3fdb5b908ffa1d5c444150c41690d6eca/pydantic_core-2.10.1.tar.gz"
    sha256 "0f8682dbdd2f67f8e1edddcbffcc29f60a6182b4901c367fc8c1c40d30bb0a82"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/e1/43/d3f6cf3e1ec9003520c5fb31dc363ee488c517f09402abd2a1c90df63bbb/referencing-0.30.2.tar.gz"
    sha256 "794ad8003c65938edcdbc027f1933215e0d0ccc0291e3ce20a4d87432b59efc0"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/4f/1d/6998ba539616a4c8f58b07fd7c9b90c6b0f0c0ecbe8db69095a6079537a7/regex-2023.8.8.tar.gz"
    sha256 "fcbdc5f2b0f1cd0f6a56cdb46fe41d2cce1e644e3b68832f3eeebc5fb0f7712e"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/52/fa/31c7210f4430317c890ed0c8713093843442a98d8a9cafd0333c0040dda4/rpds_py-0.10.3.tar.gz"
    sha256 "fcc1ebb7561a3e24a6588f7c6ded15d80aec22c66a070c757559b57b17ffd1cb"
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

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/dd/19/9e5c8b813a8bddbfb035fa2b0c29077836ae7c4def1a55ae4632167b3511/urllib3-1.26.17.tar.gz"
    sha256 "24d6a242c28d29af46c3fae832c36db3bbebcc533dd1bb549172cd739c82df21"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.yml").write <<~EOS
      ---
      AWSTemplateFormatVersion: '2010-09-09'
      Resources:
        # Helps tests map resource types
        IamPipeline:
          Type: "AWS::CloudFormation::Stack"
          Properties:
            TemplateURL: !Sub 'https://s3.${AWS::Region}.amazonaws.com/bucket-dne-${AWS::Region}/${AWS::AccountId}/pipeline.yaml'
            Parameters:
              DeploymentName: iam-pipeline
              Deploy: 'auto'
    EOS
    system bin/"cfn-lint", "test.yml"
  end
end