class TrezorAgent < Formula
  include Language::Python::Virtualenv

  desc "Hardware SSHGPG agent for Trezor, Keepkey & Ledger"
  homepage "https:github.comromanztrezor-agent"
  url "https:files.pythonhosted.orgpackages11bcaa2bdee9cd81af9ecde0a9e8b5c6c6594a4a0ee7ade950b51a39d54f9e63trezor_agent-0.12.0.tar.gz"
  sha256 "e08ca5a54bd7658017164c8518d6cdf623d3b077dfdccfd12f612af5fef05855"
  license "LGPL-3.0-only"
  revision 5

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4b59b880f022b93645dd81280125addbac78d4c359c0e9166c6b25c1af351af9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ceb23429eed7be049a83876db18d03b7b78e65b9acfd1f14d9a497c991ea22ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61bf502bac144af331f84f89cdd5a55ccbde4de9fb1b3f2035bc3b7a7573571e"
    sha256 cellar: :any_skip_relocation, sonoma:         "7828f00b8db986b1ac5d3dde50024bf6850e3dc086e1bbc31b0ae788ca158d39"
    sha256 cellar: :any_skip_relocation, ventura:        "6984d6fd39b74421f0d6dde821cd68c5fa5a3121af71051cd99cc10e14e2b50c"
    sha256 cellar: :any_skip_relocation, monterey:       "f56071a3064e0b66baeb7699c8e25801c21d2d53f792cf6d9bd054d1812e8ad7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e9203c10a0b02720db098e9495f05dc5b27d1e058584aea6d052d027b63aa72"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libusb"
  depends_on "pillow"
  depends_on "python@3.12"

  resource "backports-shutil-which" do
    url "https:files.pythonhosted.orgpackagesa02251b896a4539f1bff6a7ab8514eb031b9f43f12bff23f75a4c3f4e9a666e5backports.shutil_which-3.5.2.tar.gz"
    sha256 "fe39f567cbe4fad89e8ac4dbeb23f87ef80f7fe8e829669d0221ecdb0437c133"
  end

  resource "bech32" do
    url "https:files.pythonhosted.orgpackagesabfeb67ac9b123e25a3c1b8fc3f3c92648804516ab44215adb165284e024c43fbech32-1.2.0.tar.gz"
    sha256 "7d6db8214603bd7871fcfa6c0826ef68b85b0abd90fa21c285a9c5e21d2bd899"
  end

  resource "bleak" do
    url "https:files.pythonhosted.orgpackages460a61e29d74069008d489285b8ab3d179a3a896e0cc338bd5df6f726333b207bleak-0.22.1.tar.gz"
    sha256 "73c2e774c22345e170d36a55a9dd06f6633c88b4184d5f86140a8224f12282d4"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "configargparse" do
    url "https:files.pythonhosted.orgpackages708a73f1008adfad01cb923255b924b1528727b8270e67cb4ef41eabdc7d783eConfigArgParse-1.7.tar.gz"
    sha256 "e7067471884de5478c58a511e529f0f9bd1c66bfef1dea90935438d6c23306d1"
  end

  resource "construct" do
    url "https:files.pythonhosted.orgpackages02778c84b98eca70d245a2a956452f21d57930d22ab88cbeed9290ca630cf03fconstruct-2.10.70.tar.gz"
    sha256 "4d2472f9684731e58cc9c56c463be63baa1447d674e0d66aeb5627b22f512c29"
  end

  resource "construct-classes" do
    url "https:files.pythonhosted.orgpackages83d3e42d3cc9eab95995d5349ec51f6d638028b9c21e7e8ac6bea056b36438b8construct-classes-0.1.2.tar.gz"
    sha256 "72ac1abbae5bddb4918688713f991f5a7fb6c9b593646a82f4bf3ac53de7eeb5"
  end

  resource "docutils" do
    url "https:files.pythonhosted.orgpackagesaeedaefcc8cd0ba62a0560c3c18c33925362d46c6075480bfa4df87b28e169a9docutils-0.21.2.tar.gz"
    sha256 "3a6b18732edf182daa3cd12775bbb338cf5691468f91eeeb109deff6ebfa986f"
  end

  resource "ecdsa" do
    url "https:files.pythonhosted.orgpackages5ed0ec8ac1de7accdcf18cfe468653ef00afd2f609faf67c423efbd02491051becdsa-0.19.0.tar.gz"
    sha256 "60eaad1199659900dd0af521ed462b793bbdf867432b3948e87416ae4caf6bf8"
  end

  resource "ecpy" do
    url "https:files.pythonhosted.orgpackagese0483f8c1a252e3a46fd04e6fabc5e11c933b9c39cf84edd4e7c906e29c23750ECPy-1.2.5.tar.gz"
    sha256 "9635cffb9b6ecf7fd7f72aea1665829ac74a1d272006d0057d45a621aae20228"
  end

  resource "future" do
    url "https:files.pythonhosted.orgpackagesa7b24140c69c6a66432916b26158687e821ba631a4c9273c474343badf84d3bafuture-1.0.0.tar.gz"
    sha256 "bd2968309307861edae1458a4f8a4f3598c03be43b97521076aebf5d94c07b05"
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

  resource "idna" do
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "keepkey" do
    url "https:files.pythonhosted.orgpackages3038558d9a2dd1fd74f50ff4587b4054496ffb69e21ab1138eb448f3e8e2f4a7keepkey-6.3.1.tar.gz"
    sha256 "cef1e862e195ece3e42640a0f57d15a63086fd1dedc8b5ddfcbc9c2657f0bb1e"
  end

  resource "keepkey-agent" do
    url "https:files.pythonhosted.orgpackages65724bf47a7bc8dc93d2ac21672a0db4bc58a78ec5cee3c4bcebd0b4092a9110keepkey_agent-0.9.0.tar.gz"
    sha256 "47c85de0c2ffb53c5d7bd2f4d2230146a416e82511259fad05119c4ef74be70c"
  end

  resource "ledger-agent" do
    url "https:files.pythonhosted.orgpackagesa3c9ac7546d6168662af356493231ca8818bdf8ffd05238a68fe5085fd9e6358ledger_agent-0.9.0.tar.gz"
    sha256 "2265ba9c6a4594ff798fe480856ea36bfe6d8ae7ba2190b74f9666510530f20f"
  end

  resource "ledgerblue" do
    url "https:files.pythonhosted.orgpackages7068ae1dc25309ae92ac87134e542389e30b6efcac924384baef9622ece0e4ebledgerblue-0.1.54.tar.gz"
    sha256 "1e7f7d493e919c447a5c8ebeaea0373bdfda0bec216284cecdea07185fdf173e"
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

  resource "ndeflib" do
    url "https:files.pythonhosted.orgpackages58f8cd11ec90bd6a6bcf35bb80e4e29fdebe8bf2b05e869a93ca1e41d85518d0ndeflib-0.3.3.tar.gz"
    sha256 "1d56828558b9b16f2822a4051824346347b66adf5320ea86070748b6f2454a88"
  end

  resource "nfcpy" do
    url "https:files.pythonhosted.orgpackages38a2cce3ab796e84bea5098c4231ff56e523cb182c58a21280ccff0d75e693e6nfcpy-1.0.4.tar.gz"
    sha256 "e5bd08d0119e1d9e95d05215f838b07b44d03b651adddc523cc1a38892b8af6b"
  end

  resource "protobuf" do
    url "https:files.pythonhosted.orgpackages555be3d951e34f8356e5feecacd12a8e3b258a1da6d9a03ad1770f28925f29bcprotobuf-3.20.3.tar.gz"
    sha256 "2e3427429c9cffebf259491be0af70189607f365c2f41c7c3764af6f337105f2"
  end

  resource "pycryptodome" do
    url "https:files.pythonhosted.orgpackagesb9ed19223a0a0186b8a91ebbdd2852865839237a21c74f1fbc4b8d5b62965239pycryptodome-3.20.0.tar.gz"
    sha256 "09609209ed7de61c2b560cc5c8c4fbf892f8b15b1faf7e4cbffac97db1fffda7"
  end

  resource "pycryptodomex" do
    url "https:files.pythonhosted.orgpackages31a4b03a16637574312c1b54c55aedeed8a4cb7d101d44058d46a0e5706c63e1pycryptodomex-3.20.0.tar.gz"
    sha256 "7a710b79baddd65b806402e14766c721aee8fb83381769c27920f26476276c1e"
  end

  resource "pydes" do
    url "https:files.pythonhosted.orgpackages925e0075a35ea5d307a182b0963900298b209ea2f363ccdd5a27e8cb04c58410pyDes-2.0.1.tar.gz"
    sha256 "e2ab8e21d2b83e90d90dbfdcb6fb8ac0000b813238b7ecaede04f8435c389012"
  end

  resource "pyelftools" do
    url "https:files.pythonhosted.orgpackages88560f2d69ed9a0060da009f672ddec8a71c041d098a66f6b1d80264bf6bbdc0pyelftools-0.31.tar.gz"
    sha256 "c774416b10310156879443b81187d182d8d9ee499660380e645918b50bc88f99"
  end

  resource "pymsgbox" do
    url "https:files.pythonhosted.orgpackages7dff4c6f31a4f08979f12a663f2aeb6c8b765d3bd592e66eaaac445f547bb875PyMsgBox-1.0.9.tar.gz"
    sha256 "2194227de8bff7a3d6da541848705a155dcbb2a06ee120d9f280a1d7f51263ff"
  end

  resource "pynacl" do
    url "https:files.pythonhosted.orgpackagesa72227582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986daPyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "pyobjc-core" do
    url "https:files.pythonhosted.orgpackages24ac61c58e65780c6ba0523997d236fac99e38e5ddfabfd5b500409f8239a257pyobjc-core-10.2.tar.gz"
    sha256 "0153206e15d0e0d7abd53ee8a7fbaf5606602a032e177a028fc8589516a8771c"
  end

  resource "pyobjc-framework-cocoa" do
    url "https:files.pythonhosted.orgpackagesb0c07eb30628e1a60c8b700f0b15280417c754eda9f186d05d47f4cac6f4e1a7pyobjc-framework-Cocoa-10.2.tar.gz"
    sha256 "6383141379636b13855dca1b39c032752862b829f93a49d7ddb35046abfdc035"
  end

  resource "pyobjc-framework-corebluetooth" do
    url "https:files.pythonhosted.orgpackages8a448a76096e3443fed282db423b3a89e28d1ed2d07dd30e9b132e334b0aa929pyobjc-framework-CoreBluetooth-10.2.tar.gz"
    sha256 "fb69d2c61082935b2b12827c1ba4bb22146eb3d251695fa1d58bbd5835260729"
  end

  resource "pyobjc-framework-libdispatch" do
    url "https:files.pythonhosted.orgpackages25c5731a26daec598dbcb4a281a85364e98ebd10c3d00ceb21b7fec0fd8c884epyobjc-framework-libdispatch-10.2.tar.gz"
    sha256 "ae17602efbe628fa0432bcf436ee8137d2239a70669faefad420cd527e3ad567"
  end

  resource "pyserial" do
    url "https:files.pythonhosted.orgpackages1e7dae3f0a63f41e4d2f6cb66a5b57197850f919f59e558159a4dd3a818f5082pyserial-3.5.tar.gz"
    sha256 "3c77e014170dfffbd816e6ffc205e9842efb10be9f58ec16d3e8675b4925cddb"
  end

  resource "python-daemon" do
    url "https:files.pythonhosted.orgpackages845097b81327fccbb70eb99f3c95bd05a0c9d7f13fb3f4cfd975885110d1205apython-daemon-3.0.1.tar.gz"
    sha256 "6c57452372f7eaff40934a1c03ad1826bf5e793558e87fef49131e6464b4dae5"
  end

  resource "python-gnupg" do
    url "https:files.pythonhosted.orgpackagesb15d4425390ad81d22b330a1b0df204c4d39fb3cb7c39e081d51e9f7426ce716python-gnupg-0.5.2.tar.gz"
    sha256 "01d8013931c9fa3f45824bbea7054c03d6e11f258a72e7e086e168dbcb91854c"
  end

  resource "python-u2flib-host" do
    url "https:files.pythonhosted.orgpackages4d3d0997fe8196f5be24b7015708a0744a0ef928c4fb3c8bc820dc3328208ef2python-u2flib-host-3.0.3.tar.gz"
    sha256 "ab678b9dc29466a779efcaa2f0150dce35059a7d17680fc26057fa599a53fc0a"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages86ec535bf6f9bd280de6a4637526602a146a68fde757100ecf8c9333173392dbrequests-2.32.2.tar.gz"
    sha256 "dd951ff5ecf3e3b3aa26b40703ba77495dab41da839ae72ef3c8e5d8e2433289"
  end

  resource "semver" do
    url "https:files.pythonhosted.orgpackages416ca536cc008f38fd83b3c1b98ce19ead13b746b5588c9a0cb9dd9f6ea434bcsemver-3.0.2.tar.gz"
    sha256 "6253adb39c70f6e51afed2fa7152bcd414c411286088fb4b9effb133885ab4cc"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackagesaa605db2249526c9b453c5bb8b9f6965fcab0ddb7f40ad734420b3b421f7da44setuptools-70.0.0.tar.gz"
    sha256 "f211a66637b8fa059bb28183da127d4e86396c991a942b028c6650d4319c3fd0"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "trezor" do
    url "https:files.pythonhosted.orgpackages8e82831de0a643401c4dcfbbc17c33de35b8c3d23281ac60a0831be5f10838d3trezor-0.13.8.tar.gz"
    sha256 "634d4eddf35603257c321618d8548c6a35b27384657b65e3b0bdbad635a57cff"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesf6f3b827b3ab53b4e3d8513914586dcca61c355fa2ce8252dea4da56e67bf8f2typing_extensions-4.11.0.tar.gz"
    sha256 "83f085bd5ca59c80295fc2a82ab5dac679cbe02b9f33f7d83af68e241bea51b0"
  end

  resource "unidecode" do
    url "https:files.pythonhosted.orgpackagesf78919151076a006b9ac0dd37b1354e031f5297891ee507eb624755e58e10d3eUnidecode-1.3.8.tar.gz"
    sha256 "cfdb349d46ed3873ece4586b96aa75258726e2fa8ec21d6f00a591d98806c2f4"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages7a507fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  resource "websocket-client" do
    url "https:files.pythonhosted.orgpackagese630fba0d96b4b5fbf5948ed3f4681f7da2f9f64512e1d303f94b4cc174c24a5websocket_client-1.8.0.tar.gz"
    sha256 "3239df9f44da632f96012472805d40a23281a991027ce11d2f45a6f24ac4c3da"
  end

  resource "wheel" do
    url "https:files.pythonhosted.orgpackagesb8d6ac9cd92ea2ad502ff7c1ab683806a9deb34711a1e2bd8a59814e8fc27e69wheel-0.43.0.tar.gz"
    sha256 "465ef92c69fa5c5da2d1cf8ac40559a8c940886afcef87dcf14b9470862f1d85"
  end

  def install
    ENV.append "CFLAGS", "-I#{Formula["libusb"].include}libusb-1.0"
    venv = virtualenv_create(libexec, "python3.12")
    venv.pip_install resources.reject { |r| OS.mac? ? r.name == "dbus-fast" : r.name.start_with?("pyobjc") }
    venv.pip_install_and_link buildpath
  end

  test do
    output = shell_output("#{bin}trezor-agent identity@myhost 2>&1", 1)
    assert_match "Trezor not connected", output
  end
end