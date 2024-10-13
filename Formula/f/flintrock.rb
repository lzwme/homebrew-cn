class Flintrock < Formula
  include Language::Python::Virtualenv

  desc "Tool for launching Apache Spark clusters"
  homepage "https:github.comnchammasflintrock"
  url "https:files.pythonhosted.orgpackagese93b810c7757f6abb0a73a50c2da6da2dacb5af85a04b056aef81323b2b6a082Flintrock-2.1.0.tar.gz"
  sha256 "dde4032630ad44c374c2a9b12f0d97db87fa5117995f1c7dd0f70b631f47a035"
  license "Apache-2.0"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia: "84bca8bca368c21eaafa710a457f74120346b3611cab5aac263427b7e8bd2236"
    sha256 cellar: :any,                 arm64_sonoma:  "4f5d5ef9dc37755565da9fa8b21f621e1a5e167092b658a1687ec6f78c91f53e"
    sha256 cellar: :any,                 arm64_ventura: "81134bba313d8270dee332fe202236b5e1d6c98c917e93448b34154aa3e84b84"
    sha256 cellar: :any,                 sonoma:        "f5fd3658354160becdb593cb4df9f8f3c2e01a56005fda007e9765ce5e564e52"
    sha256 cellar: :any,                 ventura:       "714f80484882b63542b61a453d8b9f585e7f139ef0d9f6ea511404c078e6d33e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e1affc168eb3958229daa48df03c75901625d9805a5b62af7751f797fa35185"
  end

  depends_on "rust" => :build # for bcrypt
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "bcrypt" do
    url "https:files.pythonhosted.orgpackagese47ed95e7d96d4828e965891af92e43b52a4cd3395dc1c1ef4ee62748d0471d0bcrypt-4.2.0.tar.gz"
    sha256 "cf69eaf5185fd58f268f805b505ce31f9b9fc2d64b376642164e9244540c1221"
  end

  resource "boto3" do
    url "https:files.pythonhosted.orgpackages8d5f4ee13ee77641c98032fcddb51456a26976f69365fdc3c6c9e699970b9e99boto3-1.29.4.tar.gz"
    sha256 "ca9b04fc2c75990c2be84c43b9d6edecce828960fc27e07ab29036587a1ca635"
  end

  resource "botocore" do
    url "https:files.pythonhosted.orgpackages106fe7fe287501ae0bb2732e0752dde93c4a2ad1922953be16dd912acc2c26bebotocore-1.32.4.tar.gz"
    sha256 "6bfa75e28c9ad0321cefefa51b00ff233b16b2416f8b95229796263edba45a39"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "jmespath" do
    url "https:files.pythonhosted.orgpackages002ae867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "paramiko" do
    url "https:files.pythonhosted.orgpackages4403158ae1dcb950bd96f04038502238159e116fafb27addf5df1ba35068f2d6paramiko-3.3.1.tar.gz"
    sha256 "6a3777a961ac86dbef375c5f5b8d50014a1a96d0fd7f054a43bc880134b0ff77"
  end

  resource "pynacl" do
    url "https:files.pythonhosted.orgpackagesa72227582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986daPyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "s3transfer" do
    url "https:files.pythonhosted.orgpackages3fff5fd9375f3fe467263cff9cad9746fd4c4e1399440ea9563091c958ff90b5s3transfer-0.7.0.tar.gz"
    sha256 "fd3889a66f5fe17299fe75b82eae6cf722554edca744ca5d5fe308b104883d2e"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesaf47b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3curllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  # patch to update pyyaml to build with py3.13, upstream pr ref, https:github.comnchammasflintrockpull380
  patch :DATA

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    system bin"flintrock"
    msg = shell_output("#{bin}flintrock destroy fascism 2>&1", 1)
    assert_match "could not find your AWS credentials", msg
  end
end

__END__
diff --git asetup.py bsetup.py
index e95a10e..02925e7 100644
--- asetup.py
+++ bsetup.py
@@ -53,7 +53,7 @@ setuptools.setup(
         'botocore == 1.32.4',
         'click == 8.1.7',
         'paramiko == 3.3.1',
-        'PyYAML == 6.0.1',
+        'PyYAML == 6.0.2',
     ],
 
     entry_points={