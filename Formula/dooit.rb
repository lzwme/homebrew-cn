class Dooit < Formula
  include Language::Python::Virtualenv

  desc "TUI todo manager"
  homepage "https://github.com/kraanzu/dooit"
  url "https://files.pythonhosted.org/packages/0b/42/5cc5f890df2de9088457f0274685713d0221e8406df89631767dd342b491/dooit-0.2.1.tar.gz"
  sha256 "7571d21385e2625646ac2572b59cc2ba9b8c5b6228165a444c76645e55444b62"
  license "MIT"
  revision 1
  head "https://github.com/kraanzu/dooit.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce5e1cd21f4835ea8b66b55f1293e719f44c8cf6c1d938386153773c28f251a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e55b13321bf9c9e8c63e8147f060a9c03f801f30d419a351f4a07afc7f0b6c20"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d3f04bbd64026605eb919a92a2114f681dc4e25355e8bc7598ad26f4f5c58399"
    sha256 cellar: :any_skip_relocation, ventura:        "0a22d8f1f05a84b1da88c452fa681dbf8c2f94fc8d884f5fe5ab73357c2cbc34"
    sha256 cellar: :any_skip_relocation, monterey:       "574cd4707bff5f6a30fde76afcbe57379fe827c20dec60e96946e7db2b87cce1"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf13f35ee7738abd8672a04925489875d17de8fc4a756dab14cd1a091cfbda7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88b292cf4e22aa9ce9dfbe3c614a2e45194386e43b04df4093585f40de0f5d30"
  end

  depends_on "cmake" => :build
  depends_on "poetry" => :build
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"
  depends_on "virtualenv"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/21/31/3f468da74c7de4fcf9b25591e682856389b3400b4b62f201e65f15ea3e07/attrs-22.2.0.tar.gz"
    sha256 "c9227bfc2f01993c03f68db37d1d15c9690188323c067c641f1a35ca58185f99"
  end

  resource "CacheControl" do
    url "https://files.pythonhosted.org/packages/06/80/1f8ba1ced5f29514d8621003b2b0fb404ed88996e963dbca7f519ecc82ca/CacheControl-0.12.12.tar.gz"
    sha256 "9c2e5208ea76ebd9921176569743ddf6d7f3bb4188dbf61806f0f8fc48ecad38"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2b/a8/050ab4f0c3d4c1b8aaa805f70e26e84d0e27004907c5b8ecc1d31815f92a/cffi-1.15.1.tar.gz"
    sha256 "d400bfb9a37b1351253cb402671cea7e89bdecc294e8016a707f6d1d8ac934f9"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/96/d7/1675d9089a1f4677df5eb29c3f8b064aa1e70c1251a0a8a127803158942d/charset-normalizer-3.0.1.tar.gz"
    sha256 "ebea339af930f8ca5d7a699b921106c6e29c617fe9606fa7baa043c1cdae326f"
  end

  resource "cleo" do
    url "https://files.pythonhosted.org/packages/83/51/b2609f0998671bef90b83407e75dbd8e3812e513e88f548d1b10b48a1d12/cleo-2.0.1.tar.gz"
    sha256 "eb4b2e1f3063c11085cebe489a6e9124163c226575a3c3be69b2e51af4a15ec5"
  end

  resource "commonmark" do
    url "https://files.pythonhosted.org/packages/60/48/a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0/commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "crashtest" do
    url "https://files.pythonhosted.org/packages/6e/5d/d79f51058e75948d6c9e7a3d679080a47be61c84d3cc8f71ee31255eb22b/crashtest-0.4.1.tar.gz"
    sha256 "80d7b1f316ebfbd429f648076d6275c877ba30ba48979de4191714a75266f0ce"
  end

  resource "dulwich" do
    url "https://files.pythonhosted.org/packages/d1/20/4c2ea55d6547460a93dce9112599953be1c939155eae7a8e11a17c4d0b2c/dulwich-0.20.50.tar.gz"
    sha256 "50a941796b2c675be39be728d540c16b5b7ce77eb9e1b3f855650ece6832d2be"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/0b/dc/eac02350f06c6ed78a655ceb04047df01b02c6b7ea3fc02d4df24ca87d24/filelock-3.9.0.tar.gz"
    sha256 "7b319f24340b51f55a2bf7a12ac0755a9b03e718311dac567a0f4f7fabd2f5de"
  end

  resource "html5lib" do
    url "https://files.pythonhosted.org/packages/ac/b6/b55c3f49042f1df3dcd422b7f224f939892ee94f22abcf503a9b7339eaf2/html5lib-1.1.tar.gz"
    sha256 "b2e5b40261e20f354d198eae92afc10d750afb487ed5e50f9c4eaf07c184146f"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/90/07/6397ad02d31bddf1841c9ad3ec30a693a3ff208e09c2ef45c9a8a5f85156/importlib_metadata-6.0.0.tar.gz"
    sha256 "e354bedeb60efa6affdcc8ae121b73544a7aa74156d047311948f6d711cd378d"
  end

  resource "jaraco.classes" do
    url "https://files.pythonhosted.org/packages/bf/02/a956c9bfd2dfe60b30c065ed8e28df7fcf72b292b861dca97e951c145ef6/jaraco.classes-3.2.3.tar.gz"
    sha256 "89559fa5c1d3c34eff6f631ad80bb21f378dbcbb35dd161fd2c6b93f5be2f98a"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/36/3d/ca032d5ac064dff543aa13c984737795ac81abc9fb130cd2fcff17cfabc7/jsonschema-4.17.3.tar.gz"
    sha256 "0f864437ab8b6076ba6707453ef8f98a6a0d512a80e93f8abdb676f737ecb60d"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/55/fe/282f4c205add8e8bb3a1635cbbac59d6def2e0891b145aa553a0e40dd2d0/keyring-23.13.1.tar.gz"
    sha256 "ba2e15a9b35e21908d0aaf4e0a47acc52d6ae33444df0da2b49d41a46ef6d678"
  end

  resource "lockfile" do
    url "https://files.pythonhosted.org/packages/17/47/72cb04a58a35ec495f96984dddb48232b551aafb95bde614605b754fe6f7/lockfile-0.12.2.tar.gz"
    sha256 "6aed02de03cba24efabcd600b30540140634fc06cfa603822d508d5361e9f799"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/13/b3/397aa9668da8b1f0c307bc474608653d46122ae0563d1d32f60e24fa0cbd/more-itertools-9.0.0.tar.gz"
    sha256 "5a6257e40878ef0520b1803990e3e22303a41b5714006c32a3fd8304b26ea1ab"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/22/44/0829b19ac243211d1d2bd759999aa92196c546518b0be91de9cacc98122a/msgpack-1.0.4.tar.gz"
    sha256 "f5d869c18f030202eb412f08b28d2afeea553d6613aee89e200d7aca7ef01f5f"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/47/d5/aca8ff6f49aa5565df1c826e7bf5e85a6df852ee063600c1efa5b932968c/packaging-23.0.tar.gz"
    sha256 "b6ad297f8907de0fa2fe1ccbd26fdaf387f5f47c7275fedf8cce89f99446cf97"
  end

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/e5/9b/ff402e0e930e70467a7178abb7c128709a30dfb22d8777c043e501bc1b10/pexpect-4.8.0.tar.gz"
    sha256 "fc65a43959d153d0114afe13997d439c22823a27cefceb5ff35c2178c6784c0c"
  end

  resource "pkginfo" do
    url "https://files.pythonhosted.org/packages/b4/1c/89b38e431c20d6b2389ed8b3926c2ab72f58944733ba029354c6d9f69129/pkginfo-1.9.6.tar.gz"
    sha256 "8fd5896e8718a4372f0ea9cc9d96f6417c9b986e23a4d116dda26b62cc29d046"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/cf/4d/198b7e6c6c2b152f4f9f4cdf975d3590e33e63f1920f2d89af7f0390e6db/platformdirs-2.6.2.tar.gz"
    sha256 "e1fea1fe471b9ff8332e229df3cb7de4f53eeea4998d3b6bfff542115e998bd2"
  end

  resource "poetry" do
    url "https://files.pythonhosted.org/packages/6b/ed/57f55c650cb61310ac15df2b694d41dfb45c33480c3394410a911b847971/poetry-1.3.2.tar.gz"
    sha256 "26ded25f0cf67943243ca4f0aafd47ec4668bdb62845dbb8c2b0e3d9cd280bf4"
  end

  resource "poetry-core" do
    url "https://files.pythonhosted.org/packages/ba/80/373557c83c79d0cc7add2c123be04c29d81b0ac3e631257d8d7dc0a3cf9c/poetry_core-1.4.0.tar.gz"
    sha256 "514bd33c30e0bf56b0ed44ee15e120d7e47b61ad908b2b1011da68c48a84ada9"
  end

  resource "poetry-plugin-export" do
    url "https://files.pythonhosted.org/packages/48/13/47dfed5231a975a0ee2bbb936638b71057b8b2c87ea1f010c37c83858ad1/poetry_plugin_export-1.3.0.tar.gz"
    sha256 "61ae5ec1db233aba947a48e1ce54c6ff66afd0e1c87195d6bce64c73a5ae658c"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/3d/7d/d05864a69e452f003c0d77e728e155a89a2a26b09e64860ddd70ad64fb26/psutil-5.9.4.tar.gz"
    sha256 "3d7f9739eb435d4b1338944abe23f49584bde5395f27487d2ee25ad9a8774a62"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/20/e5/16ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4e/ptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/da/6a/c427c06913204e24de28de5300d3f0e809933f376e0b7df95194b2bb3f71/Pygments-2.14.0.tar.gz"
    sha256 "b3ed06a9e8ac9a9aae5a6f5dbe78a8a58655d17b43b93c078f094ddc476ae297"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/a7/2c/4c64579f847bd5d539803c8b909e54ba087a79d01bb3aba433a95879a6c5/pyperclip-1.8.2.tar.gz"
    sha256 "105254a8b04934f0bc84e9c24eb360a591aaf6535c9def5f29d92af107a9bf57"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/bf/90/445a7dbd275c654c268f47fa9452152709134f61f09605cf776407055a89/pyrsistent-0.19.3.tar.gz"
    sha256 "1a2994773706bbb4995c31a97bc94f1418314923bd1048c6d964837040376440"
  end

  resource "rapidfuzz" do
    url "https://files.pythonhosted.org/packages/15/e5/2ab8375be6955aff1925b69c41429cbe54e32a67461c0b59f94c9b8b1cc5/rapidfuzz-2.13.7.tar.gz"
    sha256 "8d3e252d4127c79b4d7c2ae47271636cbaca905c8bb46d80c7930ab906cf4b5c"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/ee/391076f5937f0a8cdf5e53b701ffc91753e87b07d66bae4a09aa671897bf/requests-2.28.2.tar.gz"
    sha256 "98b1b2782e3c6c4904938b84c0eb932721069dfdb9134313beff7c83c2df24bf"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/0c/4c/07f01c6ac44f7784fa399137fbc8d0cdc1b5d35304e8c0f278ad82105b58/requests-toolbelt-0.10.1.tar.gz"
    sha256 "62e09f7ff5ccbda92772a29f394a49c3ad6cb181d568b1337626b2abb628a63d"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/11/23/814edf09ec6470d52022b9e95c23c1bef77f0bc451761e1504ebd09606d3/rich-12.6.0.tar.gz"
    sha256 "ba3a3775974105c221d31141f2c116f4fd65c5ceb0698657a11e9f295ec93fd0"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/1f/13/fab0a3f512478bc387b66c51557ee715ede8e9811c77ce952f9b9a4d8ac1/shellingham-1.5.0.post1.tar.gz"
    sha256 "823bc5fb5c34d60f285b624e7264f4dda254bc803a3774a147bf99c0e3004a28"
  end

  resource "textual" do
    url "https://files.pythonhosted.org/packages/8c/d1/c228993e8a21e24bb43a0376b2901b6f3f2033dae13e7f76d1103bb9b8a3/textual-0.1.18.tar.gz"
    sha256 "b2883f8ed291de58b9aa73de6d24bbaae0174687487458a4eb2a7c188a2acf23"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/ff/04/58b4c11430ed4b7b8f1723a5e4f20929d59361e9b17f0872d69681fd8ffd/tomlkit-0.11.6.tar.gz"
    sha256 "71b952e5721688937fb02cf9d354dbcf0785066149d2855e44531ebdd2b65d73"
  end

  resource "trove-classifiers" do
    url "https://files.pythonhosted.org/packages/a1/ba/ef6787959696b3946073767864c0ba8b5fb5075c2afaa76cf457085e8364/trove-classifiers-2023.1.20.tar.gz"
    sha256 "ed3fd4e1d2ea77ca9ed379380582566e6003a54d70a3e5521a9b2a7896609362"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c5/52/fe421fb7364aa738b3506a2d99e4f3a56e079c0a798e9f4fa5e14c60922f/urllib3-1.26.14.tar.gz"
    sha256 "076907bf8fd355cde77728471316625a4d2f7e713c125f51953bb5b3eecf4f72"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  resource "xattr" do
    url "https://files.pythonhosted.org/packages/a0/19/dfb42dd6e6749c6e6dde55b12ee44b3c8247c3cfa5b85180a60902722538/xattr-0.10.1.tar.gz"
    sha256 "c12e7d81ffaa0605b3ac8c22c2994a8e18a9cf1c59287a1b7722a2289c952ec5"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/1f/29/54ba1934c45af649698410456fa8a78a475c82efd5c562e51011079458d1/zipp-3.12.1.tar.gz"
    sha256 "a3cac813d40993596b39ea9e93a18e8a2076d5c378b8bc88ec32ab264e04ad02"
  end

  def install
    venv = virtualenv_create(libexec, "python3.11")
    venv.pip_install resources
    poetry = Formula["poetry"].opt_bin/"poetry"
    system poetry, "build", "--format", "wheel", "--verbose", "--no-interaction"
    venv.pip_install_and_link Dir["dist/dooit-*.whl"].first

    # we depend on virtualenv, but that's a separate formula, so install a `.pth` file to link them
    site_packages = Language::Python.site_packages("python3.11")
    virtualenv = Formula["virtualenv"].opt_libexec
    (libexec/site_packages/"homebrew-virtualenv.pth").write virtualenv/site_packages
  end

  test do
    PTY.spawn(bin/"dooit") do |r, w, _pid|
      r.winsize = [80, 43]
      sleep 1
      # Create a topic
      w.write "a"
      sleep 1
      w.write "Test Topic"
      sleep 1
      w.write "\e"
      sleep 1
      # Create a todo in the topic
      w.write "\n"
      sleep 1
      w.write "a"
      sleep 1
      w.write "Test Todo"
      sleep 1
      w.write "\e"
      sleep 1
      # Exit
      w.write "\x03"
      begin
        r.read
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end
  end
end