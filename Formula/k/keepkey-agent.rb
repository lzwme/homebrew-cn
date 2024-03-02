class KeepkeyAgent < Formula
  include Language::Python::Virtualenv

  desc "Keepkey Hardware-based SSHGPG agent"
  homepage "https:github.comromanztrezor-agent"
  url "https:files.pythonhosted.orgpackages65724bf47a7bc8dc93d2ac21672a0db4bc58a78ec5cee3c4bcebd0b4092a9110keepkey_agent-0.9.0.tar.gz"
  sha256 "47c85de0c2ffb53c5d7bd2f4d2230146a416e82511259fad05119c4ef74be70c"
  license "LGPL-3.0-only"
  revision 7

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bb3c9bb9f08585952b6a9c8db4e0653e13411f98cd73c7de80b8ceafafb8daf7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "87402b689125c83bb164938c98301887d4eb1533dce9f52cebe0411047af6190"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b942fa21ce16564b91fed29afed10c204bc1bb4f85234ac8a9bfce4af5721e07"
    sha256 cellar: :any_skip_relocation, sonoma:         "630b61d363d06cc6dd454b9f9c95eac18552b7368a95565914e53a4b678f33d4"
    sha256 cellar: :any_skip_relocation, ventura:        "7b26a33ea717fac2e9069756f8cdb11324c358462f09d1daa9141f8b3267423e"
    sha256 cellar: :any_skip_relocation, monterey:       "bc301b09dda47eb5fda78e13d5eaeebd70224a6bb785f45a77f05c2f74fff533"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45e42e419b2b653c1ee723033e6a3650cb9e02a5b02cec4dafe0949a7cca4891"
  end

  depends_on "libusb"
  depends_on "python-cryptography"
  depends_on "python@3.12"

  uses_from_macos "libffi"

  resource "backports-shutil-which" do
    url "https:files.pythonhosted.orgpackagesa02251b896a4539f1bff6a7ab8514eb031b9f43f12bff23f75a4c3f4e9a666e5backports.shutil_which-3.5.2.tar.gz"
    sha256 "fe39f567cbe4fad89e8ac4dbeb23f87ef80f7fe8e829669d0221ecdb0437c133"
  end

  resource "bech32" do
    url "https:files.pythonhosted.orgpackagesabfeb67ac9b123e25a3c1b8fc3f3c92648804516ab44215adb165284e024c43fbech32-1.2.0.tar.gz"
    sha256 "7d6db8214603bd7871fcfa6c0826ef68b85b0abd90fa21c285a9c5e21d2bd899"
  end

  resource "cffi" do
    url "https:files.pythonhosted.orgpackages68ce95b0bae7968c65473e1298efb042e10cafc7bafc14d9e4f154008241c91dcffi-1.16.0.tar.gz"
    sha256 "bcb3ef43e58665bbda2fb198698fcae6776483e0c4a631aa5647806c25e02cc0"
  end

  resource "configargparse" do
    url "https:files.pythonhosted.orgpackages708a73f1008adfad01cb923255b924b1528727b8270e67cb4ef41eabdc7d783eConfigArgParse-1.7.tar.gz"
    sha256 "e7067471884de5478c58a511e529f0f9bd1c66bfef1dea90935438d6c23306d1"
  end

  resource "docutils" do
    url "https:files.pythonhosted.orgpackages1f53a5da4f2c5739cf66290fac1431ee52aff6851c7c8ffd8264f13affd7bcdddocutils-0.20.1.tar.gz"
    sha256 "f08a4e276c3a1583a86dce3e34aba3fe04d02bba2dd51ed16106244e8a923e3b"
  end

  resource "ecdsa" do
    url "https:files.pythonhosted.orgpackagesff7bba6547a76c468a0d22de93e89ae60d9561ec911f59532907e72b0d8bc0f1ecdsa-0.18.0.tar.gz"
    sha256 "190348041559e21b22a1d65cee485282ca11a6f81d503fddb84d5017e9ed1e49"
  end

  resource "hidapi" do
    url "https:files.pythonhosted.orgpackages950ec106800c94219ec3e6b483210e91623117bfafcf1decaff3c422e18af349hidapi-0.14.0.tar.gz"
    sha256 "a7cb029286ced5426a381286526d9501846409701a29c2538615c3d1a612b8be"

    # patch to build with Cython 3+, remove in next release
    patch do
      url "https:github.comtrezorcython-hidapicommit749da6931f57c4c30596de678125648ccfd6e1cd.patch?full_index=1"
      sha256 "e3d70eb9850c7be0fdb0c31bf575b33be5c5848def904760a6ca9f4c3824f000"
    end
  end

  resource "keepkey" do
    url "https:files.pythonhosted.orgpackages3038558d9a2dd1fd74f50ff4587b4054496ffb69e21ab1138eb448f3e8e2f4a7keepkey-6.3.1.tar.gz"
    sha256 "cef1e862e195ece3e42640a0f57d15a63086fd1dedc8b5ddfcbc9c2657f0bb1e"
  end

  resource "libagent" do
    url "https:files.pythonhosted.orgpackages4e0fb48045dd9d12eea5c092aaad4c251443384da700c8d85349fc3c554a2320libagent-0.14.7.tar.gz"
    sha256 "8cea67fbe94216f61dbc22fac9d3d749b41b9cfc11393a76b0b0013c204adb98"
  end

  resource "libusb1" do
    url "https:files.pythonhosted.orgpackagesf48359bf75e74e0c4859ea63eae0c7da660c1dcb78b31667d4a5f735d52f5974libusb1-3.0.0.tar.gz"
    sha256 "5792a9defee40f15d330a40d9b1800545c32e47ba7fc66b6f28f133c9fcc8538"
  end

  resource "lockfile" do
    url "https:files.pythonhosted.orgpackages174772cb04a58a35ec495f96984dddb48232b551aafb95bde614605b754fe6f7lockfile-0.12.2.tar.gz"
    sha256 "6aed02de03cba24efabcd600b30540140634fc06cfa603822d508d5361e9f799"
  end

  resource "mnemonic" do
    url "https:files.pythonhosted.orgpackagesf88dd4dc2b2bddfeb57cab4404a41749b577f578f71140ab754da9afa8f5c599mnemonic-0.20.tar.gz"
    sha256 "7c6fb5639d779388027a77944680aee4870f0fcd09b1e42a5525ee2ce4c625f6"
  end

  resource "protobuf" do
    url "https:files.pythonhosted.orgpackages555be3d951e34f8356e5feecacd12a8e3b258a1da6d9a03ad1770f28925f29bcprotobuf-3.20.3.tar.gz"
    sha256 "2e3427429c9cffebf259491be0af70189607f365c2f41c7c3764af6f337105f2"
  end

  resource "pycparser" do
    url "https:files.pythonhosted.orgpackages5e0b95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46depycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pymsgbox" do
    url "https:files.pythonhosted.orgpackages7dff4c6f31a4f08979f12a663f2aeb6c8b765d3bd592e66eaaac445f547bb875PyMsgBox-1.0.9.tar.gz"
    sha256 "2194227de8bff7a3d6da541848705a155dcbb2a06ee120d9f280a1d7f51263ff"
  end

  resource "pynacl" do
    url "https:files.pythonhosted.orgpackagesa72227582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986daPyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "python-daemon" do
    url "https:files.pythonhosted.orgpackages845097b81327fccbb70eb99f3c95bd05a0c9d7f13fb3f4cfd975885110d1205apython-daemon-3.0.1.tar.gz"
    sha256 "6c57452372f7eaff40934a1c03ad1826bf5e793558e87fef49131e6464b4dae5"
  end

  resource "semver" do
    url "https:files.pythonhosted.orgpackages416ca536cc008f38fd83b3c1b98ce19ead13b746b5588c9a0cb9dd9f6ea434bcsemver-3.0.2.tar.gz"
    sha256 "6253adb39c70f6e51afed2fa7152bcd414c411286088fb4b9effb133885ab4cc"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "unidecode" do
    url "https:files.pythonhosted.orgpackages805df156f6a7254ecc0549de0eb75f786d2df724c0310b97c825383517d2c98dUnidecode-1.3.7.tar.gz"
    sha256 "3c90b4662aa0de0cb591884b934ead8d2225f1800d8da675a7750cbc3bd94610"
  end

  resource "wheel" do
    url "https:files.pythonhosted.orgpackagesa49978c4f3bd50619d772168bec6a0f34379b02c19c9cced0ed833ecd021fd0dwheel-0.41.2.tar.gz"
    sha256 "0c5ac5ff2afb79ac23ab82bab027a0be7b5dbcf2e54dc50efe4bf507de1f7985"
  end

  def install
    # Workaround to avoid creating libexecbin__pycache__ which gets linked to bin
    ENV["PYTHONPYCACHEPREFIX"] = buildpath"pycache"
    # Help gcc to find libusb headers on Linux.
    ENV.append "CFLAGS", "-I#{Formula["libusb"].opt_include}libusb-1.0" unless OS.mac?
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}keepkey-agent identity@myhost 2>&1", 1)
    assert_match "KeepKey not connected", output
  end
end