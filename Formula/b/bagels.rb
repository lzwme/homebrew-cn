class Bagels < Formula
  include Language::Python::Virtualenv

  desc "Powerful expense tracker that lives in your terminal"
  homepage "https:github.comEnhancedJaxBagels"
  url "https:files.pythonhosted.orgpackages833a67fef626e22bce29970a5666702a7b2664541753abeaed653a0a694dd295bagels-0.3.9.tar.gz"
  sha256 "fbb3bb64d7f6909864004866b00e112917738a6fdf470871ea77b4e2f67d2d28"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2dc3a6c56b413a408467a7d53802b19bab97103b17942df37d1e68c6ec8d6a88"
    sha256 cellar: :any,                 arm64_sonoma:  "62fbf7c321f1d42c539aba88f1eb081e7a16dc42fc4861b098efaad9e1e83371"
    sha256 cellar: :any,                 arm64_ventura: "a1068402d8ff67ef499f5ddd76f3ef3c5708a4c8b915d0f97cca8cbd17071313"
    sha256 cellar: :any,                 sonoma:        "8dc4b9dbacafcdede200e697bc7db9ab05ab2cee133b886d33cc96334053b055"
    sha256 cellar: :any,                 ventura:       "c9fb3eaa056d2742589a69b6ec9b8a6e1e82b7d023e010e6147b3ecde390b1c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c0e6415c91a75a059762c4e000fe739d94731b05a72ee5d98b38864d7ec8629"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4165088e08bfbcf2d802987b65c5d3e2c5f5eab08086c8c8f94bc1ebf22f1acf"
  end

  depends_on "rust" => :build # for pydantic_core
  depends_on "libyaml"
  depends_on "numpy"
  depends_on "python@3.13"

  resource "aiohappyeyeballs" do
    url "https:files.pythonhosted.orgpackages2630f84a107a9c4331c14b2b586036f40965c128aa4fee4dda5d3d51cb14ad54aiohappyeyeballs-2.6.1.tar.gz"
    sha256 "c3f9d0113123803ccadfdf3f0faa505bc78e6a72d1cc4806cbd719826e943558"
  end

  resource "aiohttp" do
    url "https:files.pythonhosted.orgpackages426eab88e7cb2a4058bed2f7870276454f85a7c56cd6da79349eb314fc7bbcaaaiohttp-3.12.13.tar.gz"
    sha256 "47e2da578528264a12e4e3dd8dd72a7289e5f812758fe086473fab037a10fcce"
  end

  resource "aiohttp-jinja2" do
    url "https:files.pythonhosted.orgpackagese639da5a94dd89b1af7241fb7fc99ae4e73505b5f898b540b6aba6dc7afe600eaiohttp-jinja2-1.6.tar.gz"
    sha256 "a3a7ff5264e5bca52e8ae547bbfd0761b72495230d438d05b6c0915be619b0e2"
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
    url "https:files.pythonhosted.orgpackages48c86260f8ccc11f0917360fc0da435c5c9c7504e3db174d5a12a1494887b045attrs-24.3.0.tar.gz"
    sha256 "8f5c07333d543103541ba7be0e2ce16eeee8130cb0b3f9238ab904ce1e85baff"
  end

  resource "blinker" do
    url "https:files.pythonhosted.orgpackages21289b3f50ce0e048515135495f198351908d99540d69bfdc8c1d15b73dc55ceblinker-1.9.0.tar.gz"
    sha256 "b4ce2265a7abece45e7cc896e98dbebe6cead56bcf805a3d23136d145f5445bf"
  end

  resource "certifi" do
    url "https:files.pythonhosted.orgpackages73f7f14b46d4bcd21092d7d3ccef689615220d8a08fb25e564b65d20738e672ecertifi-2025.6.15.tar.gz"
    sha256 "d747aa5a8b9bbbb1bb8c22bb13e22bd1f18e9796defa16bab421f7f7a317323b"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagese43389c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12dcharset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages606c8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbcclick-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "click-default-group" do
    url "https:files.pythonhosted.orgpackages1dceedb087fb53de63dad3b36408ca30368f438738098e668b78c87f93cd41dfclick_default_group-1.2.4.tar.gz"
    sha256 "eb3f3c99ec0d456ca6cd2a7f08f7d4e91771bef51b01bdd9580cc6450fe1251e"
  end

  resource "frozenlist" do
    url "https:files.pythonhosted.orgpackages79b1b64018016eeb087db503b038296fd782586432b9c077fc5c7839e9cb6ef6frozenlist-1.7.0.tar.gz"
    sha256 "2e310d81923c2437ea8670467121cc3e9b0f76d3043cc1d2331d56c7fb7a3a8f"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "itsdangerous" do
    url "https:files.pythonhosted.orgpackages9ccb8ac0172223afbccb63986cc25049b154ecfb5e85932587206f42317be31ditsdangerous-2.2.0.tar.gz"
    sha256 "e0050c0b7da1eea53ffaf149c0cfbb5c6e2e2b69c4bef22c81fa6eb73e5f6173"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesdfbff7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226bjinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "linkify-it-py" do
    url "https:files.pythonhosted.orgpackages2aaebb56c6828e4797ba5a4821eec7c43b8bf40f69cda4d4f5f8c8a2810ec96alinkify-it-py-2.0.3.tar.gz"
    sha256 "68cda27e162e9215c17d786649d1da0021a451bdc436ef9e0fa0ba5234b9b048"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackagesb2975d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "mdit-py-plugins" do
    url "https:files.pythonhosted.orgpackages1903a2ecab526543b152300717cf232bb4bb8605b6edb946c845016fa9c9c9fdmdit_py_plugins-0.4.2.tar.gz"
    sha256 "5f2cd1fdb606ddf152d37ec30e46101a60512bc0e5fa1a7002c36647b09e26b5"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "msgpack" do
    url "https:files.pythonhosted.orgpackages45b1ea4f68038a18c77c9467400d166d74c4ffa536f34761f7983a104357e614msgpack-1.1.1.tar.gz"
    sha256 "77b79ce34a2bdab2594f490c8e80dd62a02d650b91a75159a63ec413b8d104cd"
  end

  resource "multidict" do
    url "https:files.pythonhosted.orgpackages46b559f27b4ce9951a4bce56b88ba5ff5159486797ab18863f2b4c1c5e8465bdmultidict-6.5.0.tar.gz"
    sha256 "942bd8002492ba819426a8d7aefde3189c1b87099cdf18aaaefefcf7f3f7b6d2"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesfb2b9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7bpackaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackagesfe8b3c73abc9c759ecd3f1f7ceff6685840859e8070c4d947c93fae71f6a0bf2platformdirs-4.3.8.tar.gz"
    sha256 "3d512d96e16bcb959a814c9f348431070822a6496326a4be0911c40b5a74c2bc"
  end

  resource "plotext" do
    url "https:files.pythonhosted.orgpackagesc9d7f75f397af966fe252d0d34ffd3cae765317fce2134f925f95e7d6725d1ceplotext-5.3.2.tar.gz"
    sha256 "52d1e932e67c177bf357a3f0fe6ce14d1a96f7f7d5679d7b455b929df517068e"
  end

  resource "propcache" do
    url "https:files.pythonhosted.orgpackagesa61643264e4a779dd8588c21a70f0709665ee8f611211bdd2c87d952cfa7c776propcache-0.3.2.tar.gz"
    sha256 "20d7d62e4e7ef05f221e0db2856b979540686342e7dd9973b815599c7057e168"
  end

  resource "pydantic" do
    url "https:files.pythonhosted.orgpackages00dd4325abf92c39ba8623b5af936ddb36ffcfe0beae70405d456ab1fb2f5b8cpydantic-2.11.7.tar.gz"
    sha256 "d989c3c6cb79469287b1569f7447a17848c998458d49ebe294e975b9baf0f0db"
  end

  resource "pydantic-core" do
    url "https:files.pythonhosted.orgpackagesad885f2260bdfae97aabf98f1778d43f69574390ad787afb646292a638c923d4pydantic_core-2.33.2.tar.gz"
    sha256 "7cb8bc3605c29176e1b105350d2e6474142d7c1bd1d9327c4a9bdb46bf827acc"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages7c2dc3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackagese10a929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesab3a0316b28d0761c6734d6bc14e770d85506c986c85ffb239e688eeaab2c2bcrich-13.9.4.tar.gz"
    sha256 "439594978a49a09530cff7ebc4b5c7103ef57baf48d5ea3184f21d9a2befa098"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages94e7b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sqlalchemy" do
    url "https:files.pythonhosted.orgpackages636645b165c595ec89aa7dcc2c1cd222ab269bc753f1fc7a1e68f8481bd957bfsqlalchemy-2.0.41.tar.gz"
    sha256 "edba70118c4be3c2b1f90754d308d0b79c6fe2c0fdc52d8ddf603916f83f4db9"
  end

  resource "textual" do
    url "https:files.pythonhosted.orgpackages1fb659b1de04bb4dca0f21ed7ba0b19309ed7f3f5de4396edf20cc2855e53085textual-1.0.0.tar.gz"
    sha256 "bec9fe63547c1c552569d1b75d309038b7d456c03f86dfa3706ddb099b151399"
  end

  resource "tomli" do
    url "https:files.pythonhosted.orgpackages1887302344fed471e44a87289cf4967697d07e532f2421fdaf868a303cbae4fftomli-2.2.1.tar.gz"
    sha256 "cd45e1dc79c835ce60f7404ec8119f2eb06d38b1deba146f07ced3bbc44505ff"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesd1bc51647cd02527e87d05cb083ccc402f93e441606ff1f01739a62c8ad09ba5typing_extensions-4.14.0.tar.gz"
    sha256 "8676b788e32f02ab42d9e7c61324048ae4c6d844a399eebace3d4979d75ceef4"
  end

  resource "typing-inspection" do
    url "https:files.pythonhosted.orgpackagesf8b10c11f5058406b3af7609f121aaa6b609744687f1d158b3c3a5bf4cc94238typing_inspection-0.4.1.tar.gz"
    sha256 "6ae134cc0203c33377d43188d4064e9b357dba58cff3185f22924610e70a9d28"
  end

  resource "uc-micro-py" do
    url "https:files.pythonhosted.orgpackages917a146a99696aee0609e3712f2b44c6274566bc368dfe8375191278045186b8uc-micro-py-1.0.3.tar.gz"
    sha256 "d321b92cff673ec58027c04015fcaa8bb1e005478643ff4a500882eaab88c48a"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages15229ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bcurllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "werkzeug" do
    url "https:files.pythonhosted.orgpackages9f6983029f1f6300c5fb2471d621ab06f6ec6b3324685a2ce0f9777fd4a8b71ewerkzeug-3.1.3.tar.gz"
    sha256 "60723ce945c19328679790e3282cc758aa4a6040e4bb330f53d30fa546d44746"
  end

  resource "xdg-base-dirs" do
    url "https:files.pythonhosted.orgpackagesbfd0bbe05a15347538aaf9fa5b51ac3b97075dfb834931fcb77d81fbdb69e8f6xdg_base_dirs-6.0.2.tar.gz"
    sha256 "950504e14d27cf3c9cb37744680a43bf0ac42efefc4ef4acf98dc736cab2bced"
  end

  resource "yarl" do
    url "https:files.pythonhosted.orgpackages3cfbefaa23fa4e45537b827620f04cf8f3cd658b76642205162e072703a5b963yarl-1.20.1.tar.gz"
    sha256 "d017a4997ee50c91fd5466cef416231bb82177b93b029906cefc542ce14c35ac"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}bagels locate config")
    assert_match "#{testpath}.configbagelsconfig.yaml", output
  end
end