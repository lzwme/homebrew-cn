class KeeperCommander < Formula
  include Language::Python::Virtualenv

  desc "Command-line and SDK interface to Keeper Password Manager"
  homepage "https://docs.keeper.io/en/privileged-access-manager/commander-cli/overview"
  url "https://files.pythonhosted.org/packages/ac/98/1c2c2d6dafb28ed3a9e29265df758a2ce3a0a34a796adee4ab88cc98dd00/keepercommander-17.1.14.tar.gz"
  sha256 "451142edb7dba83382d5db6100cd0a78b4f2c0d46e5ab2c8f1a7813f7573916e"
  license "MIT"
  head "https://github.com/Keeper-Security/Commander.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "8c2689c8779838c446e3117518692dcfd77353265eec02f22dd056c9adf4bf72"
    sha256 cellar: :any,                 arm64_sequoia: "58bd2238f3e43f2f1087bc891f1c17e6f6619e8a1ef7b8aee932e204826f70fb"
    sha256 cellar: :any,                 arm64_sonoma:  "72597659eaedcb0f218710495fa09542ea2871853f9e8aefad3f00ebe489a057"
    sha256 cellar: :any,                 sonoma:        "3b6b4c815270dff04752575a500103e5eb314037ccd4a231121a5bcf0aaf1246"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "592184c2b1ed6e108f8953957aa118739de5ad34c74836bbb8e73503681e7929"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eddeea04fc0f42f9034462ba6cab2bafe2a91eb398c82c904ac3665ece0a5c20"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build # for bcrypt, keeper-pam-webrtc-rs

  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "ffmpeg"
  depends_on "libvpx"
  depends_on "libyaml"
  depends_on "opus"
  depends_on "pillow" => :no_linkage
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"
  depends_on "srtp"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1699
    depends_on "openssl@3"
  end

  on_intel do
    depends_on "libxcb"
    depends_on "openjpeg"
  end

  pypi_packages exclude_packages: %w[certifi cryptography pillow pydantic],
                extra_packages:   %w[cbor2 pyobjc-framework-localauthentication]

  resource "asciitree" do
    url "https://files.pythonhosted.org/packages/2d/6a/885bc91484e1aa8f618f6f0228d76d0e67000b0fdd6090673b777e311913/asciitree-0.3.3.tar.gz"
    sha256 "4aa4b9b649f85e3fcb343363d97564aa1fb62e249677f2e18a96765145cc0f6e"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/d4/36/3329e2518d70ad8e2e5817d5a4cac6bba05a47767ec416c7d020a965f408/bcrypt-5.0.0.tar.gz"
    sha256 "f748f7c2d6fd375cc93d3fba7ef4a9e3a092421b8dbf34d8d4dc06be9492dfdd"
  end

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/21/28/9b3f50ce0e048515135495f198351908d99540d69bfdc8c1d15b73dc55ce/blinker-1.9.0.tar.gz"
    sha256 "b4ce2265a7abece45e7cc896e98dbebe6cead56bcf805a3d23136d145f5445bf"
  end

  resource "cbor2" do
    url "https://files.pythonhosted.org/packages/a2/b8/c0f6a7d46f816cb18b1fda61a2fe648abe16039f1ff93ea720a6e9fb3cee/cbor2-5.7.1.tar.gz"
    sha256 "7a405a1d7c8230ee9acf240aad48ae947ef584e8af05f169f3c1bde8f01f8b71"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/46/61/de6cd827efad202d7057d93e0fed9294b96952e188f7384832791c7b2254/click-8.3.0.tar.gz"
    sha256 "e7b8232224eba16f4ebe410c25ced9f7875cb5f3263ffc93cc3e8da705e229c4"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "deprecated" do
    url "https://files.pythonhosted.org/packages/49/85/12f0a49a7c4ffb70572b6c2ef13c90c88fd190debda93b23f026b25f9634/deprecated-1.3.1.tar.gz"
    sha256 "b1b50e0ff0c1fddaa5708a2c6b0a6588bb09b892825ab2b214ac9ea9d92a5223"
  end

  resource "fido2" do
    url "https://files.pythonhosted.org/packages/8d/b9/6ec8d8ec5715efc6ae39e8694bd48d57c189906f0628558f56688d0447b2/fido2-2.0.0.tar.gz"
    sha256 "3061cd05e73b3a0ef6afc3b803d57c826aa2d6a9732d16abd7277361f58e7964"
  end

  resource "flask" do
    url "https://files.pythonhosted.org/packages/dc/6d/cfe3c0fcc5e477df242b98bfe186a4c34357b4847e87ecaef04507332dab/flask-3.1.2.tar.gz"
    sha256 "bf656c15c80190ed628ad08cdfd3aaa35beb087855e2f494910aa3774cc4fd87"
  end

  resource "flask-limiter" do
    url "https://files.pythonhosted.org/packages/e4/53/13ccac4772f7efd58e4b8308e2b8bfaef3a45a4420ec43966f2dbff904c8/flask_limiter-4.0.0.tar.gz"
    sha256 "536a8df0bb2033f415a2212e19a3b7ddfea38585ac5a2444e1cfa986a697847c"
  end

  resource "fonttools" do
    url "https://files.pythonhosted.org/packages/4b/42/97a13e47a1e51a5a7142475bbcf5107fe3a68fc34aef331c897d5fb98ad0/fonttools-4.60.1.tar.gz"
    sha256 "ef00af0439ebfee806b25f24c8f92109157ff3fac5731dc7867957812e87b8d9"
  end

  resource "fpdf2" do
    url "https://files.pythonhosted.org/packages/e9/c0/784b130a28f4ed612e9aff26d1118e1f91005713dcd0a35e60b54d316b56/fpdf2-2.8.5.tar.gz"
    sha256 "af4491ef2e0a5fe476f9d61362925658949c995f7e804438c0e81008f1550247"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/76/66/650a33bd90f786193e4de4b3ad86ea60b53c89b669a5c7be931fac31cdb0/importlib_metadata-8.7.0.tar.gz"
    sha256 "d13b81ad223b890aa16c5471f2ac3056cf76c5f10f82d6f9292f0b415f389000"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/9c/cb/8ac0172223afbccb63986cc25049b154ecfb5e85932587206f42317be31d/itsdangerous-2.2.0.tar.gz"
    sha256 "e0050c0b7da1eea53ffaf149c0cfbb5c6e2e2b69c4bef22c81fa6eb73e5f6173"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "keeper-pam-webrtc-rs" do
    url "https://files.pythonhosted.org/packages/17/cb/578235f3fe045da38623cb999d981270f9bc8f7c045fae3b6d1a5134644e/keeper_pam_webrtc_rs-1.1.6.tar.gz"
    sha256 "30fb4a9389ff0060412bc7dfa153fc868f6d2eb3a31b151a0b65d9fa4673eaaf"
  end

  resource "keeper-secrets-manager-core" do
    url "https://files.pythonhosted.org/packages/3b/4c/21b0b9569f96fc450a894b31ea066f4073944781a031b2f1940901257d53/keeper_secrets_manager_core-17.0.0.tar.gz"
    sha256 "f821d114b44ecd992870f4661d1daa5c50901d4abcc6d52c37926c372396d31c"
  end

  resource "limits" do
    url "https://files.pythonhosted.org/packages/bb/e5/c968d43a65128cd54fb685f257aafb90cd5e4e1c67d084a58f0e4cbed557/limits-5.6.0.tar.gz"
    sha256 "807fac75755e73912e894fdd61e2838de574c5721876a19f7ab454ae1fffb4b5"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "ordered-set" do
    url "https://files.pythonhosted.org/packages/4c/ca/bfac8bc689799bcca4157e0e0ced07e70ce125193fc2e166d2e685b7e2fe/ordered-set-4.1.0.tar.gz"
    sha256 "694a8e44c87657c59292ede72891eb91d34131f6531463aab3009191c77364a8"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/a1/96/06e01a7b38dce6fe1db213e061a4602dd6032a8a97ef6c1a862537732421/prompt_toolkit-3.0.52.tar.gz"
    sha256 "28cde192929c8e7321de85de1ddbe736f1375148b02f2e17edd840042b1be855"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/19/ff/64a6c8f420818bb873713988ca5492cba3a7946be57e027ac63495157d97/protobuf-6.33.0.tar.gz"
    sha256 "140303d5c8d2037730c548f8c7b93b20bb1dc301be280c378b82b8894589c954"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/e1/88/bdd0a41e5857d5d703287598cbf08dad90aed56774ea52ae071bae9071b6/psutil-7.1.3.tar.gz"
    sha256 "6c86281738d77335af7aec228328e944b30930899ea760ecf33a4dba66be5e74"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/c9/85/e24bf90972a30b0fcd16c73009add1d7d7cd9140c2498a68252028899e41/pycryptodomex-3.23.0.tar.gz"
    sha256 "71909758f010c82bc99b0abf4ea12012c98962fbf0583c2164f8b84533c2e4da"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pyngrok" do
    url "https://files.pythonhosted.org/packages/3f/64/5ab436dd78db3bcfdbae5965c48e21a6ee3fa6ec87859e44442e2fb361c3/pyngrok-7.4.1.tar.gz"
    sha256 "ad8637738ced5bdb88c28b087fea39ca552860c2d30004ac01033c0f8eb4f36e"
  end

  resource "pyobjc-core" do
    url "https://files.pythonhosted.org/packages/ab/dc/6d63019133e39e2b299dfbab786e64997fff0f145c45a417e1dd51faaf3f/pyobjc_core-12.0.tar.gz"
    sha256 "7e05c805a776149a937b61b892a0459895d32d9002bedc95ce2be31ef1e37a29"
  end

  resource "pyobjc-framework-cocoa" do
    url "https://files.pythonhosted.org/packages/37/6f/89837da349fe7de6476c426f118096b147de923139556d98af1832c64b97/pyobjc_framework_cocoa-12.0.tar.gz"
    sha256 "02d69305b698015a20fcc8e1296e1528e413d8cf9fdcd590478d359386d76e8a"
  end

  resource "pyobjc-framework-localauthentication" do
    url "https://files.pythonhosted.org/packages/08/20/6744b25940d9462e0410cadd6da2e25ea3c01e6067a1234d8092ae0a40fa/pyobjc_framework_localauthentication-12.0.tar.gz"
    sha256 "6287b671d4e418419d8d5b2244616d72f346f6b8a8bc18d9a6bccb93a291091c"
  end

  resource "pyobjc-framework-security" do
    url "https://files.pythonhosted.org/packages/cb/d6/ab109af82a65d52ab829010013b5a24b829c9155bc9608ebc80a43b8797c/pyobjc_framework_security-12.0.tar.gz"
    sha256 "d64d069da79fbf1dadbc091717604843b9d5be96670f7b40bc9a08df12b4045b"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/e8/52/d87eba7cb129b81563019d1679026e7a112ef76855d6159d24754dbd2a51/pyperclip-1.11.0.tar.gz"
    sha256 "244035963e4428530d9e3a6101a1ef97209c6825edab1567beac148ccc1db1b6"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/f0/26/19cadc79a718c5edbec86fd4919a6b6d3f681039a2f6d66d14be94e75fb9/python_dotenv-1.2.1.tar.gz"
    sha256 "42667e897e16ab0d66954af0e60a9caa94f0fd4ecf3aaf6d2d260eec1aa36ad6"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/fb/d2/8920e102050a0de7bfabeb4c4614a49248cf8d5d7a8d01885fbb24dc767a/rich-14.2.0.tar.gz"
    sha256 "73ff50c7c0c1c77c8243079283f4edb376f0f6442433aecb8ce7e6d0b92d1fe4"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/24/30/6b0809f4510673dc723187aeaf24c7f5459922d01e2f794277a3dfb90345/wcwidth-0.2.14.tar.gz"
    sha256 "4d478375d31bc5395a3c55c40ccdf3354688364cd61c4f6adacaa9215d0b3605"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/21/e6/26d09fab466b7ca9c7737474c52be4f76a40301b08362eb2dbc19dcc16c1/websockets-15.0.1.tar.gz"
    sha256 "82544de02076bafba038ce055ee6412d68da13ab47f0c60cab827346de828dee"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/9f/69/83029f1f6300c5fb2471d621ab06f6ec6b3324685a2ce0f9777fd4a8b71e/werkzeug-3.1.3.tar.gz"
    sha256 "60723ce945c19328679790e3282cc758aa4a6040e4bb330f53d30fa546d44746"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/49/19/5e5bcd855d808892fe02d49219f97a50f64cd6d8313d75df3494ee97b1a3/wrapt-2.0.0.tar.gz"
    sha256 "35a542cc7a962331d0279735c30995b024e852cf40481e384fd63caaa391cbb9"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/e3/02/0f2892c661036d50ede074e376733dca2ae7c6eb617489437771209d4180/zipp-3.23.0.tar.gz"
    sha256 "a07157588a12518c9d4034df3fbbee09c814741a33ff63c05fa29d26a2404166"
  end

  def install
    without = %w[keeper-pam-webrtc-rs]

    if OS.mac?
      # Help `pyobjc-framework-cocoa` pick correct SDK after removing -isysroot from Python formula
      ENV.append_to_cflags "-isysroot #{MacOS.sdk_path}"
      # pyobjc-core uses "-fdisable-block-signature-string" introduced in clang 17
      ENV.llvm_clang if DevelopmentTools.clang_build_version <= 1699
    else
      # `pyobjc-*` dependencies are only needed on macOS
      without += resources.filter_map { |r| r.name if r.name.start_with?("pyobjc") }
    end

    venv = virtualenv_install_with_resources(without:)

    # Workaround for `Caused by: Failed to read readme specified in pyproject.toml`
    resource("keeper-pam-webrtc-rs").stage do
      inreplace "pyproject.toml", "readme = \"README.md\"", ""
      venv.pip_install Pathname.pwd
    end
  end

  test do
    assert_match "keepersecurity.com", shell_output("#{bin}/keeper server")
  end
end