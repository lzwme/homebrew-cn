class KeepkeyAgent < Formula
  include Language::Python::Virtualenv

  desc "Keepkey Hardware-based SSHGPG agent"
  homepage "https:github.comromanztrezor-agent"
  url "https:files.pythonhosted.orgpackages65724bf47a7bc8dc93d2ac21672a0db4bc58a78ec5cee3c4bcebd0b4092a9110keepkey_agent-0.9.0.tar.gz"
  sha256 "47c85de0c2ffb53c5d7bd2f4d2230146a416e82511259fad05119c4ef74be70c"
  license "LGPL-3.0-only"
  revision 10

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fe5abb6df497d25c25cf54b6cf0c05fdeb0b2e817c61369f9346a6b933ea21a6"
    sha256 cellar: :any,                 arm64_sonoma:  "c94113694b5d5a191955f05d762bd0732725dc22dfaae7f068ed38ffbd537511"
    sha256 cellar: :any,                 arm64_ventura: "8738cb6ce778923090a459caa936ab7f012540d0092b0b5b6e5f169bd5747cd5"
    sha256 cellar: :any,                 sonoma:        "434950972d0df313af660009690495417b31d716265315c8066298a4cbd642b7"
    sha256 cellar: :any,                 ventura:       "0660b8f20b7913e819bd76384dbd916d1085d410e8deca21c9dd5afedb529992"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e625e5ada8aff887dc167996135b08292e6924c4275345d3798ae748222bf7e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2da29e6aa62b6209aa42aff8a56319a7e8916772a19f7dcfefa129d00308f91a"
  end

  depends_on "pkgconf" => :build # for hidapi resource
  depends_on "cryptography"
  depends_on "hidapi"
  depends_on "libsodium" # for pynacl
  depends_on "libusb" # for libusb1
  depends_on "python@3.13"

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
    url "https:files.pythonhosted.orgpackagesc01f924e3caae75f471eae4b26bd13b698f6af2c44279f67af317439c2f4c46aecdsa-0.19.1.tar.gz"
    sha256 "478cba7b62555866fcb3bb3fe985e06decbdb68ef55713c4e5ab98c57d508e61"
  end

  resource "hidapi" do
    url "https:files.pythonhosted.orgpackages477221ccaaca6ffb06f544afd16191425025d831c2a6d318635e9c8854070f2dhidapi-0.14.0.post4.tar.gz"
    sha256 "48fce253e526d17b663fbf9989c71c7ef7653ced5f4be65f1437c313fb3dbdf6"
  end

  resource "keepkey" do
    url "https:files.pythonhosted.orgpackages3038558d9a2dd1fd74f50ff4587b4054496ffb69e21ab1138eb448f3e8e2f4a7keepkey-6.3.1.tar.gz"
    sha256 "cef1e862e195ece3e42640a0f57d15a63086fd1dedc8b5ddfcbc9c2657f0bb1e"
  end

  resource "libagent" do
    url "https:files.pythonhosted.orgpackages339fd80eb0568f617d4041fd83b8b301fdb817290503ee4c1546024df916454elibagent-0.15.0.tar.gz"
    sha256 "c87caebdb932ed42bcd8a8cbe40ce3589587c71c3513ca79cadf7a040e24b4eb"
  end

  resource "libusb1" do
    url "https:files.pythonhosted.orgpackagesa27fc59ad56d1bca8fa4321d1bb77ba4687775751a4deceec14943a44da18ca0libusb1-3.3.1.tar.gz"
    sha256 "3951d360f2daf0e0eacf839e15d2d1d2f4f5e7830231eb3188eeffef2dd17bad"
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
    url "https:files.pythonhosted.orgpackages3d374f10e37bdabc058a32989da2daf29e57dc59dbc5395497f3d36d5f5e2694python_daemon-3.1.2.tar.gz"
    sha256 "f7b04335adc473de877f5117e26d5f1142f4c9f7cd765408f0877757be5afbf4"
  end

  resource "semver" do
    url "https:files.pythonhosted.orgpackages72d1d3159231aec234a59dd7d601e9dd9fe96f3afff15efd33c1070019b26132semver-3.0.4.tar.gz"
    sha256 "afc7d8c584a5ed0a11033af086e8af226a9c0b206f313e0301f8dd7b6b589602"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages9e8bdc1773e8e5d07fd27c1632c45c1de856ac3dbf09c0147f782ca6d990cf15setuptools-80.7.1.tar.gz"
    sha256 "f6ffc5f0142b1bd8d0ca94ee91b30c0ca862ffd50826da1ea85258a06fd94552"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages94e7b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "unidecode" do
    url "https:files.pythonhosted.orgpackages947da8a765761bbc0c836e397a2e48d498305a865b70a8600fd7a942e85dcf63Unidecode-1.4.0.tar.gz"
    sha256 "ce35985008338b676573023acc382d62c264f307c8f7963733405add37ea2b23"
  end

  resource "wheel" do
    url "https:files.pythonhosted.orgpackages8a982d9906746cdc6a6ef809ae6338005b3f21bb568bea3165cfc6a243fdc25cwheel-0.45.1.tar.gz"
    sha256 "661e1abd9198507b1409a20c02106d9670b2576e916d58f520316666abca6729"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}keepkey-agent identity@myhost 2>&1", 1)
    assert_match "KeepKey not connected", output
  end
end