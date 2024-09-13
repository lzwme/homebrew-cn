class Dolphie < Formula
  include Language::Python::Virtualenv

  desc "Feature-rich top tool for monitoring MySQL"
  homepage "https:github.comcharles-001dolphie"
  url "https:files.pythonhosted.orgpackages7cae724873b2d46539f1ad320510c4ee66e2be5dcad4a5cc4ff3470e23d69f5ddolphie-6.0.4.tar.gz"
  sha256 "7e5bacb91a6b593f8a056eef5fddf1b50c733ede7aa058d694ed40262685981d"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "a3db63bce0efa1bdbbe7035e33ace3b816b0417b3ea7297a1062fa59e977f5ce"
    sha256 cellar: :any,                 arm64_sonoma:   "8ccf15387697da951fb7a90f26c1f141b4e387abfb6fd2df1e4f33c42cded8e9"
    sha256 cellar: :any,                 arm64_ventura:  "306660fb48fdaf88f1ba69ff81b5b03dd8deb4e63a76f93207edd17c522428d8"
    sha256 cellar: :any,                 arm64_monterey: "1dde854dbb0dd8f5a8db358a5912497915d98e5674588b68934ad954bc978cf7"
    sha256 cellar: :any,                 sonoma:         "a12572dbc694d51206a40d986ef473fd5b5ead5d80bc4e2c1d299d751135faf6"
    sha256 cellar: :any,                 ventura:        "246efe29b3e981919c07aaf40a7b604406181042be180378c723be5dfb387577"
    sha256 cellar: :any,                 monterey:       "fd185da8d9849cfb1e684c539f2e1ea78cd1a4fadb54c0f68dd665cfa013510a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f569cdb7daf822aa565a89e2e86cac605f13cbc999d5692bade364bf40f05e9a"
  end

  depends_on "rust" => :build # for orjson
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "cython" do
    url "https:files.pythonhosted.orgpackages844db720d6000f4ca77f030bd70f12550820f0766b568e43f11af7f7ad9061aacython-3.0.11.tar.gz"
    sha256 "7146dd2af8682b4ca61331851e6aebce9fe5158e75300343f80c07ca80b1faff"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagese8ace349c5e6d4543326c6883ee9491e3921e0d07b55fdf3cce184b40d63e72aidna-3.8.tar.gz"
    sha256 "d838c2c0ed6fced7693d5e8ab8e734d5f8fda53a039c0164afb0b82e771e3603"
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
    url "https:files.pythonhosted.orgpackages006c79c52651b22b64dba5c7bbabd7a294cc410bfb2353250dc8ade44d7d8ad8mdit_py_plugins-0.4.1.tar.gz"
    sha256 "834b8ac23d1cd60cec703646ffd22ae97b7955a6d596eb1d304be1e251ae499c"
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
    url "https:files.pythonhosted.orgpackages9e03821c8197d0515e46ea19439f5c5d5fd9a9889f76800613cfac947b5d7845orjson-3.10.7.tar.gz"
    sha256 "75ef0640403f945f3a1f9f6400686560dbfb0fb5b16589ad62cd477043c4eee3"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackages516550db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "plotext" do
    url "https:files.pythonhosted.orgpackages27d758f5ec766e41f8338f04ec47dbd3465db04fbe2a6107bca5f0670ced253aplotext-5.2.8.tar.gz"
    sha256 "319a287baabeb8576a711995f973a2eba631c887aa6b0f33ab016f12c50ffebe"
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
    url "https:files.pythonhosted.orgpackagescf605959113cae0ce512cf246a6871c623117330105a0d5f59b4e26138f2c9ccrich-13.8.0.tar.gz"
    sha256 "a5ac1f1cd448ade0d59cc3356f7db7a7ccda2c8cbae9c7a90c28ff463d3e91f4"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages8d37f4d4ce9bc15e61edba3179f9b0f763fc6d439474d28511b11f0d95bab7a2setuptools-73.0.1.tar.gz"
    sha256 "d59a3e788ab7e012ab2c4baed1b376da6366883ee20d7a5fc426816e3d7b1193"
  end

  resource "sqlparse" do
    url "https:files.pythonhosted.orgpackages7382dfa23ec2cbed08a801deab02fe7c904bfb00765256b155941d789a338c68sqlparse-0.5.1.tar.gz"
    sha256 "bb6b4df465655ef332548e24f08e205afc81b9ab86cb1c45657a7ff173a3a00e"
  end

  resource "textual" do
    url "https:files.pythonhosted.orgpackagesf71f90af350202a1f5d24f32184551ae7c41a7719255aaae4fe3d122be429bdftextual-0.77.0.tar.gz"
    sha256 "866c1e18e87b2817ce08e09259224b771caaf8824988c4c717094c6bf106b20f"
  end

  resource "textual-autocomplete" do
    url "https:files.pythonhosted.orgpackagesc34f6c5917fdf9bfa0c18dfd3828ac70df6b5ddee9dd3b403d774447e1c0fec5textual_autocomplete-2.1.0b0.tar.gz"
    sha256 "ba31da6e9b77e4c35323c267f958f0b90e1c2ddeca9c825c7d6c29d4d33893ce"
  end

  resource "tree-sitter" do
    url "https:files.pythonhosted.orgpackages4a6471b3a0ff7d0d89cb333caeca01992099c165bdd663e7990ea723615e60f4tree_sitter-0.20.4.tar.gz"
    sha256 "6adb123e2f3e56399bbf2359924633c882cc40ee8344885200bca0922f713be5"
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
    url "https:files.pythonhosted.orgpackages436dfa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
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