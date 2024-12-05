class Dolphie < Formula
  include Language::Python::Virtualenv

  desc "Feature-rich top tool for monitoring MySQL"
  homepage "https:github.comcharles-001dolphie"
  url "https:files.pythonhosted.orgpackagesd12b264c7e000cfaa75f2209a1d397c1213b5fff8e8f2aec5256d0733e4e827cdolphie-6.6.3.tar.gz"
  sha256 "1b1b5a96cedc452f5156b37b89fc5aad8af0552c8f6b392086c257ed65d5d8a4"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "750399e6cb78ff483d484fef15bc90407bd5d5c338a81e31bcea518012dde651"
    sha256 cellar: :any,                 arm64_sonoma:  "00ee223990acbb3d0b0d07f8b7c6dd19e561e6db37ea1e22327ef9bbc85d66c3"
    sha256 cellar: :any,                 arm64_ventura: "3fc9b28fe5a0e9994bc52acfad3701302e19c02575021ac3c120ef1cb0de11cd"
    sha256 cellar: :any,                 sonoma:        "a2312a45462f5cd656386693b6ad790638edb98fece8e2ec59a047eae89b44d6"
    sha256 cellar: :any,                 ventura:       "553160f9ad229022c5cade9f230aaf1294608a6104c3d9d48daadc88453ccf45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a2b281470889927a1444c9502ae6c3000e17a224cab9564b6c4a8c4b6e887b8"
  end

  depends_on "rust" => :build # for orjson
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.13"

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagesf24fe1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1echarset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
  end

  resource "cython" do
    url "https:files.pythonhosted.orgpackages844db720d6000f4ca77f030bd70f12550820f0766b568e43f11af7f7ad9061aacython-3.0.11.tar.gz"
    sha256 "7146dd2af8682b4ca61331851e6aebce9fe5158e75300343f80c07ca80b1faff"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "linkify-it-py" do
    url "https:files.pythonhosted.orgpackages2aaebb56c6828e4797ba5a4821eec7c43b8bf40f69cda4d4f5f8c8a2810ec96alinkify-it-py-2.0.3.tar.gz"
    sha256 "68cda27e162e9215c17d786649d1da0021a451bdc436ef9e0fa0ba5234b9b048"
  end

  resource "loguru" do
    url "https:files.pythonhosted.orgpackages9e30d87a423766b24db416a46e9335b9602b054a72b96a88a241f2b09b560fa8loguru-0.7.2.tar.gz"
    sha256 "e671a53522515f34fd406340ee968cb9ecafbc4b36c679da03c18fd8d0bd51ac"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdit-py-plugins" do
    url "https:files.pythonhosted.orgpackages1903a2ecab526543b152300717cf232bb4bb8605b6edb946c845016fa9c9c9fdmdit_py_plugins-0.4.2.tar.gz"
    sha256 "5f2cd1fdb606ddf152d37ec30e46101a60512bc0e5fa1a7002c36647b09e26b5"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "myloginpath" do
    url "https:files.pythonhosted.orgpackages21309acf030d204770c1134e130e8eb1293ce5ecd6a72046aaca68fbd76ead00myloginpath-0.0.4.tar.gz"
    sha256 "c44b8d11e8f35a02eeac4b88bf244203c09cc496bfa19ce99a79561c038f9d09"
  end

  resource "orjson" do
    url "https:files.pythonhosted.orgpackagese004bb9f72987e7f62fb591d6c880c0caaa16238e4e530cbc3bdc84a7372d75forjson-3.10.12.tar.gz"
    sha256 "0a78bbda3aea0f9f079057ee1ee8a1ecf790d4f1af88dd67493c6b8ee52506ff"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesd06368dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106dapackaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackages13fc128cc9cb8f03208bdbf93d3aa862e16d376844a14f9a0ce5cf4507372de4platformdirs-4.3.6.tar.gz"
    sha256 "357fb2acbc885b0419afd3ce3ed34564c13c9b95c89360cd9563f73aa5e2b907"
  end

  resource "plotext" do
    url "https:files.pythonhosted.orgpackagesc9d7f75f397af966fe252d0d34ffd3cae765317fce2134f925f95e7d6725d1ceplotext-5.3.2.tar.gz"
    sha256 "52d1e932e67c177bf357a3f0fe6ce14d1a96f7f7d5679d7b455b929df517068e"
  end

  resource "psutil" do
    url "https:files.pythonhosted.orgpackages26102a30b13c61e7cf937f4adf90710776b7918ed0a9c434e2c38224732af310psutil-6.1.0.tar.gz"
    sha256 "353815f59a7f64cdaca1c0307ee13558a0512f6db064e92fe833784f08539c7a"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages8e628336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "pymysql" do
    url "https:files.pythonhosted.orgpackagesb38fce59b5e5ed4ce8512f879ff1fa5ab699d211ae2495f1adaa5fbba2a1eadapymysql-1.1.1.tar.gz"
    sha256 "e127611aaf2b417403c60bf4dc570124aeb4a57f5f37b8e95ae399a42f904cd0"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesab3a0316b28d0761c6734d6bc14e770d85506c986c85ffb239e688eeaab2c2bcrich-13.9.4.tar.gz"
    sha256 "439594978a49a09530cff7ebc4b5c7103ef57baf48d5ea3184f21d9a2befa098"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackagesc8db722a42ffdc226e950c4757b3da7b56ff5c090bb265dccd707f7b8a3c6feesetuptools-75.5.0.tar.gz"
    sha256 "5c4ccb41111392671f02bb5f8436dfc5a9a7185e80500531b133f5775c4163ef"
  end

  resource "sqlparse" do
    url "https:files.pythonhosted.orgpackages651610f170ec641ed852611b6c9441b23d10b5702ab5288371feab3d36de2574sqlparse-0.4.4.tar.gz"
    sha256 "d446183e84b8349fa3061f0fe7f06ca94ba65b426946ffebe6e3e8295332420c"
  end

  resource "textual" do
    url "https:files.pythonhosted.orgpackagesa4e876b3aa49dd2f83410ab78b5ab04d65fee095e4720d2811f9ef72f073d11ftextual-0.88.1.tar.gz"
    sha256 "9c56d953dc7d1a8ddf06acc910d9224027e02416551f92920e70f435bd28e062"
  end

  resource "textual-autocomplete" do
    url "https:files.pythonhosted.orgpackagesbdd37837e2ee1807c72e2a8a185c6e5e729dbe68161d8476055d989f3a2db348textual_autocomplete-3.0.0a13.tar.gz"
    sha256 "db5a4ae956dd7d6dece53f7f695e97f2ab75819dd96b8a1c064ec5966b3ab113"
  end

  resource "tree-sitter" do
    url "https:files.pythonhosted.orgpackages0f50fd5fafa42b884f741b28d9e6fd366c3f34e15d2ed3aa9633b34e388379e2tree-sitter-0.23.2.tar.gz"
    sha256 "66bae8dd47f1fed7bdef816115146d3a41c39b5c482d7bad36d9ba1def088450"
  end

  # sdist issue report, https:github.comgrantjenkspy-tree-sitter-languagesissues63
  resource "tree-sitter-languages" do
    url "https:github.comgrantjenkspy-tree-sitter-languagesarchiverefstagsv1.10.2.tar.gz"
    sha256 "cdd03196ebaf8f486db004acd07a5b39679562894b47af6b20d28e4aed1a6ab5"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesdfdbf35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "uc-micro-py" do
    url "https:files.pythonhosted.orgpackages917a146a99696aee0609e3712f2b44c6274566bc368dfe8375191278045186b8uc-micro-py-1.0.3.tar.gz"
    sha256 "d321b92cff673ec58027c04015fcaa8bb1e005478643ff4a500882eaab88c48a"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesed6322ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  resource "zstandard" do
    url "https:files.pythonhosted.orgpackagesedf62ac0287b442160a89d726b17a9184a4c615bb5237db763791a7fd16d9df1zstandard-0.23.0.tar.gz"
    sha256 "b2d8c62d08e7255f68f7a740bae85b3c9b8e5466baa9cbf7f57f1cde0ac6bc09"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # Fails in Linux CI with "ParseError: end of file reached"
    # See https:github.comHomebrewhomebrew-corepull152912#issuecomment-1787257320
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    output = shell_output("#{bin}dolphie mysql:user:password@host:port 2>&1")
    assert_match "Invalid URI: Port could not be cast to integer value as 'port'", output

    assert_match version.to_s, shell_output("#{bin}dolphie --version")
  end
end