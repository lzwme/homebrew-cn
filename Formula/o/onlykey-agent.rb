class OnlykeyAgent < Formula
  include Language::Python::Virtualenv

  desc "Middleware that lets you use OnlyKey as a hardware SSHGPG device"
  homepage "https:docs.crp.toonlykey-agent.html"
  url "https:files.pythonhosted.orgpackages6880e89b6c3680bedb1e14e99f0539ac805bddc7d8dd87c58805c64484966b7conlykey-agent-1.1.15.tar.gz"
  sha256 "49b19bec28dc0fb7053ef01266d8a9e7a078bb146214a641bdbb1feac6fc7ddb"
  license "LGPL-3.0-only"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f4646d70e218d9f1ff7092c9b10085ec6db505d0be11f699e1b4db5c4db1f978"
    sha256 cellar: :any,                 arm64_ventura:  "ac9ee0f7a22744b11b3bb76c9c96a18f27f231ff7825c6eaf6b27bf86124ba64"
    sha256 cellar: :any,                 arm64_monterey: "17908a95210886d518b8acdaf68dd9581e3637a9d195b195c26d20fe3b4cbeee"
    sha256 cellar: :any,                 sonoma:         "0688e6a14d47ab95e26160fc17b42757e883d6f14959e418166bfe8278a60dea"
    sha256 cellar: :any,                 ventura:        "bef8bbca5354d54ccfe65be79298a87e4eed85de0e4132fc9624bb126d610e7e"
    sha256 cellar: :any,                 monterey:       "df31c419297e9ce9921264504b4eaf2be420dd9db7ff580c5bed4c2deae9d1d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e93bb1e9c58a6aa64a1bd3b7880be483d5036aa8acd4ef0a8fb5d11cc85ad7e"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "cython"
  depends_on "gnupg"
  depends_on "hidapi"
  depends_on "libusb"
  depends_on "python@3.12"

  resource "aenum" do
    url "https:files.pythonhosted.orgpackagesd0f833e75863394f42e429bb553e05fda7c59763f0fd6848de847a25b3fbccf6aenum-3.1.15.tar.gz"
    sha256 "8cbd76cd18c4f870ff39b24284d3ea028fbe8731a58df3aa581e434c575b9559"
  end

  resource "backports-shutil-which" do
    url "https:files.pythonhosted.orgpackagesa02251b896a4539f1bff6a7ab8514eb031b9f43f12bff23f75a4c3f4e9a666e5backports.shutil_which-3.5.2.tar.gz"
    sha256 "fe39f567cbe4fad89e8ac4dbeb23f87ef80f7fe8e829669d0221ecdb0437c133"
  end

  resource "bech32" do
    url "https:files.pythonhosted.orgpackagesabfeb67ac9b123e25a3c1b8fc3f3c92648804516ab44215adb165284e024c43fbech32-1.2.0.tar.gz"
    sha256 "7d6db8214603bd7871fcfa6c0826ef68b85b0abd90fa21c285a9c5e21d2bd899"
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

  resource "docutils" do
    url "https:files.pythonhosted.orgpackagesaeedaefcc8cd0ba62a0560c3c18c33925362d46c6075480bfa4df87b28e169a9docutils-0.21.2.tar.gz"
    sha256 "3a6b18732edf182daa3cd12775bbb338cf5691468f91eeeb109deff6ebfa986f"
  end

  resource "ecdsa" do
    url "https:files.pythonhosted.orgpackages5ed0ec8ac1de7accdcf18cfe468653ef00afd2f609faf67c423efbd02491051becdsa-0.19.0.tar.gz"
    sha256 "60eaad1199659900dd0af521ed462b793bbdf867432b3948e87416ae4caf6bf8"
  end

  resource "fido2" do
    url "https:files.pythonhosted.orgpackages746e58e1bb40a284291ab483d00831c5b91fe14d498a3ae7c658f3c588658e4bfido2-0.9.3.tar.gz"
    sha256 "b45e89a6109cfcb7f1bb513776aa2d6408e95c4822f83a253918b944083466ec"
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

  resource "intelhex" do
    url "https:files.pythonhosted.orgpackages66371e7522494557d342a24cb236e2aec5d078fac8ed03ad4b61372586406b01intelhex-2.3.0.tar.gz"
    sha256 "892b7361a719f4945237da8ccf754e9513db32f5628852785aea108dcd250093"
  end

  resource "lib-agent" do
    url "https:files.pythonhosted.orgpackages9665453f7b077b55610ad46a7018027af44d39e3affa56950d67dc1fdbfdc622lib-agent-1.0.6.tar.gz"
    sha256 "22b262cc81c320f1e8e2d55db946adeeedf5cc7a3736df2070c3b2514aa436ed"
  end

  resource "lockfile" do
    url "https:files.pythonhosted.orgpackages174772cb04a58a35ec495f96984dddb48232b551aafb95bde614605b754fe6f7lockfile-0.12.2.tar.gz"
    sha256 "6aed02de03cba24efabcd600b30540140634fc06cfa603822d508d5361e9f799"
  end

  resource "mnemonic" do
    url "https:files.pythonhosted.orgpackagesff77e6232ed59fbd7b90208bb8d4f89ed5aabcf30a524bc2fb8f0dafbe8e7df9mnemonic-0.21.tar.gz"
    sha256 "1fe496356820984f45559b1540c80ff10de448368929b9c60a2b55744cc88acf"
  end

  resource "onlykey" do
    url "https:files.pythonhosted.orgpackages95275bf7048f6d9de97610b6252b392a6d2d7e929dcd82809b973aebf1727114onlykey-1.2.10.tar.gz"
    sha256 "666427c99c7d625208c4c31d674536cdbf9000d7dcc2bb46ee24752e98339814"
  end

  resource "onlykey-solo-python" do
    url "https:files.pythonhosted.orgpackagesf5aada868b3a695ed2de3ffd71455a8269e031fd478957e888028480f7331c6bonlykey-solo-python-0.0.32.tar.gz"
    sha256 "f3c0ee8605f8142c3320acf0e11a9680cb6345d7f986e5652841c00049a29ee4"
  end

  resource "prompt-toolkit" do
    url "https:files.pythonhosted.orgpackagesccc625b6a3d5cd295304de1e32c9edbcf319a52e965b339629d37d42bb7126caprompt_toolkit-3.0.43.tar.gz"
    sha256 "3527b7af26106cbc65a040bcc84839a3566ec1b051bb0bfe953631e704b0ff7d"
  end

  resource "pycryptodome" do
    url "https:files.pythonhosted.orgpackagesb9ed19223a0a0186b8a91ebbdd2852865839237a21c74f1fbc4b8d5b62965239pycryptodome-3.20.0.tar.gz"
    sha256 "09609209ed7de61c2b560cc5c8c4fbf892f8b15b1faf7e4cbffac97db1fffda7"
  end

  resource "pymsgbox" do
    url "https:files.pythonhosted.orgpackages7dff4c6f31a4f08979f12a663f2aeb6c8b765d3bd592e66eaaac445f547bb875PyMsgBox-1.0.9.tar.gz"
    sha256 "2194227de8bff7a3d6da541848705a155dcbb2a06ee120d9f280a1d7f51263ff"
  end

  resource "pynacl" do
    url "https:files.pythonhosted.orgpackagesa72227582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986daPyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "pyserial" do
    url "https:files.pythonhosted.orgpackages1e7dae3f0a63f41e4d2f6cb66a5b57197850f919f59e558159a4dd3a818f5082pyserial-3.5.tar.gz"
    sha256 "3c77e014170dfffbd816e6ffc205e9842efb10be9f58ec16d3e8675b4925cddb"
  end

  resource "python-daemon" do
    url "https:files.pythonhosted.orgpackages845097b81327fccbb70eb99f3c95bd05a0c9d7f13fb3f4cfd975885110d1205apython-daemon-3.0.1.tar.gz"
    sha256 "6c57452372f7eaff40934a1c03ad1826bf5e793558e87fef49131e6464b4dae5"
  end

  resource "pyusb" do
    url "https:files.pythonhosted.orgpackagesd96e433a5614132576289b8643fe598dd5d51b16e130fd591564be952e15bb45pyusb-1.2.1.tar.gz"
    sha256 "a4cc7404a203144754164b8b40994e2849fde1cfff06b08492f12fff9d9de7b9"
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

  resource "unidecode" do
    url "https:files.pythonhosted.orgpackagesf78919151076a006b9ac0dd37b1354e031f5297891ee507eb624755e58e10d3eUnidecode-1.3.8.tar.gz"
    sha256 "cfdb349d46ed3873ece4586b96aa75258726e2fa8ec21d6f00a591d98806c2f4"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages7a507fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages6c6353559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  resource "wheel" do
    url "https:files.pythonhosted.orgpackagesb8d6ac9cd92ea2ad502ff7c1ab683806a9deb34711a1e2bd8a59814e8fc27e69wheel-0.43.0.tar.gz"
    sha256 "465ef92c69fa5c5da2d1cf8ac40559a8c940886afcef87dcf14b9470862f1d85"
  end

  def install
    python3 = "python3.12"
    venv = virtualenv_create(libexec, python3)

    # Use brewed hidadpi: https:github.comtrezorcython-hidapiissues54
    # TODO: For hidapi>0.14, replace with ENV["HIDAPI_SYSTEM_HIDAPI"] = ENV["HIDAPI_WITH_LIBUSB"] = "1"
    resource("hidapi").stage do
      inreplace "setup.py" do |s|
        s.gsub! "system_hidapi = 0", "system_hidapi = 1"
        s.gsub! "usrincludehidapi", "#{Formula["hidapi"].opt_include}hidapi"
      end
      venv.pip_install Pathname.pwd
    end

    venv.pip_install resources.reject { |r| r.name == "hidapi" }
    venv.pip_install_and_link buildpath

    # add path configuration file to find cython
    site_packages = Language::Python.site_packages(python3)
    (libexecsite_packages"homebrew-onlykey-agent.pth").write Formula["cython"].opt_libexecsite_packages
  end

  test do
    # the device mut not be plugged in to get the expected message
    # since CI is the foremost user of `brew test` we assume that there is no device
    output = shell_output("#{bin}onlykey-agent test@example.com 2>&1", 1)
    assert_match("try unplugging and replugging your device", output)
  end
end