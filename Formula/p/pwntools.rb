class Pwntools < Formula
  include Language::Python::Virtualenv

  desc "CTF framework used by Gallopsled in every CTF"
  homepage "https:github.comGallopsledpwntools"
  url "https:files.pythonhosted.orgpackages3c8018fad749ce87aea82f37b81e5306b21c2f3493b9a3ee01a5b728f9fbfa74pwntools-4.11.1.tar.gz"
  sha256 "ee19e35fbdb5b7463329c27be51fad11f508e84f5bc4c617504b48e7a18364fd"
  license "MIT"
  head "https:github.comGallopsledpwntools.git", branch: "dev"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "e7c75f2ec2140ff5b644e3cc0211abd5fc9c6a645a19f1cd3cab3379731dfba5"
    sha256 cellar: :any,                 arm64_ventura:  "8b39d5cf83e835db9265717f8d9549877384c06130cfb8139c24c14cee20342f"
    sha256 cellar: :any,                 arm64_monterey: "f838fbf305692a744137b04c5d602f6a44b8f12e35bdbca91a0c1e0e854b2527"
    sha256 cellar: :any,                 sonoma:         "c3e636c140608b937571a0deb6c6f60930f609ca5681cc303a5bdda34c1684dd"
    sha256 cellar: :any,                 ventura:        "8dd9187b03d648b8fe00fece4340dc1d170ae515a17837ca41757b1a257d19d4"
    sha256 cellar: :any,                 monterey:       "caf8b626881ddbb3c18821ae1c79e7f6086abaaded95c676e18333bdad942668"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75294547b521de1c95d14f94bc9c67f99c2b044dd0249b7d207f55241a96000c"
  end

  depends_on "rust" => :build # for bcrypt
  depends_on "cffi"
  depends_on "pycparser"
  depends_on "pygments"
  depends_on "python-certifi"
  depends_on "python-cryptography"
  depends_on "python-dateutil"
  depends_on "python-mako"
  depends_on "python-markupsafe"
  depends_on "python-packaging"
  depends_on "python-psutil"
  depends_on "python-requests"
  depends_on "python@3.12"
  depends_on "six"
  depends_on "unicorn"

  uses_from_macos "libffi"

  conflicts_with "moreutils", because: "both install an `errno` executable"

  resource "bcrypt" do
    url "https:files.pythonhosted.orgpackages8cae3af7d006aacf513975fd1948a6b4d6f8b4a307f8a244e1a3d3774b297aadbcrypt-4.0.1.tar.gz"
    sha256 "27d375903ac8261cfe4047f6709d16f7d18d39b1ec92aaf72af989552a650ebd"
  end

  resource "capstone" do
    url "https:files.pythonhosted.orgpackages7afee6cdc4ad6e0d9603fa662d1ccba6301c0cb762a1c90a42c7146a538c24e9capstone-5.0.1.tar.gz"
    sha256 "740afacc29861db591316beefe30df382c4da08dcb0345a0d10f0cac4f8b1ee2"
  end

  resource "colored-traceback" do
    url "https:files.pythonhosted.orgpackages9a8b0a4e2a8cdc14279b265532f11c9cb75396880e6295c99a0bed7281b6076acolored-traceback-0.3.0.tar.gz"
    sha256 "6da7ce2b1da869f6bb54c927b415b95727c4bb6d9a84c4615ea77d9872911b05"
  end

  resource "intervaltree" do
    url "https:files.pythonhosted.orgpackages50fb396d568039d21344639db96d940d40eb62befe704ef849b27949ded5c3bbintervaltree-3.1.0.tar.gz"
    sha256 "902b1b88936918f9b2a19e0e5eb7ccb430ae45cde4f39ea4b36932920d33952d"
  end

  resource "paramiko" do
    url "https:files.pythonhosted.orgpackages4403158ae1dcb950bd96f04038502238159e116fafb27addf5df1ba35068f2d6paramiko-3.3.1.tar.gz"
    sha256 "6a3777a961ac86dbef375c5f5b8d50014a1a96d0fd7f054a43bc880134b0ff77"
  end

  resource "plumbum" do
    url "https:files.pythonhosted.orgpackages8e3d6bbc1b93fd394f6cc9fbe098d8e2740063d58c36dd8da876f790458ded46plumbum-1.8.2.tar.gz"
    sha256 "9e6dc032f4af952665f32f3206567bc23b7858b1413611afe603a3f8ad9bfd75"
  end

  resource "pyelftools" do
    url "https:files.pythonhosted.orgpackages8405fd41cd647de044d1ffec90ce5aaae935126ac217f8ecb302186655284fc8pyelftools-0.30.tar.gz"
    sha256 "2fc92b0d534f8b081f58c7c370967379123d8e00984deb53c209364efd575b40"
  end

  resource "pynacl" do
    url "https:files.pythonhosted.orgpackagesa72227582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986daPyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "pyserial" do
    url "https:files.pythonhosted.orgpackages1e7dae3f0a63f41e4d2f6cb66a5b57197850f919f59e558159a4dd3a818f5082pyserial-3.5.tar.gz"
    sha256 "3c77e014170dfffbd816e6ffc205e9842efb10be9f58ec16d3e8675b4925cddb"
  end

  resource "pysocks" do
    url "https:files.pythonhosted.orgpackagesbd11293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "ropgadget" do
    url "https:files.pythonhosted.orgpackages0f5f55add023bd2af62dc25f17bb0f26360e228ecb5cb4c0182a714a01672000ROPGadget-7.4.tar.gz"
    sha256 "a40626a32cf867d06192ef24e16221b2b7ba82e2ec84ab5bfdfb0b017559342f"
  end

  resource "rpyc" do
    url "https:files.pythonhosted.orgpackages0fe0a584823afecc5d8a0c18c46da4e028876e3e34946e6e3b2c3d430cd19b18rpyc-5.3.1.tar.gz"
    sha256 "f2233174879faf18ae266437d5a65511ce46c817cec4edc1344f036758cfbf52"
  end

  resource "sortedcontainers" do
    url "https:files.pythonhosted.orgpackagese8c4ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  resource "unicorn" do
    url "https:files.pythonhosted.orgpackages64c71a571a06adda2a9802e21d84398c5547761cb28b22f59a2c5db62bf23887unicorn-2.0.1.post1.tar.gz"
    sha256 "7fc69523eb83b4c8abc7cb4410ca21875e066c34b7afe998f59481e830d28e56"
  end

  def install
    ENV["LIBUNICORN_PATH"] = Formula["unicorn"].opt_lib
    virtualenv_install_with_resources
    bin.each_child do |f|
      f.unlink
      # Use env scripts to help unicorn python bindings dynamically load shared library
      f.write_env_script libexec"bin"f.basename, LIBUNICORN_PATH: Formula["unicorn"].opt_lib
    end
    bash_completion.install "extrabash_completion.dpwn"
    zsh_completion.install "extrazsh_completion_pwn"
  end

  test do
    assert_equal "686f6d6562726577696e7374616c6c636f6d706c657465",
                 shell_output("#{bin}hex homebrewinstallcomplete").strip
  end
end