class Gyb < Formula
  include Language::Python::Virtualenv
  desc "CLI for backing up and restoring Gmail messages"
  homepage "https://github.com/GAM-team/got-your-back/"
  url "https://ghproxy.com/https://github.com/GAM-team/got-your-back/archive/v1.74.tar.gz"
  sha256 "64029c4eadd191ed00847ef08ed6853b85f16d9955847a1fc71bec2616e60250"
  license "Apache-2.0"
  head "https://github.com/GAM-team/got-your-back.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ba30f5e6b880f0c7092e9c9f8d1654f1505da46c407a2531ce4c7d247cbf4a97"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f44593e3249b2d1c3aaea59f18255724e27fa806ae2088da47189a0063a60d35"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78adcbaa6d7b29e0aa2c5e1b82cae368beafc1d4a3dd3b9731daebf5b27bfec8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9628c65661b531ad6a6d621dd3f998c31fc1364ff1c99a5e0b8de7a7529ca7df"
    sha256 cellar: :any_skip_relocation, sonoma:         "534fda9ddae128bd60dfa91dc4a60af030284e65ccbb3f85518761f18dd4703e"
    sha256 cellar: :any_skip_relocation, ventura:        "e2f9b38d1abc950e390c7c670f061dafe80cb75c8cfc46f218a0c5a5fcc1e543"
    sha256 cellar: :any_skip_relocation, monterey:       "4e6b5cec4b1a7fd2f140d6fe28d1ad775d7d1a0f530656434de03b6204ee1fe4"
    sha256 cellar: :any_skip_relocation, big_sur:        "0fc72f79551f89fb7c10620bbbf802c13db23cceb0bd612cc0ba83d50560ef52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d86b45e5d406868cf9fb510d1ffc152953374e2b70e350d52b68c865e504751"
  end

  depends_on "rust" => :build # for cryptography
  depends_on "python-certifi"
  depends_on "python@3.11"
  depends_on "six"

  resource "altgraph" do
    url "https://files.pythonhosted.org/packages/5a/13/a7cfa43856a7b8e4894848ec8f71cd9e1ac461e51802391a3e2101c60ed6/altgraph-0.17.3.tar.gz"
    sha256 "ad33358114df7c9416cdb8fa1eaa5852166c505118717021c6a8c7c7abbd03dd"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/9d/8b/8e2ebf5ee26c21504de5ea2fb29cc6ae612b35fd05f959cdb641feb94ec4/cachetools-5.3.1.tar.gz"
    sha256 "dce83f2d9b4e1f732a8cd44af8e8fab2dbe46201467fc98b3ef8f269092bf62b"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/f3/b8/f727ada5b63aba53848e3791dd57be7481d5c9bf86978600ca9cca4ab03e/google-api-core-2.11.1.tar.gz"
    sha256 "25d29e05a0058ed5f19c61c0a78b1b53adea4d9364b464d014fbda941f6d1c9a"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/d2/e8/8cbc3186a98b38332db85b4537cce71f0df170a35e5cd88c1dd3be4a0aca/google-api-python-client-2.95.0.tar.gz"
    sha256 "d2731ede12f79e53fbe11fdb913dfe986440b44c0a28431c78a8ec275f4c1541"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/a4/3a/b6ab1073d2ac98c1b4f9036a4d37d5720f783bd4dc6e2c0ae516d3b13326/google-auth-2.22.0.tar.gz"
    sha256 "164cba9af4e6e4e40c3a4f90a1a6c12ee56f14c0b4868d1ca91b32826ab334ce"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/c6/b5/a9e956fd904ecb34ec9d297616fe98fa4106fc12f3b0a914dec983c267b9/google-auth-httplib2-0.1.0.tar.gz"
    sha256 "a07c39fd632becacd3f07718dfd6021bf396978f03ad3ce4321d060015cc30ac"
  end

  resource "google-auth-oauthlib" do
    url "https://files.pythonhosted.org/packages/e3/b4/ef2170c5f6aa5bc2461bab959a84e56d2819ce26662b50038d2d0602223e/google-auth-oauthlib-1.0.0.tar.gz"
    sha256 "e375064964820b47221a7e1b7ee1fd77051b6323c3f9e3e19785f78ab67ecfc5"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/08/78/aedf7f323cc6d4f2116556bd42c9ffab6021cf3f2fd9925ed4e71213dd1b/googleapis-common-protos-1.60.0.tar.gz"
    sha256 "e73ebb404098db405ba95d1e1ae0aa91c3e15a71da031a2eeb6b2e23e7bc3708"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/3d/ad/2371116b22d616c194aa25ec410c9c6c37f23599dcd590502b74db197584/httplib2-0.22.0.tar.gz"
    sha256 "d7a10bc5ef5ab08322488bde8c726eeee5c8618723fdb399597ec58f3d82df81"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "macholib" do
    url "https://files.pythonhosted.org/packages/46/92/bffe4576b383f20995ffb15edccf1c97d2e39f9a8c72136836407f099277/macholib-1.16.2.tar.gz"
    sha256 "557bbfa1bb255c20e9abafe7ed6cd8046b48d9525db2f9b77d3122a63a2a8bf8"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/6d/fa/fbf4001037904031639e6bfbfc02badfc7e12f137a8afa254df6c4c8a670/oauthlib-3.2.2.tar.gz"
    sha256 "9859c40929662bec5d64f34d01c99e093149682a3f38915dc0655d5a633dd918"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/d3/1c/de86d82a5fc780feca36ef52c1231823bb3140266af8a04ed6286957aa6e/protobuf-4.23.4.tar.gz"
    sha256 "ccd9430c0719dce806b93f89c91de7977304729e55377f872a92465d548329a9"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/61/ef/945a8bcda7895717c8ba4688c08a11ef6454f32b8e5cb6e352a9004ee89d/pyasn1-0.5.0.tar.gz"
    sha256 "97b7290ca68e62a832558ec3976f15cbf911bf5d7c7039d8b861c2a0ece69fde"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/3b/e4/7dec823b1b5603c5b3c51e942d5d9e65efd6ff946e713a325ed4146d070f/pyasn1_modules-0.3.0.tar.gz"
    sha256 "5bd01446b736eb9d31512a30d46c1ac3395d676c6f3cafa4c03eb54b9925631c"
  end

  resource "pyinstaller" do
    url "https://files.pythonhosted.org/packages/4d/15/ce35ef1f748eab0ee51a12fc2ac256958a1eb7720c106f40f198ace1fb71/pyinstaller-5.13.0.tar.gz"
    sha256 "5e446df41255e815017d96318e39f65a3eb807e74a796c7e7ff7f13b6366a2e9"
  end

  resource "pyinstaller-hooks-contrib" do
    url "https://files.pythonhosted.org/packages/c7/1e/d1884f4f59a89ac7c9c6eafb3fb454c6b92187805caa0847a7f4bcc87798/pyinstaller-hooks-contrib-2023.6.tar.gz"
    sha256 "596a72009d8692b043e0acbf5e1b476d93149900142ba01845dded91a0770cb5"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/37/fe/65c989f70bd630b589adfbbcd6ed238af22319e90f059946c26b4835e44b/pyparsing-3.1.1.tar.gz"
    sha256 "ede28a1a32462f5a9705e07aea48001a08f7cf81a021585011deba701581a0db"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/95/52/531ef197b426646f26b53815a7d2a67cb7a331ef098bb276db26a68ac49f/requests-oauthlib-1.3.1.tar.gz"
    sha256 "75beac4a47881eeb94d5ea5d6ad31ef88856affe2332b9aafb52c6452ccf0d7a"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/aa/65/7d973b89c4d2351d7fb232c2e452547ddfa243e93131e7cfa766da627b52/rsa-4.9.tar.gz"
    sha256 "e38464a49c6c85d7f1351b0126661487a7e0a14a50f1675ec50eb34d4f20ef21"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/d2/5a/4742fdba39cd02a56226815abfa72fe0aa81c33bed16ed045647d6000eba/uritemplate-4.1.1.tar.gz"
    sha256 "4346edfc5c3b79f694bccd6d6099a322bbeb628dbf2cd86eea55a456ce5124f0"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e2/7d/539e6f0cf9f0b95b71dd701a56dae89f768cd39fd8ce0096af3546aeb5a3/urllib3-1.26.16.tar.gz"
    sha256 "8f135f6502756bde6b2a9b28989df5fbe87c9970cecaa69041edcce7f0589b14"
  end

  def install
    print buildpath
    # change user config location from default of executable own path
    inreplace "gyb.py", "default=getProgPath()",
                        "default='#{pkgetc}'"
    venv = virtualenv_create(buildpath, "python3")
    venv.pip_install resources
    system buildpath/"bin/python3", "-m", "PyInstaller", "gyb.spec"
    bin.install "dist/gyb"
  end

  def post_install
    pkgetc.mkpath
  end

  def caveats
    <<~EOS
      Default config_folder: #{pkgetc}
    EOS
  end

  test do
    assert_match version.to_s, pipe_output("#{bin}/gyb --version 2>&1")
    # Below throws a bad exit code but we can check it actually is failing
    # for the right reasons by asserting. --version never fails even if
    # resources are missing or outdated/too new/etc.
    assert_match "ERROR: --email is required.", shell_output("#{bin}/gyb", 1)
  end
end