class TrezorAgent < Formula
  include Language::Python::Virtualenv

  desc "Hardware SSHGPG agent for Trezor, Keepkey & Ledger"
  homepage "https:github.comromanztrezor-agent"
  url "https:files.pythonhosted.orgpackages11bcaa2bdee9cd81af9ecde0a9e8b5c6c6594a4a0ee7ade950b51a39d54f9e63trezor_agent-0.12.0.tar.gz"
  sha256 "e08ca5a54bd7658017164c8518d6cdf623d3b077dfdccfd12f612af5fef05855"
  license "LGPL-3.0-only"
  revision 6

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3cf5dd8fd1c6dd007964f1e81ec9218e3dc1d5d9f1bb545fe84caf215856221b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b921ca2520b8c663f0f7a281de0f80233ec71aeaa1e5f6cdffcf8248183d65c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4ab6e698fb20adc705a359d0c3385b39d6b98cce041e4609a3009de6da934c8d"
    sha256 cellar: :any_skip_relocation, sonoma:        "68a141cce758ffa8ff2f55c359d821d03786bcd6ed0fee2c72de57401c1cc6fc"
    sha256 cellar: :any_skip_relocation, ventura:       "dcf4a3c22308bec19c31bd8421416bd9d92a280b6e4bc447c4bdab60f37b307f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59269110bdfa3b35e7d8e7f9132916ab56fd010dec905625e00d25e942666799"
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
    url "https:files.pythonhosted.orgpackages0376733131e2935f4fcdc7a0dd47cbc5090e12d578297804fb0482575db43f3cbleak-0.22.2.tar.gz"
    sha256 "09010c0f4bd843e7dcaa1652e1bfb2450ce690da08d4c6163f0723aaa986e9fe"
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
    url "https:files.pythonhosted.orgpackagesbf6f90c536b020a8e860f047a2839830a1ade3e1490e67336ecf489b4856eb7bhidapi-0.14.0.post2.tar.gz"
    sha256 "6c0e97ba6b059a309d51b495a8f0d5efbcea8756b640d98b6f6bb9fdef2458ac"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
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
    url "https:files.pythonhosted.orgpackages339fd80eb0568f617d4041fd83b8b301fdb817290503ee4c1546024df916454elibagent-0.15.0.tar.gz"
    sha256 "c87caebdb932ed42bcd8a8cbe40ce3589587c71c3513ca79cadf7a040e24b4eb"
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
    url "https:files.pythonhosted.orgpackages135213b9db4a913eee948152a079fe58d035bd3d1a519584155da8e786f767e6pycryptodome-3.21.0.tar.gz"
    sha256 "f7787e0d469bdae763b876174cf2e6c0f7be79808af26b1da96f1a64bcf47297"
  end

  resource "pycryptodomex" do
    url "https:files.pythonhosted.orgpackages11dce66551683ade663b5f07d7b3bc46434bf703491dbd22ee12d1f979ca828fpycryptodomex-3.21.0.tar.gz"
    sha256 "222d0bd05381dd25c32dd6065c071ebf084212ab79bab4599ba9e6a3e0009e6c"
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
    url "https:files.pythonhosted.orgpackagesb740a38d78627bd882d86c447db5a195ff307001ae02c1892962c656f2fd6b83pyobjc_core-10.3.1.tar.gz"
    sha256 "b204a80ccc070f9ab3f8af423a3a25a6fd787e228508d00c4c30f8ac538ba720"
  end

  resource "pyobjc-framework-cocoa" do
    url "https:files.pythonhosted.orgpackagesa76cb62e31e6e00f24e70b62f680e35a0d663ba14ff7601ae591b5d20e251161pyobjc_framework_cocoa-10.3.1.tar.gz"
    sha256 "1cf20714daaa986b488fb62d69713049f635c9d41a60c8da97d835710445281a"
  end

  resource "pyobjc-framework-corebluetooth" do
    url "https:files.pythonhosted.orgpackagesf76989afd7747f42d2eb1e8f4b7f2ba2739d98ccf36f6b5c72474802962494depyobjc_framework_corebluetooth-10.3.1.tar.gz"
    sha256 "dc5d326ab5541b8b68e7e920aa8363851e779cb8c33842f6cfeef4674cc62f94"
  end

  resource "pyobjc-framework-libdispatch" do
    url "https:files.pythonhosted.orgpackagesb7371a7d9e5a04ab42aa8186f3493478c055601503ac7f8d58b8501d23db8b21pyobjc_framework_libdispatch-10.3.1.tar.gz"
    sha256 "f5c3475498cb32f54d75e21952670e4a32c8517fb2db2e90869f634edc942446"
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
    url "https:files.pythonhosted.orgpackages85612df3cd6f49dbb2d4a6a567cac1d803e3a50d86207e196d0f9e67a48664f7python-gnupg-0.5.3.tar.gz"
    sha256 "290d8ddb9cd63df96cfe9284b9b265f19fd6e145e5582dc58fd7271f026d0a47"
  end

  resource "python-u2flib-host" do
    url "https:files.pythonhosted.orgpackages4d3d0997fe8196f5be24b7015708a0744a0ef928c4fb3c8bc820dc3328208ef2python-u2flib-host-3.0.3.tar.gz"
    sha256 "ab678b9dc29466a779efcaa2f0150dce35059a7d17680fc26057fa599a53fc0a"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "semver" do
    url "https:files.pythonhosted.orgpackages416ca536cc008f38fd83b3c1b98ce19ead13b746b5588c9a0cb9dd9f6ea434bcsemver-3.0.2.tar.gz"
    sha256 "6253adb39c70f6e51afed2fa7152bcd414c411286088fb4b9effb133885ab4cc"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages27b8f21073fde99492b33ca357876430822e4800cdf522011f18041351dfa74bsetuptools-75.1.0.tar.gz"
    sha256 "d59a21b17a275fb872a9c3dae73963160ae079f1049ed956880cd7c09b120538"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "trezor" do
    url "https:files.pythonhosted.orgpackages1011b80ffb168b3e1c41c96c7278693eb6421cf567181afea9514c1ccd11c1edtrezor-0.13.9.tar.gz"
    sha256 "9450bd7bb9d23e5e33a3c9e58e18f058b44c9d9c34ca664b4981a795aa9fb1ef"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesdfdbf35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "unidecode" do
    url "https:files.pythonhosted.orgpackagesf78919151076a006b9ac0dd37b1354e031f5297891ee507eb624755e58e10d3eUnidecode-1.3.8.tar.gz"
    sha256 "cfdb349d46ed3873ece4586b96aa75258726e2fa8ec21d6f00a591d98806c2f4"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesed6322ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  resource "websocket-client" do
    url "https:files.pythonhosted.orgpackagese630fba0d96b4b5fbf5948ed3f4681f7da2f9f64512e1d303f94b4cc174c24a5websocket_client-1.8.0.tar.gz"
    sha256 "3239df9f44da632f96012472805d40a23281a991027ce11d2f45a6f24ac4c3da"
  end

  resource "wheel" do
    url "https:files.pythonhosted.orgpackagesb7a095e9e962c5fd9da11c1e28aa4c0d8210ab277b1ada951d2aee336b505813wheel-0.44.0.tar.gz"
    sha256 "a29c3f2817e95ab89aa4660681ad547c0e9547f20e75b0562fe7723c9a2a9d49"
  end

  def install
    # Help gcc to find libusb headers on Linux.
    ENV.append "CFLAGS", "-I#{Formula["libusb"].opt_include}libusb-1.0" unless OS.mac?

    venv = virtualenv_create(libexec, "python3.12")
    venv.pip_install resources.reject { |r|
      r.name == "python-daemon" || (OS.mac? ? r.name == "dbus-fast" : r.name.start_with?("pyobjc"))
    }
    venv.pip_install_and_link buildpath

    # Workaround breaking change in `setuptools`: https:pagure.iopython-daemonissue94
    resource("python-daemon").stage do
      inreplace "version.py", "import setuptools.extern.packaging.version", ""
      inreplace "version.py", "self.validate_version(version)", ""
      venv.pip_install Pathname.pwd
    end
  end

  test do
    output = shell_output("#{bin}trezor-agent identity@myhost 2>&1", 1)
    assert_match "Trezor not connected", output
  end
end