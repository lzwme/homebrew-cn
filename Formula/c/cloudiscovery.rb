class Cloudiscovery < Formula
  include Language::Python::Virtualenv

  desc "Help you discover resources in the cloud environment"
  homepage "https:github.comCloud-Architectscloudiscovery"
  url "https:files.pythonhosted.orgpackagesd3c29a5f93ac5376f83903c8550bde45e2888da3fb092b63e02e19d6c852134ccloudiscovery-2.4.4.tar.gz"
  sha256 "1170ea352a3c7d5643652ebe96b068482734cd995b9c92dc820206f1b87407e5"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ede59442132c867b152828f3e1d6319b4fa79a684f147894efcffe47afa39a64"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd4f9f60e99574607aadce72237a18c5dfe061f685b466d172b1cac80f5c63d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f266ba342a75d4ac5361196c6231e445b3210c86a2ee60e36fcd426fd546c97"
    sha256 cellar: :any_skip_relocation, sonoma:         "6276ddc13fb94ecba41b68f2f7adf8c8a12949854a67906cc83a3c50c1d669a7"
    sha256 cellar: :any_skip_relocation, ventura:        "41e77eedf1b3e157787e3b87b6566e39a10d590d4135c1aa13a47954b9254fd0"
    sha256 cellar: :any_skip_relocation, monterey:       "952dcbb35850c6b99d3593a7ea3f961c19c11ce9b0c1c3b530ca24ec01128b90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e97e95bcae08b01c0721862baf395c44ed68aa518ada04bdc2604d75415b0348"
  end

  depends_on "python-pytz"
  depends_on "python-setuptools"
  depends_on "python@3.12"
  depends_on "six"

  # markupsafe needs to pinned to 2.0.1
  # see PR, https:github.comHomebrewhomebrew-corepull151558

  resource "boto3" do
    url "https:files.pythonhosted.orgpackages4bcd9331ee4ecdbfd58e268664fc1126e7aa015a31ce088b0c1e3cf48bb56e97boto3-1.28.66.tar.gz"
    sha256 "38658585791f47cca3fc6aad03838de0136778b533e8c71c6a9590aedc60fbde"
  end

  resource "botocore" do
    url "https:files.pythonhosted.orgpackagesed19489d319b286f629be7c56025dfc0df41e69166eb559996bd07f664b2c63dbotocore-1.31.66.tar.gz"
    sha256 "70e94a5f9bd46b26b63a41fb441ad35f2ae8862ad9d90765b6fa31ccc02c0a19"
  end

  resource "cachetools" do
    url "https:files.pythonhosted.orgpackages9d8b8e2ebf5ee26c21504de5ea2fb29cc6ae612b35fd05f959cdb641feb94ec4cachetools-5.3.1.tar.gz"
    sha256 "dce83f2d9b4e1f732a8cd44af8e8fab2dbe46201467fc98b3ef8f269092bf62b"
  end

  resource "diagrams" do
    url "https:files.pythonhosted.orgpackages1bee3070e64c5e468d1f3a0a04c2863cff633b2263b33265a82df1f1e8c82a36diagrams-0.23.3.tar.gz"
    sha256 "543c707c36a2c896dfdf8f23e993a9c7ae48bb1a667f6baf19151eb98e57a134"
  end

  resource "diskcache" do
    url "https:files.pythonhosted.orgpackages3f211c1ffc1a039ddcc459db43cc108658f32c57d271d7289a2794e401d0fdb6diskcache-5.6.3.tar.gz"
    sha256 "2c3a3fa2743d8535d832ec61c2054a1641f41775aa7c556758a109941e33e4fc"
  end

  resource "graphviz" do
    url "https:files.pythonhosted.orgpackagesa590fb047ce95c1eadde6ae78b3fca6a598b4c307277d4f8175d12b18b8f7321graphviz-0.20.1.zip"
    sha256 "8c58f14adaa3b947daf26c19bc1e98c4e0702cdc31cf99153e6f06904d492bf8"
  end

  resource "ipaddress" do
    url "https:files.pythonhosted.orgpackagesb99a3e9da40ea28b8210dd6504d3fe9fe7e013b62bf45902b458d1cdc3c34ed9ipaddress-1.0.23.tar.gz"
    sha256 "b7f8e0369580bb4a24d5ba1d7cc29660a4a6987763faf1d8a8046830e020e7e2"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackages4fe765300e6b32e69768ded990494809106f87da1d436418d5f1367ed3966fd7Jinja2-2.11.3.tar.gz"
    sha256 "a6d58433de0ae800347cab1fa3043cebbabe8baa9d29e668f1c768cb87a333c6"
  end

  resource "jmespath" do
    url "https:files.pythonhosted.orgpackages002ae867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackagesbf10ff66fea6d1788c458663a84d88787bae15d45daa16f6b3ef33322a51fc7eMarkupSafe-2.0.1.tar.gz"
    sha256 "594c67807fb16238b30c44bdf74f36c02cdf22d1c8cda91ef8a0ed8dabf5620a"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages4cc413b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "s3transfer" do
    url "https:files.pythonhosted.orgpackages3fff5fd9375f3fe467263cff9cad9746fd4c4e1399440ea9563091c958ff90b5s3transfer-0.7.0.tar.gz"
    sha256 "fd3889a66f5fe17299fe75b82eae6cf722554edca744ca5d5fe308b104883d2e"
  end

  resource "typed-ast" do
    url "https:files.pythonhosted.orgpackagesf97ea424029f350aa8078b75fd0d360a787a273ca753a678d1104c5fa4f3072atyped_ast-1.5.5.tar.gz"
    sha256 "94282f7a354f36ef5dbce0ef3467ebf6a258e370ab33d5b40c249fa996e590dd"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesaf47b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3curllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "{aws-vpc,aws-iot,aws-policy,aws-all,aws-limit,aws-security}",
      shell_output(bin"cloudiscovery --help 2>&1")

    assert_match "Neither region parameter nor region config were passed",
      shell_output(bin"cloudiscovery aws-vpc --vpc-id vpc-123 2>&1")
  end
end