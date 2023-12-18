class Flintrock < Formula
  include Language::Python::Virtualenv

  desc "Tool for launching Apache Spark clusters"
  homepage "https:github.comnchammasflintrock"
  url "https:files.pythonhosted.orgpackagese93b810c7757f6abb0a73a50c2da6da2dacb5af85a04b056aef81323b2b6a082Flintrock-2.1.0.tar.gz"
  sha256 "dde4032630ad44c374c2a9b12f0d97db87fa5117995f1c7dd0f70b631f47a035"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "08b7a6ab1af7834ea9fd2fed66a6afb2e877f782c7a913c9c92fa65d4fd19f7f"
    sha256 cellar: :any,                 arm64_ventura:  "9a2a41173acb8eb811d77bd52a274aa2651887eb2f60052db1543d1349652cbb"
    sha256 cellar: :any,                 arm64_monterey: "e9f8bbc3a49676cd4f18a89468e0e4e0a79cb9d05ba390e9bb44f66d394032e3"
    sha256 cellar: :any,                 sonoma:         "0ec71f114567a3f12eecc274c7fdb04f0c71e5dbb942b883a1b857f068635d68"
    sha256 cellar: :any,                 ventura:        "e7666a403ab3c40986fb66d5b477d950b1b712379c5d0bed67558dc3247b4c7f"
    sha256 cellar: :any,                 monterey:       "5005a42f59063cf7a42de6227dd630ad5d5f7791b10bd79fa309b3837a0411a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0bacf1f16f1a2a814131855981faa98b79fffdf238bc946d0617eab54c21b9d"
  end

  depends_on "rust" => :build # for bcrypt
  depends_on "cffi"
  depends_on "python-cryptography"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  resource "bcrypt" do
    url "https:files.pythonhosted.orgpackages8cae3af7d006aacf513975fd1948a6b4d6f8b4a307f8a244e1a3d3774b297aadbcrypt-4.0.1.tar.gz"
    sha256 "27d375903ac8261cfe4047f6709d16f7d18d39b1ec92aaf72af989552a650ebd"
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
    url "https:files.pythonhosted.orgpackages4cc413b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "s3transfer" do
    url "https:files.pythonhosted.orgpackages3fff5fd9375f3fe467263cff9cad9746fd4c4e1399440ea9563091c958ff90b5s3transfer-0.7.0.tar.gz"
    sha256 "fd3889a66f5fe17299fe75b82eae6cf722554edca744ca5d5fe308b104883d2e"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesaf47b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3curllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

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