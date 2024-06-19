class Pwntools < Formula
  include Language::Python::Virtualenv

  desc "CTF framework used by Gallopsled in every CTF"
  homepage "https:github.comGallopsledpwntools"
  url "https:files.pythonhosted.orgpackages09cb82243a56a8b92451d97ad1792e67cbe8dbc9f9dec2a869a58839993ccca4pwntools-4.12.0.tar.gz"
  sha256 "320285bd9266152fdba3b81de3a31e61a25076645507a38d85f34e1b15998eb1"
  license "MIT"
  revision 4
  head "https:github.comGallopsledpwntools.git", branch: "dev"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3ccc88b2f7c47c9e85ab075d98aeb58481ac60c73d6f37c5dd169e62545da1e5"
    sha256 cellar: :any,                 arm64_ventura:  "01c3fc3381248aa5a7304715b4fba742077c12b911764b376aa21b3badef1fe1"
    sha256 cellar: :any,                 arm64_monterey: "3a7c78d4105f358ed6a5943743a12f1e070df9944444ffc90b5636c4ad4c0785"
    sha256 cellar: :any,                 sonoma:         "a8faf01b0a522a148bf4dc195b209b12c831900b585536b60603f96d1d682b11"
    sha256 cellar: :any,                 ventura:        "10638be996ff34cd8b3b00b24eadec6090afda2887807a555dbc75ca540f83cf"
    sha256 cellar: :any,                 monterey:       "92731a9b2e5e8d4c0ae847f8e062917fd9ca8d304215ab5ed009f2972d62f88f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c348fb587818f5a6a39285e3969194142f38da394c5e9c01717cb9feb8e7bcf5"
  end

  depends_on "rust" => :build # for bcrypt
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.12"

  uses_from_macos "libffi"

  conflicts_with "moreutils", because: "both install an `errno` executable"

  resource "bcrypt" do
    url "https:files.pythonhosted.orgpackagescae90b36987abbcd8c9210c7b86673d88ff0a481b4610630710fb80ba5661356bcrypt-4.1.3.tar.gz"
    sha256 "2ee15dd749f5952fe3f0430d0ff6b74082e159c50332a1413d51b5689cf06623"
  end

  resource "capstone" do
    url "https:files.pythonhosted.orgpackages7afee6cdc4ad6e0d9603fa662d1ccba6301c0cb762a1c90a42c7146a538c24e9capstone-5.0.1.tar.gz"
    sha256 "740afacc29861db591316beefe30df382c4da08dcb0345a0d10f0cac4f8b1ee2"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "colored-traceback" do
    url "https:files.pythonhosted.orgpackages9a8b0a4e2a8cdc14279b265532f11c9cb75396880e6295c99a0bed7281b6076acolored-traceback-0.3.0.tar.gz"
    sha256 "6da7ce2b1da869f6bb54c927b415b95727c4bb6d9a84c4615ea77d9872911b05"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
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
    url "https:files.pythonhosted.orgpackagesccaf11996c4df4f9caff87997ad2d3fd8825078c277d6a928446d2b6cf249889paramiko-3.4.0.tar.gz"
    sha256 "aac08f26a31dc4dffd92821527d1682d99d52f9ef6851968114a8728f3c274d3"
  end

  resource "plumbum" do
    url "https:files.pythonhosted.orgpackages236206260ec9f1f5a8c04418f8c8c7c2877c80cac4ead97224fc14d92f0db6b4plumbum-1.8.3.tar.gz"
    sha256 "6092c85ab970b7a7a9d5d85c75200bc93be82b33c9bdf640ffa87d2d7c8709f0"
  end

  resource "psutil" do
    url "https:files.pythonhosted.orgpackages90c76dc0a455d111f68ee43f27793971cf03fe29b6ef972042549db29eec39a2psutil-5.9.8.tar.gz"
    sha256 "6be126e3225486dff286a8fb9a06246a5253f4c7c53b475ea5f5ac934e64194c"
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
    url "https:files.pythonhosted.orgpackages0f5f55add023bd2af62dc25f17bb0f26360e228ecb5cb4c0182a714a01672000ROPGadget-7.4.tar.gz"
    sha256 "a40626a32cf867d06192ef24e16221b2b7ba82e2ec84ab5bfdfb0b017559342f"
  end

  resource "rpyc" do
    url "https:files.pythonhosted.orgpackages9a13ba2fd171ab860cbc5f69a6c5b60153d8948fefb5890abb8ac54aead607a9rpyc-6.0.0.tar.gz"
    sha256 "a7e12b31f40978cbd6b74e0b713da389d4b2565cef612adcb0f4b41aeb188230"
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
    url "https:files.pythonhosted.orgpackages64c71a571a06adda2a9802e21d84398c5547761cb28b22f59a2c5db62bf23887unicorn-2.0.1.post1.tar.gz"
    sha256 "7fc69523eb83b4c8abc7cb4410ca21875e066c34b7afe998f59481e830d28e56"
  end

  resource "unix-ar" do
    url "https:files.pythonhosted.orgpackages3e3765cb206bd7110887248fe041e00e61124abdcd23de8f19418898a51363fcunix_ar-0.2.1.tar.gz"
    sha256 "bf9328ec70fa3a82f94dc26dc125264dbf62a2d8ffb1a3c8c8a8230175e72c4e"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages436dfa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
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