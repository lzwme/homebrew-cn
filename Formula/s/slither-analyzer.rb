class SlitherAnalyzer < Formula
  include Language::Python::Virtualenv

  desc "Solidity static analysis framework written in Python 3"
  homepage "https:github.comcryticslither"
  url "https:files.pythonhosted.orgpackagesee64ebefdb4d633754013cafe1e8c28c04722ff49d5bdd98b6393dcd50f35428slither_analyzer-0.10.4.tar.gz"
  sha256 "bb89945509c7c1d461db2af1bfd85a7a02878334050e23aefc88d65568783a32"
  license "AGPL-3.0-only"
  revision 1
  head "https:github.comcryticslither.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d04b34a30b6498e304d2bdc532293b32459fa4476de077fc5c47edf38cd96f33"
    sha256 cellar: :any,                 arm64_sonoma:  "cf8ee110d27cd3ccf6b906db73adb76b7f978c3bf998f3b6bf63d69a2d90ea9d"
    sha256 cellar: :any,                 arm64_ventura: "54933e553f6d3584dd7f63c737915a230839701a403a3c9b46f8058f41a75c32"
    sha256 cellar: :any,                 sonoma:        "4f508286c6cd7e97586c03b8f0cef9a157852e548e909a7aaff5346a1e7a4893"
    sha256 cellar: :any,                 ventura:       "473cf14339a1541babc99e94eb6e5f56c826508e9b9d23a4f6ff88d1022d50d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89ffd5c510a1029835936f121b9bd5e20be9d8432e954b81454083c617ed46d3"
  end

  depends_on "rust" => :build # for rpds-py
  depends_on "certifi"
  depends_on "python@3.13"

  resource "aiohappyeyeballs" do
    url "https:files.pythonhosted.orgpackagesbc692f6d5a019bd02e920a3417689a89887b39ad1e350b562f9955693d900c40aiohappyeyeballs-2.4.3.tar.gz"
    sha256 "75cf88a15106a5002a8eb1dab212525c00d1f4c0fa96e551c9fbe6f09a621586"
  end

  resource "aiohttp" do
    url "https:files.pythonhosted.orgpackagesd566a967a2e9ceab12b6970ca5be3bccc9cf13fed4acfabe2c66de3d75599185aiohttp-3.11.6.tar.gz"
    sha256 "fd9f55c1b51ae1c20a1afe7216a64a88d38afee063baa23c7fce03757023c999"
  end

  resource "aiosignal" do
    url "https:files.pythonhosted.orgpackagesae670952ed97a9793b4958e5736f6d2b346b414a2cd63e82d05940032f45b32faiosignal-1.3.1.tar.gz"
    sha256 "54cd96e15e1649b75d6c87526a6ff0b6c1b0dd3459f43d9ca11d48c339b68cfc"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackagesfc0faafca9af9315aee06a89ffde799a10a582fe8de76c563ee80bbcdc08b3fbattrs-24.2.0.tar.gz"
    sha256 "5cfb1b9148b5b086569baec03f20d7b6bf3bcacc9a42bebf87ffaaca362f6346"
  end

  resource "bitarray" do
    url "https:files.pythonhosted.orgpackages8562dcfac53d22ef7e904ed10a8e710a36391d2d6753c34c869b51bfc5e4ad54bitarray-3.0.0.tar.gz"
    sha256 "a2083dc20f0d828a7cdf7a16b20dae56aab0f43dc4f347a3b3039f6577992b03"
  end

  resource "cbor2" do
    url "https:files.pythonhosted.orgpackagese4aaba55b47d51d27911981a18743b4d3cebfabccbb0598c09801b734cec4184cbor2-5.6.5.tar.gz"
    sha256 "b682820677ee1dbba45f7da11898d2720f92e06be36acec290867d5ebf3d7e09"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagesf24fe1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1echarset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
  end

  resource "ckzg" do
    url "https:files.pythonhosted.orgpackages70804b6219a65634915efc4694fa606f38d4b893dcdc1e50b9bcf69b38ec82b0ckzg-2.0.1.tar.gz"
    sha256 "62c5adc381637affa7e1df465c57750b356a761b8a3164c3106589b02532b9c9"
  end

  resource "crytic-compile" do
    url "https:files.pythonhosted.orgpackages54f86833fb37702900711e5617e0594e2eeccbb0b716993e84b00ee186907e1ccrytic-compile-0.3.7.tar.gz"
    sha256 "c7713d924544934d063e68313da8d588a3ad82cd4f40eae30d99f2dd6e640d4b"
  end

  resource "cytoolz" do
    url "https:files.pythonhosted.orgpackagese24cca9b05bdfa28ddbb4a5365c27021a1d4be61db7d8f6b4e5d4e76aa4ba3b7cytoolz-1.0.0.tar.gz"
    sha256 "eb453b30182152f9917a5189b7d99046b6ce90cdf8aeb0feff4b2683e600defd"
  end

  resource "eth-abi" do
    url "https:files.pythonhosted.orgpackages91f7dc714b95d07ee825f60fc62c26822a5da44b4930d362f8f5ab69eb2d7403eth_abi-5.1.0.tar.gz"
    sha256 "33ddd756206e90f7ddff1330cc8cac4aa411a824fe779314a0a52abea2c8fc14"
  end

  resource "eth-account" do
    url "https:files.pythonhosted.orgpackages73422d1e2f1cb8b3f40f8c85f7df33e78ac0fc5f947c955607238e2e4a0d418beth_account-0.11.3.tar.gz"
    sha256 "a712a9534638a7cfaa4cc069f1b9d5cefeee70362cfc3a7b0a2534ee61ce76c9"
  end

  resource "eth-hash" do
    url "https:files.pythonhosted.orgpackagesc6b657c89b91cf2dbb02b3019337f97bf346167d06cd23d3bde43c9fe52cae7eeth-hash-0.7.0.tar.gz"
    sha256 "bacdc705bfd85dadd055ecd35fd1b4f846b671add101427e089a4ca2e8db310a"
  end

  resource "eth-keyfile" do
    url "https:files.pythonhosted.orgpackages3566dd823b1537befefbbff602e2ada88f1477c5b40ec3731e3d9bc676c5f716eth_keyfile-0.8.1.tar.gz"
    sha256 "9708bc31f386b52cca0969238ff35b1ac72bd7a7186f2a84b86110d3c973bec1"
  end

  resource "eth-keys" do
    url "https:files.pythonhosted.orgpackages584aaabe0bff4e299858845fba5598c435f2bee0646366b9635750133904e2d8eth_keys-0.6.0.tar.gz"
    sha256 "ba33230f851d02c894e83989185b21d76152c49b37e35b61b1d8a6d9f1d20430"
  end

  resource "eth-rlp" do
    url "https:files.pythonhosted.orgpackages9b2efb9c2e0a2d0e249b61abf462828f3f8039305dfbe5844e138ab1a3b3a413eth-rlp-1.0.1.tar.gz"
    sha256 "d61dbda892ee1220f28fb3663c08f6383c305db9f1f5624dc585c9cd05115027"
  end

  resource "eth-typing" do
    url "https:files.pythonhosted.orgpackages9e24b913ef5d1a9ff300b05de0f0c06a4d00caa2b1b81f8c7448d069f94a4168eth_typing-4.4.0.tar.gz"
    sha256 "93848083ac6bb4c20cc209ea9153a08b0a528be23337c889f89e1e5ffbe9807d"
  end

  resource "eth-utils" do
    url "https:files.pythonhosted.orgpackages7b54ec65cf194c9b035df5cc00596a9eedcb430eabaf5486207e5ce859fe2aafeth_utils-4.1.1.tar.gz"
    sha256 "71c8d10dec7494aeed20fa7a4d52ec2ce4a2e52fdce80aab4f5c3c19f3648b25"
  end

  resource "frozenlist" do
    url "https:files.pythonhosted.orgpackages8fed0f4cec13a93c02c47ec32d81d11c0c1efbadf4a471e3f3ce7cad366cbbd3frozenlist-1.5.0.tar.gz"
    sha256 "81d5af29e61b9c8348e876d442253723928dce6433e0e76cd925cd83f1b4b817"
  end

  resource "hexbytes" do
    url "https:files.pythonhosted.orgpackagesc194fbfd526e8964652eec6a7b74ae18d1426e225ab602553858531ec6567d05hexbytes-0.3.1.tar.gz"
    sha256 "a3fe35c6831ee8fafd048c4c086b986075fc14fd46258fa24ecb8d65745f9a9d"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "jsonschema" do
    url "https:files.pythonhosted.orgpackages382e03362ee4034a4c917f697890ccd4aec0800ccf9ded7f511971c75451deecjsonschema-4.23.0.tar.gz"
    sha256 "d71497fef26351a33265337fa77ffeb82423f3ea21283cd9467bb03999266bc4"
  end

  resource "jsonschema-specifications" do
    url "https:files.pythonhosted.orgpackages10db58f950c996c793472e336ff3655b13fbcf1e3b359dcf52dcf3ed3b52c352jsonschema_specifications-2024.10.1.tar.gz"
    sha256 "0f38b83639958ce1152d02a7f062902c41c8fd20d558b0c34344292d417ae272"
  end

  resource "lru-dict" do
    url "https:files.pythonhosted.orgpackages836321480e8ecc218b9b15672d194ea79da8a7389737c21d8406254306733caclru-dict-1.2.0.tar.gz"
    sha256 "13c56782f19d68ddf4d8db0170041192859616514c706b126d0df2ec72a11bd7"
  end

  resource "multidict" do
    url "https:files.pythonhosted.orgpackagesd6be504b89a5e9ca731cd47487e91c469064f8ae5af93b7259758dcfc2b9c848multidict-6.1.0.tar.gz"
    sha256 "22ae2ebf9b0c69d206c003e2f6a914ea33f0a932d4aa16f236afc049d9958f4a"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesd06368dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106dapackaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "parsimonious" do
    url "https:files.pythonhosted.orgpackages7b91abdc50c4ef06fdf8d047f60ee777ca9b2a7885e1a9cea81343fbecda52d7parsimonious-0.10.0.tar.gz"
    sha256 "8281600da180ec8ae35427a4ab4f7b82bfec1e3d1e52f80cb60ea82b9512501c"
  end

  resource "prettytable" do
    url "https:files.pythonhosted.orgpackages3b8ade4dc1a6098621781c266b3fb3964009af1e9023527180cb8a3b0dd9d09eprettytable-3.12.0.tar.gz"
    sha256 "f04b3e1ba35747ac86e96ec33e3bb9748ce08e254dc2a1c6253945901beec804"
  end

  resource "propcache" do
    url "https:files.pythonhosted.orgpackagesa94d5e5a60b78dbc1d464f8a7bbaeb30957257afdc8512cbb9dfd5659304f5cdpropcache-0.2.0.tar.gz"
    sha256 "df81779732feb9d01e5d513fad0122efb3d53bbc75f61b2a4f29a020bc985e70"
  end

  resource "protobuf" do
    url "https:files.pythonhosted.orgpackages746ee69eb906fddcb38f8530a12f4b410699972ab7ced4e21524ece9d546ac27protobuf-5.28.3.tar.gz"
    sha256 "64badbc49180a5e401f373f9ce7ab1d18b63f7dd4a9cdc43c92b9f0b481cef7b"
  end

  resource "pycryptodome" do
    url "https:files.pythonhosted.orgpackages135213b9db4a913eee948152a079fe58d035bd3d1a519584155da8e786f767e6pycryptodome-3.21.0.tar.gz"
    sha256 "f7787e0d469bdae763b876174cf2e6c0f7be79808af26b1da96f1a64bcf47297"
  end

  resource "pyunormalize" do
    url "https:files.pythonhosted.orgpackagesb308568036c725dac746ecb267bb749ef930fb7907454fe69fce83c8557287fbpyunormalize-16.0.0.tar.gz"
    sha256 "2e1dfbb4a118154ae26f70710426a52a364b926c9191f764601f5a8cb12761f7"
  end

  resource "referencing" do
    url "https:files.pythonhosted.orgpackages995b73ca1f8e72fff6fa52119dbd185f73a907b1989428917b24cff660129b6dreferencing-0.35.1.tar.gz"
    sha256 "25b42124a6c8b632a425174f24087783efb348a6f1e0008e63cd4466fedf703c"
  end

  resource "regex" do
    url "https:files.pythonhosted.orgpackages8e5fbd69653fbfb76cf8604468d3b4ec4c403197144c7bfe0e6a5fc9e02a07cbregex-2024.11.6.tar.gz"
    sha256 "7ab159b063c52a0333c884e4679f8d7a85112ee3078fe3d9004b2dd875585519"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "rlp" do
    url "https:files.pythonhosted.orgpackages0f49bcd4d3f9210ed78749eab04d236eeb98f98fbcc16977f308ee4637c1bad8rlp-4.0.1.tar.gz"
    sha256 "bcefb11013dfadf8902642337923bd0c786dc8a27cb4c21da6e154e52869ecb1"
  end

  resource "rpds-py" do
    url "https:files.pythonhosted.orgpackages2380afdf96daf9b27d61483ef05b38f282121db0e38f5fd4e89f40f5c86c2a4frpds_py-0.21.0.tar.gz"
    sha256 "ed6378c9d66d0de903763e7706383d60c33829581f0adff47b6535f1802fa6db"
  end

  resource "solc-select" do
    url "https:files.pythonhosted.orgpackages60a02a2bfbbab1d9bd4e1a24e3604c30b5d6f84219238f3c98f06191faf5d019solc-select-1.0.4.tar.gz"
    sha256 "db7b9de009af6de3a5416b80bbe5b6d636bf314703c016319b8c1231e248a6c7"
  end

  resource "toolz" do
    url "https:files.pythonhosted.orgpackages8a0bd80dfa675bf592f636d1ea0b835eab4ec8df6e9415d8cfd766df54456123toolz-1.0.0.tar.gz"
    sha256 "2c86e3d9a04798ac556793bced838816296a2f085017664e4995cb40a1047a02"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesdfdbf35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesed6322ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages6c6353559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  resource "web3" do
    url "https:files.pythonhosted.orgpackagesf99f2e084219b4b461111b73a7b8d77da70a2698f41b1bb015aeb933f25c8452web3-6.20.3.tar.gz"
    sha256 "c69dbf1a61ace172741d06990e60afc7f55f303eac087e7235f382df3047d017"
  end

  resource "websockets" do
    url "https:files.pythonhosted.orgpackagesf41b380b883ce05bb5f45a905b61790319a28958a9ab1e4b6b95ff5464b60ca1websockets-14.1.tar.gz"
    sha256 "398b10c77d471c0aab20a845e7a60076b6390bfdaac7a6d2edb0d2c59d75e8d8"
  end

  resource "yarl" do
    url "https:files.pythonhosted.orgpackages4bd50d0481857de42a44ba4911f8010d4b361dc26487f48d5503c66a797cff48yarl-1.17.2.tar.gz"
    sha256 "753eaaa0c7195244c84b5cc159dc8204b7fd99f716f11198f999f2332a86b178"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    resource "testdata" do
      url "https:github.comcryticslitherrawd0a4f5595d7177b3b7d4bd35e1384bf35ebc22d4testsast-parsingcompilevariable-0.8.0.sol-0.8.15-compact.zip", using: :nounzip
      sha256 "2f165f629882d0250d03a56cb67a84e9741375349195915a04385b0666394478"
    end

    resource("testdata").stage do
      # slither exits with code 255 if high severity findings are found
      assert_match("5 result(s) found",
                   shell_output("#{bin}slither --detect uninitialized-state --fail-high " \
                                "variable-0.8.0.sol-0.8.15-compact.zip 2>&1", 255))
    end
  end
end