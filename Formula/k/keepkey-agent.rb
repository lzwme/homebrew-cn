class KeepkeyAgent < Formula
  include Language::Python::Virtualenv

  desc "Keepkey Hardware-based SSHGPG agent"
  homepage "https:github.comromanztrezor-agent"
  url "https:files.pythonhosted.orgpackages65724bf47a7bc8dc93d2ac21672a0db4bc58a78ec5cee3c4bcebd0b4092a9110keepkey_agent-0.9.0.tar.gz"
  sha256 "47c85de0c2ffb53c5d7bd2f4d2230146a416e82511259fad05119c4ef74be70c"
  license "LGPL-3.0-only"
  revision 9

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ece4a4d3662aff2a21064d488c8a1cc34429356548fe32fe506fea1ba33e9b4f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76b077fa1d82acb83e7c964fe51f6e6abea6aa19944a1022edf69c1a7250466b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc56819ae439220eee157b3acb329afbfb6737a63bf3182a9cf20e6675429539"
    sha256 cellar: :any_skip_relocation, sonoma:         "32e71b81b33e4a100f3513137012ea999512b63d768f0598e6c5ae68743f353e"
    sha256 cellar: :any_skip_relocation, ventura:        "6baad2e970aeb880d25559f840ee27e5ada149e7c838ec4567871f74c6c1c5e5"
    sha256 cellar: :any_skip_relocation, monterey:       "9229f0f4e66360850ea943ac9e99713a38d5f3dc1c8fb41db525c7ae3ff46715"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46fad7560fa4dd066f4a4b68a9d5d8e27d502e69ec662c49cbe158e7489cc693"
  end

  depends_on "cryptography"
  depends_on "libusb"
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

  resource "configargparse" do
    url "https:files.pythonhosted.orgpackages708a73f1008adfad01cb923255b924b1528727b8270e67cb4ef41eabdc7d783eConfigArgParse-1.7.tar.gz"
    sha256 "e7067471884de5478c58a511e529f0f9bd1c66bfef1dea90935438d6c23306d1"
  end

  resource "docutils" do
    url "https:files.pythonhosted.orgpackagesaeedaefcc8cd0ba62a0560c3c18c33925362d46c6075480bfa4df87b28e169a9docutils-0.21.2.tar.gz"
    sha256 "3a6b18732edf182daa3cd12775bbb338cf5691468f91eeeb109deff6ebfa986f"
  end

  resource "ecdsa" do
    url "https:files.pythonhosted.orgpackages5ed0ec8ac1de7accdcf18cfe468653ef00afd2f609faf67c423efbd02491051becdsa-0.19.0.tar.gz"
    sha256 "60eaad1199659900dd0af521ed462b793bbdf867432b3948e87416ae4caf6bf8"
  end

  resource "hidapi" do
    url "https:files.pythonhosted.orgpackagesbf6f90c536b020a8e860f047a2839830a1ade3e1490e67336ecf489b4856eb7bhidapi-0.14.0.post2.tar.gz"
    sha256 "6c0e97ba6b059a309d51b495a8f0d5efbcea8756b640d98b6f6bb9fdef2458ac"
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
    url "https:files.pythonhosted.orgpackagesaf1953ecbfb96d6832f2272d13b84658c360802fcfff7c0c497ab8f6bf15ac40libusb1-3.1.0.tar.gz"
    sha256 "4ee9b0a55f8bd0b3ea7017ae919a6c1f439af742c4a4b04543c5fd7af89b828c"
  end

  resource "lockfile" do
    url "https:files.pythonhosted.orgpackages174772cb04a58a35ec495f96984dddb48232b551aafb95bde614605b754fe6f7lockfile-0.12.2.tar.gz"
    sha256 "6aed02de03cba24efabcd600b30540140634fc06cfa603822d508d5361e9f799"
  end

  resource "mnemonic" do
    url "https:files.pythonhosted.orgpackagesff77e6232ed59fbd7b90208bb8d4f89ed5aabcf30a524bc2fb8f0dafbe8e7df9mnemonic-0.21.tar.gz"
    sha256 "1fe496356820984f45559b1540c80ff10de448368929b9c60a2b55744cc88acf"
  end

  resource "protobuf" do
    url "https:files.pythonhosted.orgpackages555be3d951e34f8356e5feecacd12a8e3b258a1da6d9a03ad1770f28925f29bcprotobuf-3.20.3.tar.gz"
    sha256 "2e3427429c9cffebf259491be0af70189607f365c2f41c7c3764af6f337105f2"
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

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages6a218fd457d5a979109603e0e460c73177c3a9b6b7abcd136d0146156da95895setuptools-74.0.0.tar.gz"
    sha256 "a85e96b8be2b906f3e3e789adec6a9323abf79758ecfa3065bd740d81158b11e"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "unidecode" do
    url "https:files.pythonhosted.orgpackagesf78919151076a006b9ac0dd37b1354e031f5297891ee507eb624755e58e10d3eUnidecode-1.3.8.tar.gz"
    sha256 "cfdb349d46ed3873ece4586b96aa75258726e2fa8ec21d6f00a591d98806c2f4"
  end

  resource "wheel" do
    url "https:files.pythonhosted.orgpackagesb7a095e9e962c5fd9da11c1e28aa4c0d8210ab277b1ada951d2aee336b505813wheel-0.44.0.tar.gz"
    sha256 "a29c3f2817e95ab89aa4660681ad547c0e9547f20e75b0562fe7723c9a2a9d49"
  end

  def install
    # Help gcc to find libusb headers on Linux.
    ENV.append "CFLAGS", "-I#{Formula["libusb"].opt_include}libusb-1.0" unless OS.mac?

    venv = virtualenv_install_with_resources without: "python-daemon"
    # Workaround breaking change in `setuptools`: https:pagure.iopython-daemonissue94
    resource("python-daemon").stage do
      inreplace "version.py", "import setuptools.extern.packaging.version", ""
      inreplace "version.py", "self.validate_version(version)", ""
      venv.pip_install Pathname.pwd
    end
  end

  test do
    output = shell_output("#{bin}keepkey-agent identity@myhost 2>&1", 1)
    assert_match "KeepKey not connected", output
  end
end