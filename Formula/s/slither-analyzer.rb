class SlitherAnalyzer < Formula
  include Language::Python::Virtualenv

  desc "Solidity static analysis framework written in Python 3"
  homepage "https:github.comcryticslither"
  url "https:files.pythonhosted.orgpackagesee64ebefdb4d633754013cafe1e8c28c04722ff49d5bdd98b6393dcd50f35428slither_analyzer-0.10.4.tar.gz"
  sha256 "bb89945509c7c1d461db2af1bfd85a7a02878334050e23aefc88d65568783a32"
  license "AGPL-3.0-only"
  head "https:github.comcryticslither.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "61d4e27e407eaf6f9176a2786856f24e4abfbdd16ce29bbd6256feb6d9d20467"
    sha256 cellar: :any,                 arm64_sonoma:  "0f10c8048d8f79134cd5d3b8cf6e115255191f6c85f18a30fc42c3edfc1166bb"
    sha256 cellar: :any,                 arm64_ventura: "d36750f3b109e65ff9f01f68a229f09ab3abb0ff959369db6366726157b6882c"
    sha256 cellar: :any,                 sonoma:        "d3fe76132b838ab426bac50429df47da5e4ef9839819c58a115768f30dc623d6"
    sha256 cellar: :any,                 ventura:       "d5270fa96a0dc03e74c195924334c8be89fb03e1a8906fef4eb67a00bda7497f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39367a7f49b4556205d4de331bd5e46a3040e0490740b120c2324adc5cd69212"
  end

  depends_on "rust" => :build # for rpds-py
  depends_on "certifi"
  depends_on "python@3.13"

  resource "aiohappyeyeballs" do
    url "https:files.pythonhosted.orgpackagesbc692f6d5a019bd02e920a3417689a89887b39ad1e350b562f9955693d900c40aiohappyeyeballs-2.4.3.tar.gz"
    sha256 "75cf88a15106a5002a8eb1dab212525c00d1f4c0fa96e551c9fbe6f09a621586"
  end

  resource "aiohttp" do
    url "https:files.pythonhosted.orgpackages177e16e57e6cf20eb62481a2f9ce8674328407187950ccc602ad07c685279141aiohttp-3.10.10.tar.gz"
    sha256 "0631dd7c9f0822cc61c88586ca76d5b5ada26538097d0f1df510b082bad3411a"
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
    url "https:files.pythonhosted.orgpackages0dc7a85f206e6b2fddb93964efe53685ad8da7d856e6975b005ed6a88f25b010bitarray-2.9.3.tar.gz"
    sha256 "9eff55cf189b0c37ba97156a00d640eb7392db58a8049be6f26ff2712b93fa89"
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
    url "https:files.pythonhosted.orgpackages13bfddd817e8b455b577b206fbfee951df1f4964826e9d4f2fc3148550d592c4ckzg-1.0.2.tar.gz"
    sha256 "4295acc380f8d42ebea4a4a0a68c424a322bb335a33bad05c72ead8cbb28d118"
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
    url "https:files.pythonhosted.orgpackages1f89127b102953f30068d6868183055d321a428d517184788a0f03afc209af0deth_keys-0.5.1.tar.gz"
    sha256 "2b587e4bbb9ac2195215a7ab0c0fb16042b17d4ec50240ed670bbb8f53da7a48"
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
    url "https:files.pythonhosted.orgpackagescf3d2102257e7acad73efc4a0c306ad3953f68c504c16982bbdfee3ad75d8085frozenlist-1.4.1.tar.gz"
    sha256 "c037a86e8513059a2613aaba4d817bb90b9d9b6b69aace3ce9c877e8c8ed402b"
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
    url "https:files.pythonhosted.orgpackages516550db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "parsimonious" do
    url "https:files.pythonhosted.orgpackages7b91abdc50c4ef06fdf8d047f60ee777ca9b2a7885e1a9cea81343fbecda52d7parsimonious-0.10.0.tar.gz"
    sha256 "8281600da180ec8ae35427a4ab4f7b82bfec1e3d1e52f80cb60ea82b9512501c"
  end

  resource "prettytable" do
    url "https:files.pythonhosted.orgpackages28570a642bec16d5736b9baaac7e830bedccd10341dc2858075c34d5aec5c8b6prettytable-3.11.0.tar.gz"
    sha256 "7e23ca1e68bbfd06ba8de98bf553bf3493264c96d5e8a615c0471025deeba722"
  end

  resource "propcache" do
    url "https:files.pythonhosted.orgpackagesa94d5e5a60b78dbc1d464f8a7bbaeb30957257afdc8512cbb9dfd5659304f5cdpropcache-0.2.0.tar.gz"
    sha256 "df81779732feb9d01e5d513fad0122efb3d53bbc75f61b2a4f29a020bc985e70"
  end

  resource "protobuf" do
    url "https:files.pythonhosted.orgpackagesb1a44579a61de526e19005ceeb93e478b61d77aa38c8a85ad958ff16a9906549protobuf-5.28.2.tar.gz"
    sha256 "59379674ff119717404f7454647913787034f03fe7049cbef1d74a97bb4593f0"
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
    url "https:files.pythonhosted.orgpackagesf938148df33b4dbca3bd069b963acab5e0fa1a9dbd6820f8c322d0dd6faeff96regex-2024.9.11.tar.gz"
    sha256 "6c188c307e8433bcb63dc1915022deb553b4203a70722fc542c363bf120a01fd"
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
    url "https:files.pythonhosted.orgpackages5564b693f262791b818880d17268f3f8181ef799b0d187f6f731b1772e05a29arpds_py-0.20.0.tar.gz"
    sha256 "d72a210824facfdaf8768cf2d7ca25a042c30320b3020de2fa04640920d4e121"
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
    url "https:files.pythonhosted.orgpackagese2739223dbc7be3dcaf2a7bbf756c351ec8da04b1fa573edaf545b95f6b0c7fdwebsockets-13.1.tar.gz"
    sha256 "a3b3366087c1bc0a2795111edcadddb8b3b59509d5db5d7ea3fdd69f954a8878"
  end

  resource "yarl" do
    url "https:files.pythonhosted.orgpackages06e1d5427a061819c9f885f58bb0467d02a523f1aec19f9e5f9c82ce950d90d3yarl-1.15.2.tar.gz"
    sha256 "a39c36f4218a5bb668b4f06874d676d35a035ee668e6e7e3538835c703634b84"
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