class Pwntools < Formula
  include Language::Python::Virtualenv

  desc "CTF framework used by Gallopsled in every CTF"
  homepage "https:github.comGallopsledpwntools"
  url "https:files.pythonhosted.orgpackages2472f26dd3713ac1cbe7c451a7ae9e586096deb1a2da5218e308881a4d13c3d4pwntools-4.13.1.tar.gz"
  sha256 "b3322725fb5031dc30965e3855073608d9abf74d2abf97a72c67d44aadfce37c"
  license "MIT"
  head "https:github.comGallopsledpwntools.git", branch: "dev"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "18b7bcf44b558a174c8425ab0dcadfc08dcd945007fa8d183ae53ab136904c1d"
    sha256 cellar: :any,                 arm64_sonoma:  "67329ba4714d394bc4730d57b3a8b205734ddfee4143e9fc9b373ad867d8a980"
    sha256 cellar: :any,                 arm64_ventura: "bd68c24b3fb0c79779822c8e2d59598e2a12a3a42014e3980c8e06a2333fb365"
    sha256 cellar: :any,                 sonoma:        "244dd038a4f1335ed17f00f3d7369d250a0c7cd478d04028e8b0fd783d19cffa"
    sha256 cellar: :any,                 ventura:       "de7b7f3f13bf53ea4f6e79adb2fc1f976e6da34300f00df245e13639c5b0854f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cf0aaf21bfb8bbd5b72a202b71f3f9b29304bb928b9db94e0460f302fc222cc"
  end

  depends_on "rust" => :build # for bcrypt
  depends_on "capstone"
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.12"

  uses_from_macos "libffi"

  conflicts_with "moreutils", because: "both install an `errno` executable"
  conflicts_with "cspice", because: "both install `version` binaries"
  conflicts_with "jena", because: "both install `update` binaries"
  conflicts_with "scala", because: "both install `common` binaries"

  resource "bcrypt" do
    url "https:files.pythonhosted.orgpackagese47ed95e7d96d4828e965891af92e43b52a4cd3395dc1c1ef4ee62748d0471d0bcrypt-4.2.0.tar.gz"
    sha256 "cf69eaf5185fd58f268f805b505ce31f9b9fc2d64b376642164e9244540c1221"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
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
    url "https:files.pythonhosted.orgpackages6703fb5ba97ff65ce64f6d35b582aacffc26b693a98053fa831ab43a437cbddbMako-1.3.5.tar.gz"
    sha256 "48dbc20568c1d276a2698b36d968fa76161bf127194907ea6fc594fa81f943bc"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackages875baae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02dMarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackages516550db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "paramiko" do
    url "https:files.pythonhosted.orgpackages1b0fc00296e36ff7485935b83d466c4f2cf5934b84b0ad14e81796e1d9d3609bparamiko-3.5.0.tar.gz"
    sha256 "ad11e540da4f55cedda52931f1a3f812a8238a7af7f62a60de538cd80bb28124"
  end

  resource "plumbum" do
    url "https:files.pythonhosted.orgpackages236206260ec9f1f5a8c04418f8c8c7c2877c80cac4ead97224fc14d92f0db6b4plumbum-1.8.3.tar.gz"
    sha256 "6092c85ab970b7a7a9d5d85c75200bc93be82b33c9bdf640ffa87d2d7c8709f0"
  end

  resource "psutil" do
    url "https:files.pythonhosted.orgpackages18c78c6872f7372eb6a6b2e4708b88419fb46b857f7a2e1892966b851cc79fc9psutil-6.0.0.tar.gz"
    sha256 "8faae4f310b6d969fa26ca0545338b21f73c6b15db7c4a8d934a5482faa818f2"
  end

  resource "pyelftools" do
    url "https:files.pythonhosted.orgpackages88560f2d69ed9a0060da009f672ddec8a71c041d098a66f6b1d80264bf6bbdc0pyelftools-0.31.tar.gz"
    sha256 "c774416b10310156879443b81187d182d8d9ee499660380e645918b50bc88f99"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages8e628336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
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
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "ropgadget" do
    url "https:files.pythonhosted.orgpackagesba4e4065dd3c968d3979a459033405ef4cd9543f6f8840e010789a7585f3ae55ROPGadget-7.5.tar.gz"
    sha256 "c6b0a596c4a1d17ae928206119f6d8248d1607d6e577a205e75a7d298142accb"
  end

  resource "rpyc" do
    url "https:files.pythonhosted.orgpackages3a9da48fb1246a4b431951947f7cc2b4a24ffe59c0ec4eec1396d275bc6a45edrpyc-6.0.1.tar.gz"
    sha256 "8a60f3c4401f309c0eb6e754fb6c4e0442231203907cebf61ae74615b52cd38a"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "sortedcontainers" do
    url "https:files.pythonhosted.orgpackagese8c4ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  resource "unicorn" do
    url "https:files.pythonhosted.orgpackages48d51aaaa398d215f31880cb73e7a8dde30a0f8a42c7ec9ec1aad6641e2dcd7aunicorn-2.1.1.tar.gz"
    sha256 "904f4146b09cd708fdf6b90ebb48d30eaa0ba339382964d4d08c0b9399cf4ba3"
  end

  resource "unix-ar" do
    url "https:files.pythonhosted.orgpackages3e3765cb206bd7110887248fe041e00e61124abdcd23de8f19418898a51363fcunix_ar-0.2.1.tar.gz"
    sha256 "bf9328ec70fa3a82f94dc26dc125264dbf62a2d8ffb1a3c8c8a8230175e72c4e"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesed6322ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  resource "zstandard" do
    url "https:files.pythonhosted.orgpackagesedf62ac0287b442160a89d726b17a9184a4c615bb5237db763791a7fd16d9df1zstandard-0.23.0.tar.gz"
    sha256 "b2d8c62d08e7255f68f7a740bae85b3c9b8e5466baa9cbf7f57f1cde0ac6bc09"
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