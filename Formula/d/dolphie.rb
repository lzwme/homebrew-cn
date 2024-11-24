class Dolphie < Formula
  include Language::Python::Virtualenv

  desc "Feature-rich top tool for monitoring MySQL"
  homepage "https:github.comcharles-001dolphie"
  url "https:files.pythonhosted.orgpackages35b183adb86de8f74bcd4ae664a503613242157c38f6e8df11a32a0e465b73a9dolphie-6.5.4.tar.gz"
  sha256 "776e8ceeb8c4b2a4b70b3e9037d46512052f5da5073c27add14f53732bc8d28a"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8f830e6d2f7031b2a0f0c9eecc98e76b36440fd7a54ceefcfa65b2170a5653fd"
    sha256 cellar: :any,                 arm64_sonoma:  "469a54ee25c4205df7c129209577e512013c9d595c17ce0f21027f9902a23506"
    sha256 cellar: :any,                 arm64_ventura: "44416e8237f80e8b96c07e1cd99bb360e0f6ad40167f862aa196c3d793d77799"
    sha256 cellar: :any,                 sonoma:        "2105bdbbd57baa4c64b9d61a2982cbae63404ccb748b734d386bb9c70fc486c8"
    sha256 cellar: :any,                 ventura:       "ebbcbe4fac42d96faf4720bd96a6c657f27c53bfa63d8a161c585cd41df26646"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3bcd90912c161916b4235d3b513f9800558466b643e642c92cfea1d9273e4b79"
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
    url "https:files.pythonhosted.orgpackages8044d36e86b33fc84f224b5f2cdf525adf3b8f9f475753e721c402b1ddef731eorjson-3.10.10.tar.gz"
    sha256 "37949383c4df7b4337ce82ee35b6d7471e55195efa7dcb45ab8226ceadb0fe3b"
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
    url "https:files.pythonhosted.orgpackagesd686525031f6bbfa4671fa66a4a5c088c3e9aa53f32d1b51a9bf2b900b3b1f32textual-0.84.0.tar.gz"
    sha256 "fb89717960fea7a539823fa264252f7be1c84844e4b8d27360e6d4edb36846a8"
  end

  resource "textual-autocomplete" do
    url "https:files.pythonhosted.orgpackages49e65a743d325e871f813a23377bf776b96a540705aa83b5e9afc5580b28e67etextual_autocomplete-3.0.0a12.tar.gz"
    sha256 "1d2c9e4d24c7f575abc8c612cb6abfff4706f6aaab9b939506b95dae84549309"
  end

  resource "tree-sitter" do
    url "https:files.pythonhosted.orgpackages0123e001538062ece748d7ab1fcfbcd9fa766d85f60f0d5ae014a7caf4f07c70tree-sitter-0.23.1.tar.gz"
    sha256 "28fe02aff6676b203cbe4213ca7116db0aaac08d6ca4c0b1f1af038991631838"
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