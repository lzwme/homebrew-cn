class SlitherAnalyzer < Formula
  include Language::Python::Virtualenv

  desc "Solidity static analysis framework written in Python 3"
  homepage "https:github.comcryticslither"
  url "https:files.pythonhosted.orgpackagesf9d7327729240d0ab0291cf3e9b36f05e135676ffea796e4a74ec6b7ef7ad2ddslither_analyzer-0.11.3.tar.gz"
  sha256 "09953ddb89d9ab182aa5826bda6fa3da482c82b5ffa371e34b35ba766044616e"
  license "AGPL-3.0-only"
  revision 1
  head "https:github.comcryticslither.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ee9382ada729a8d7d2d1786c60147b11ca685d7075dabbd4c5626a2f2e1cfe58"
    sha256 cellar: :any,                 arm64_sonoma:  "1bf2461cb516386b97e246bf94e0c9299d9251a6e034e2446615c805babba946"
    sha256 cellar: :any,                 arm64_ventura: "04bd39d51cc46f7e47a66828274afe00c735d049bf37f360d46cb9a8d50b99e3"
    sha256 cellar: :any,                 sonoma:        "97b945b157dd6a37961820bc278bc36697db48e3d28ac50284095c41c4149ae6"
    sha256 cellar: :any,                 ventura:       "d83c951f5968f42c06021a77c98b3aa62dc5c24d14ed70cceb46c440cf018b37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79a4fb3e9bdfd48357b4d626fddeabff3c4046488a317b0e325cbc7568164bdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "889efa3d882133a296d3c39a740a32c8a826bb506b7b7ac7b68a2a5d5165054a"
  end

  depends_on "rust" => :build # for rpds-py
  depends_on "certifi"
  depends_on "python@3.13"

  resource "aiohappyeyeballs" do
    url "https:files.pythonhosted.orgpackages2630f84a107a9c4331c14b2b586036f40965c128aa4fee4dda5d3d51cb14ad54aiohappyeyeballs-2.6.1.tar.gz"
    sha256 "c3f9d0113123803ccadfdf3f0faa505bc78e6a72d1cc4806cbd719826e943558"
  end

  resource "aiohttp" do
    url "https:files.pythonhosted.orgpackagesf284ea27e6ad14747d8c51afe201fb88a5c8282b6278256d30a6f71f730add88aiohttp-3.12.12.tar.gz"
    sha256 "05875595d2483d96cb61fa9f64e75262d7ac6251a7e3c811d8e26f7d721760bd"
  end

  resource "aiosignal" do
    url "https:files.pythonhosted.orgpackagesbab56d55e80f6d8a08ce22b982eafa278d823b541c925f11ee774b0b9c43473daiosignal-1.3.2.tar.gz"
    sha256 "a8c255c66fafb1e499c9351d0bf32ff2d8a0321595ebac3b93713656d2436f54"
  end

  resource "annotated-types" do
    url "https:files.pythonhosted.orgpackagesee67531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackages5ab01367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "bitarray" do
    url "https:files.pythonhosted.orgpackagesb80d15826c7c2d49a4518a1b24b0d432f1ecad2e0b68168f942058b5de498498bitarray-3.4.2.tar.gz"
    sha256 "78ed2b911aabede3a31e3329b1de8abdc8104bd5e0545184ddbd9c7f668f4059"
  end

  resource "cbor2" do
    url "https:files.pythonhosted.orgpackagese4aaba55b47d51d27911981a18743b4d3cebfabccbb0598c09801b734cec4184cbor2-5.6.5.tar.gz"
    sha256 "b682820677ee1dbba45f7da11898d2720f92e06be36acec290867d5ebf3d7e09"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagese43389c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12dcharset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "ckzg" do
    url "https:files.pythonhosted.orgpackages55dff6db8e83bd4594c1ea685cd37fb81d5399e55765aae16d1a8a9502598f4eckzg-2.1.1.tar.gz"
    sha256 "d6b306b7ec93a24e4346aa53d07f7f75053bc0afc7398e35fa649e5f9d48fcc4"
  end

  resource "crytic-compile" do
    url "https:files.pythonhosted.orgpackages789b6834afa2cc6fb3d958027e4c9c24c09735f9c6caeef4e205c22838f772bfcrytic_compile-0.3.10.tar.gz"
    sha256 "0d7e03b4109709dd175a4550345369548f99fc1c96183c34ccc4dd21a7c41601"
  end

  resource "cytoolz" do
    url "https:files.pythonhosted.orgpackagesa7f93243eed3a6545c2a33a21f74f655e3fcb5d2192613cd3db81a93369eb339cytoolz-1.0.1.tar.gz"
    sha256 "89cc3161b89e1bb3ed7636f74ed2e55984fd35516904fc878cae216e42b2c7d6"
  end

  resource "eth-abi" do
    url "https:files.pythonhosted.orgpackages0071d9e1380bd77fd22f98b534699af564f189b56d539cc2b9dab908d4e4c242eth_abi-5.2.0.tar.gz"
    sha256 "178703fa98c07d8eecd5ae569e7e8d159e493ebb6eeb534a8fe973fbc4e40ef0"
  end

  resource "eth-account" do
    url "https:files.pythonhosted.orgpackages74cf20f76a29be97339c969fd765f1237154286a565a1d61be98e76bb7af946aeth_account-0.13.7.tar.gz"
    sha256 "5853ecbcbb22e65411176f121f5f24b8afeeaf13492359d254b16d8b18c77a46"
  end

  resource "eth-hash" do
    url "https:files.pythonhosted.orgpackagesee38577b7bc9380ef9dff0f1dffefe0c9a1ded2385e7a06c306fd95afb6f9451eth_hash-0.7.1.tar.gz"
    sha256 "d2411a403a0b0a62e8247b4117932d900ffb4c8c64b15f92620547ca5ce46be5"
  end

  resource "eth-keyfile" do
    url "https:files.pythonhosted.orgpackages3566dd823b1537befefbbff602e2ada88f1477c5b40ec3731e3d9bc676c5f716eth_keyfile-0.8.1.tar.gz"
    sha256 "9708bc31f386b52cca0969238ff35b1ac72bd7a7186f2a84b86110d3c973bec1"
  end

  resource "eth-keys" do
    url "https:files.pythonhosted.orgpackages58111ed831c50bd74f57829aa06e58bd82a809c37e070ee501c953b9ac1f1552eth_keys-0.7.0.tar.gz"
    sha256 "79d24fd876201df67741de3e3fefb3f4dbcbb6ace66e47e6fe662851a4547814"
  end

  resource "eth-rlp" do
    url "https:files.pythonhosted.orgpackages7feaad39d001fa9fed07fad66edb00af701e29b48be0ed44a3bcf58cb3adf130eth_rlp-2.2.0.tar.gz"
    sha256 "5e4b2eb1b8213e303d6a232dfe35ab8c29e2d3051b86e8d359def80cd21db83d"
  end

  resource "eth-typing" do
    url "https:files.pythonhosted.orgpackages605462aa24b9cc708f06316167ee71c362779c8ed21fc8234a5cd94a8f53b623eth_typing-5.2.1.tar.gz"
    sha256 "7557300dbf02a93c70fa44af352b5c4a58f94e997a0fd6797fb7d1c29d9538ee"
  end

  resource "eth-utils" do
    url "https:files.pythonhosted.orgpackages0d49bee95f16d2ef068097afeeffbd6c67738107001ee57ad7bcdd4fc4d3c6a7eth_utils-5.3.0.tar.gz"
    sha256 "1f096867ac6be895f456fa3acb26e9573ae66e753abad9208f316d24d6178156"
  end

  resource "frozenlist" do
    url "https:files.pythonhosted.orgpackages79b1b64018016eeb087db503b038296fd782586432b9c077fc5c7839e9cb6ef6frozenlist-1.7.0.tar.gz"
    sha256 "2e310d81923c2437ea8670467121cc3e9b0f76d3043cc1d2331d56c7fb7a3a8f"
  end

  resource "hexbytes" do
    url "https:files.pythonhosted.orgpackages7f87adf4635b4b8c050283d74e6db9a81496063229c9263e6acc1903ab79fbechexbytes-1.3.1.tar.gz"
    sha256 "a657eebebdfe27254336f98d8af6e2236f3f83aed164b87466b6cf6c5f5a4765"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "multidict" do
    url "https:files.pythonhosted.orgpackages912fa3470242707058fe856fe59241eee5635d79087100b7042a867368863a27multidict-6.4.4.tar.gz"
    sha256 "69ee9e6ba214b5245031b76233dd95408a0fd57fdb019ddcc1ead4790932a8e8"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesa1d41fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24dpackaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "parsimonious" do
    url "https:files.pythonhosted.orgpackages7b91abdc50c4ef06fdf8d047f60ee777ca9b2a7885e1a9cea81343fbecda52d7parsimonious-0.10.0.tar.gz"
    sha256 "8281600da180ec8ae35427a4ab4f7b82bfec1e3d1e52f80cb60ea82b9512501c"
  end

  resource "prettytable" do
    url "https:files.pythonhosted.orgpackages99b185e18ac92afd08c533603e3393977b6bc1443043115a47bb094f3b98f94fprettytable-3.16.0.tar.gz"
    sha256 "3c64b31719d961bf69c9a7e03d0c1e477320906a98da63952bc6698d6164ff57"
  end

  resource "propcache" do
    url "https:files.pythonhosted.orgpackagesa61643264e4a779dd8588c21a70f0709665ee8f611211bdd2c87d952cfa7c776propcache-0.3.2.tar.gz"
    sha256 "20d7d62e4e7ef05f221e0db2856b979540686342e7dd9973b815599c7057e168"
  end

  resource "pycryptodome" do
    url "https:files.pythonhosted.orgpackages8ea68452177684d5e906854776276ddd34eca30d1b1e15aa1ee9cefc289a33f5pycryptodome-3.23.0.tar.gz"
    sha256 "447700a657182d60338bab09fdb27518f8856aecd80ae4c6bdddb67ff5da44ef"
  end

  resource "pydantic" do
    url "https:files.pythonhosted.orgpackagesf0868ce9040065e8f924d642c58e4a344e33163a07f6b57f836d0d734e0ad3fbpydantic-2.11.5.tar.gz"
    sha256 "7f853db3d0ce78ce8bbb148c401c2cdd6431b3473c0cdff2755c7690952a7b7a"
  end

  resource "pydantic-core" do
    url "https:files.pythonhosted.orgpackagesad885f2260bdfae97aabf98f1778d43f69574390ad787afb646292a638c923d4pydantic_core-2.33.2.tar.gz"
    sha256 "7cb8bc3605c29176e1b105350d2e6474142d7c1bd1d9327c4a9bdb46bf827acc"
  end

  resource "pyunormalize" do
    url "https:files.pythonhosted.orgpackagesb308568036c725dac746ecb267bb749ef930fb7907454fe69fce83c8557287fbpyunormalize-16.0.0.tar.gz"
    sha256 "2e1dfbb4a118154ae26f70710426a52a364b926c9191f764601f5a8cb12761f7"
  end

  resource "regex" do
    url "https:files.pythonhosted.orgpackages8e5fbd69653fbfb76cf8604468d3b4ec4c403197144c7bfe0e6a5fc9e02a07cbregex-2024.11.6.tar.gz"
    sha256 "7ab159b063c52a0333c884e4679f8d7a85112ee3078fe3d9004b2dd875585519"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackagese10a929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "rlp" do
    url "https:files.pythonhosted.orgpackages1b2d439b0728a92964a04d9c88ea1ca9ebb128893fbbd5834faa31f987f2fd4crlp-4.1.0.tar.gz"
    sha256 "be07564270a96f3e225e2c107db263de96b5bc1f27722d2855bd3459a08e95a9"
  end

  resource "solc-select" do
    url "https:files.pythonhosted.orgpackagese05555b19b5f6625e7f1a8398e9f19e61843e4c651164cac10673edd412c0678solc_select-1.1.0.tar.gz"
    sha256 "94fb6f976ab50ffccc5757d5beaf76417b27cbe15436cfe2b30cdb838f5c7516"
  end

  resource "toolz" do
    url "https:files.pythonhosted.orgpackages8a0bd80dfa675bf592f636d1ea0b835eab4ec8df6e9415d8cfd766df54456123toolz-1.0.0.tar.gz"
    sha256 "2c86e3d9a04798ac556793bced838816296a2f085017664e4995cb40a1047a02"
  end

  resource "types-requests" do
    url "https:files.pythonhosted.orgpackages6d7f73b3a04a53b0fd2a911d4ec517940ecd6600630b559e4505cc7b68beb5a0types_requests-2.32.4.20250611.tar.gz"
    sha256 "741c8777ed6425830bf51e54d6abe245f79b4dcb9019f1622b773463946bf826"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesd1bc51647cd02527e87d05cb083ccc402f93e441606ff1f01739a62c8ad09ba5typing_extensions-4.14.0.tar.gz"
    sha256 "8676b788e32f02ab42d9e7c61324048ae4c6d844a399eebace3d4979d75ceef4"
  end

  resource "typing-inspection" do
    url "https:files.pythonhosted.orgpackagesf8b10c11f5058406b3af7609f121aaa6b609744687f1d158b3c3a5bf4cc94238typing_inspection-0.4.1.tar.gz"
    sha256 "6ae134cc0203c33377d43188d4064e9b357dba58cff3185f22924610e70a9d28"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages8a7816493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages6c6353559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  resource "web3" do
    url "https:files.pythonhosted.orgpackages7d1efc1f5b5a12615cbdca57d35014cdb9823db7392d73b730fa0d89d6a13f6aweb3-7.12.0.tar.gz"
    sha256 "08fbe79a2e2503c9820132ebad24ba0372831588cabac5f467999c97ace7dda3"
  end

  resource "websockets" do
    url "https:files.pythonhosted.orgpackages21e626d09fab466b7ca9c7737474c52be4f76a40301b08362eb2dbc19dcc16c1websockets-15.0.1.tar.gz"
    sha256 "82544de02076bafba038ce055ee6412d68da13ab47f0c60cab827346de828dee"
  end

  resource "yarl" do
    url "https:files.pythonhosted.orgpackages3cfbefaa23fa4e45537b827620f04cf8f3cd658b76642205162e072703a5b963yarl-1.20.1.tar.gz"
    sha256 "d017a4997ee50c91fd5466cef416231bb82177b93b029906cefc542ce14c35ac"
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