class Pwntools < Formula
  include Language::Python::Virtualenv

  desc "CTF framework used by Gallopsled in every CTF"
  homepage "https:github.comGallopsledpwntools"
  url "https:files.pythonhosted.orgpackages21941f39d5a770226b9d240c9900c5c912788fb31f8f189aacd81153c0d59f67pwntools-4.14.1.tar.gz"
  sha256 "60f04976d1722120d18b9d50553408a024664b5cf888f36f258afca4bf035cac"
  license "MIT"
  revision 1
  head "https:github.comGallopsledpwntools.git", branch: "dev"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5ae3380e9dd319159411c2f804051c4115c4e64156391f5f66110bc412ff5623"
    sha256 cellar: :any,                 arm64_sonoma:  "c75dc71087b673c5895939985484f650c0804333bc2c1d5cddc1b0f6c13d4ec2"
    sha256 cellar: :any,                 arm64_ventura: "89837bc4a60e49ce281d66c1351ed2950525489175305ffa3b2de26b1c5d9bfa"
    sha256 cellar: :any,                 sonoma:        "f0d07e2ecb215b0ea92aa230c68658329fd793280c84adb586517cd564efbda7"
    sha256 cellar: :any,                 ventura:       "1d486b79e49e49b319d570d5398afd55e581c4bb7823192191b938efda6f4819"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "411119be95e13389ba0ad1dbbadd7d0746172ff7048680f55ebcd2e01155c281"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13ba48bc33570e2ad320f39477f847474e16f8ae5186c9b5de5b34c7a8de6fc1"
  end

  depends_on "rust" => :build # for bcrypt
  depends_on "capstone"
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libsodium" # for pynacl
  depends_on "python@3.13"
  depends_on "unicorn" # for unicorn resource

  uses_from_macos "libffi"

  conflicts_with "moreutils", because: "both install an `errno` executable"
  conflicts_with "cspice", because: "both install `version` binaries"
  conflicts_with "jena", because: "both install `update` binaries"
  conflicts_with "scala", because: "both install `common` binaries"

  resource "bcrypt" do
    url "https:files.pythonhosted.orgpackagesbb5d6d7433e0f3cd46ce0b43cd65e1db465ea024dbb8216fb2404e919c2ad77bbcrypt-4.3.0.tar.gz"
    sha256 "3a3fd2204178b6d2adcf09cb4f6426ffef54762577a7c9b54c159008cb288c18"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagese43389c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12dcharset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "colored-traceback" do
    url "https:files.pythonhosted.orgpackages0780afcf567031ab8565f8f8d2bd14b007d313ea3258e50394e85b10a405099ccolored-traceback-0.4.2.tar.gz"
    sha256 "ecbc8e41f0712ea81931d7cd436b8beb9f3eff1595d2498f183e0ef69b56fe84"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "intervaltree" do
    url "https:files.pythonhosted.orgpackages50fb396d568039d21344639db96d940d40eb62befe704ef849b27949ded5c3bbintervaltree-3.1.0.tar.gz"
    sha256 "902b1b88936918f9b2a19e0e5eb7ccb430ae45cde4f39ea4b36932920d33952d"
  end

  resource "mako" do
    url "https:files.pythonhosted.orgpackages9e38bd5b78a920a64d708fe6bc8e0a2c075e1389d53bef8413725c63ba041535mako-1.3.10.tar.gz"
    sha256 "99579a6f39583fa7e5630a28c3c1f440e4e97a414b80372649c0ce338da2ea28"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackagesb2975d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesa1d41fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24dpackaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "paramiko" do
    url "https:files.pythonhosted.orgpackages7d15ad6ce226e8138315f2451c2aeea985bf35ee910afb477bae7477dc3a8f3bparamiko-3.5.1.tar.gz"
    sha256 "b2c665bc45b2b215bd7d7f039901b14b067da00f3a11e6640995fd58f2664822"
  end

  resource "plumbum" do
    url "https:files.pythonhosted.orgpackagesf05d49ba324ad4ae5b1a4caefafbce7a1648540129344481f2ed4ef6bb68d451plumbum-1.9.0.tar.gz"
    sha256 "e640062b72642c3873bd5bdc3effed75ba4d3c70ef6b6a7b907357a84d909219"
  end

  resource "psutil" do
    url "https:files.pythonhosted.orgpackages2a80336820c1ad9286a4ded7e845b2eccfcb27851ab8ac6abece774a6ff4d3depsutil-7.0.0.tar.gz"
    sha256 "7be9c3eba38beccb6495ea33afd982a44074b78f28c434a1f51cc07fd315c456"
  end

  resource "pyelftools" do
    url "https:files.pythonhosted.orgpackagesb9ab33968940b2deb3d92f5b146bc6d4009a5f95d1d06c148ea2f9ee965071afpyelftools-0.32.tar.gz"
    sha256 "6de90ee7b8263e740c8715a925382d4099b354f29ac48ea40d840cf7aa14ace5"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages7c2dc3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
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

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackagese10a929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "ropgadget" do
    url "https:files.pythonhosted.orgpackagesb5ad7c6c9078c143d5cb7965f2d06a3aadc5f9e638276dd86e57ce8c9a30457cropgadget-7.6.tar.gz"
    sha256 "8883c54e4627073a2ce7cd8adbaf7ef72478442c0a5da1308c3c2e37641174c3"
  end

  resource "rpyc" do
    url "https:files.pythonhosted.orgpackages8be71c17410673b634f4658bb5d2232d0c4507432a97508b2c6708e59481644arpyc-6.0.2.tar.gz"
    sha256 "8e780a6a71b842128a80a337c64adfb6f919014e069951832161c9efc630c93b"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages94e7b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sortedcontainers" do
    url "https:files.pythonhosted.orgpackagese8c4ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  resource "unicorn" do
    url "https:files.pythonhosted.orgpackages9012a10f01a3e1dafcd21e2eb0c0d99bb51d5bda1d3fee20047cb2a4b2de6285unicorn-2.1.2.tar.gz"
    sha256 "e4a9d671bdea71806f29a396734cfb83317f82943b52d0001d3bca1dcbaee893"
  end

  resource "unix-ar" do
    url "https:files.pythonhosted.orgpackages3e3765cb206bd7110887248fe041e00e61124abdcd23de8f19418898a51363fcunix_ar-0.2.1.tar.gz"
    sha256 "bf9328ec70fa3a82f94dc26dc125264dbf62a2d8ffb1a3c8c8a8230175e72c4e"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages8a7816493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  resource "zstandard" do
    url "https:files.pythonhosted.orgpackagesedf62ac0287b442160a89d726b17a9184a4c615bb5237db763791a7fd16d9df1zstandard-0.23.0.tar.gz"
    sha256 "b2d8c62d08e7255f68f7a740bae85b3c9b8e5466baa9cbf7f57f1cde0ac6bc09"
  end

  def install
    ENV["LIBUNICORN_PATH"] = Formula["unicorn"].opt_lib
    ENV["SODIUM_INSTALL"] = "system"
    venv = virtualenv_install_with_resources

    # Use shared library from `unicorn` formula. The is mainly required if
    # `unicorn` is unlinked as fallback load can find lib from linked path
    pyunicorn_lib = venv.site_packages"unicornlib"
    pyunicorn_lib.mkpath
    Formula["unicorn"].opt_lib.glob(shared_library("libunicorn", "*")).each do |libunicorn|
      ln_s libunicorn.relative_path_from(pyunicorn_lib), pyunicorn_lib
    end

    bash_completion.install "extrabash_completion.dpwn"
    zsh_completion.install "extrazsh_completion_pwn"
  end

  test do
    assert_equal "686f6d6562726577696e7374616c6c636f6d706c657465",
                 shell_output("#{bin}hex homebrewinstallcomplete").strip

    # Test that unicorn shared library can be loaded
    system libexec"binpython", "-c", "import unicorn.unicorn"
  end
end