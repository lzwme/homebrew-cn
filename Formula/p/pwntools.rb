class Pwntools < Formula
  include Language::Python::Virtualenv

  desc "CTF framework used by Gallopsled in every CTF"
  homepage "https:github.comGallopsledpwntools"
  url "https:files.pythonhosted.orgpackages09cb82243a56a8b92451d97ad1792e67cbe8dbc9f9dec2a869a58839993ccca4pwntools-4.12.0.tar.gz"
  sha256 "320285bd9266152fdba3b81de3a31e61a25076645507a38d85f34e1b15998eb1"
  license "MIT"
  head "https:github.comGallopsledpwntools.git", branch: "dev"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c0fe300107661624501208edf382745ba8d0a9477ed59403618b2285f8776b54"
    sha256 cellar: :any,                 arm64_ventura:  "a2763f00317df93bcd571fa023c5340bdf6b7c959ed24312521aa1ecf3a9f3bc"
    sha256 cellar: :any,                 arm64_monterey: "44ad4dd9062238d0ec2c8cfeac0d9f5b65489cc3c9e7464662a2b6b091cf85fe"
    sha256 cellar: :any,                 sonoma:         "8e38bd8cd56b898e8a058668889150f82a28116094dbc5eff53fdf55bd7c35a3"
    sha256 cellar: :any,                 ventura:        "fc9871b677eec6cd899777f3a7f1537a1e7d989531ac8ef8d132174471e85a21"
    sha256 cellar: :any,                 monterey:       "e2c8068e035a5bc5366d66e5d16affd647305856cb942c1efdc79c497d27778e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45e4226c60b5bb85e50697599b00ba192ade8d5d12addb4b8db107e0d1e0ea7e"
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
    url "https:files.pythonhosted.orgpackages72076a6f2047a9dc9d012b7b977e4041d37d078b76b44b7ee4daf331c1e6fb35bcrypt-4.1.2.tar.gz"
    sha256 "33313a1200a3ae90b75587ceac502b048b840fc69e7f7a0905b5f87fac7a1258"
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
    url "https:files.pythonhosted.orgpackagesccaf11996c4df4f9caff87997ad2d3fd8825078c277d6a928446d2b6cf249889paramiko-3.4.0.tar.gz"
    sha256 "aac08f26a31dc4dffd92821527d1682d99d52f9ef6851968114a8728f3c274d3"
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

  resource "unix-ar" do
    url "https:files.pythonhosted.orgpackages3e3765cb206bd7110887248fe041e00e61124abdcd23de8f19418898a51363fcunix_ar-0.2.1.tar.gz"
    sha256 "bf9328ec70fa3a82f94dc26dc125264dbf62a2d8ffb1a3c8c8a8230175e72c4e"
  end

  resource "zstandard" do
    url "https:files.pythonhosted.orgpackages5d912162ab4239b3bd6743e8e407bc2442fca0d326e2d77b3f4a88d90ad5a1fazstandard-0.22.0.tar.gz"
    sha256 "8226a33c542bcb54cd6bd0a366067b610b41713b64c9abec1bc4533d69f51e70"
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