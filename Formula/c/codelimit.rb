class Codelimit < Formula
  include Language::Python::Virtualenv

  desc "Your Refactoring Alarm"
  homepage "https:github.comgetcodelimitcodelimit"
  url "https:files.pythonhosted.orgpackagesb23588c6a31a680aaaa08906162e1a64187e8379c2f6fdf68a457d61e8a32ed1codelimit-0.18.1.tar.gz"
  sha256 "208e814cb3320ce5d1f862fc984b4e09760595b9ed6362bdc11214e3ee155549"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "51d2b36247f381cb3a00a1d32638b13e306b248a6faf2d23d57f73d4f1ac41ca"
    sha256 cellar: :any,                 arm64_sonoma:  "6f94801c8c0a62be52f69fb7ca4888e3a6544efdda27dc2adcf91c2416ae26da"
    sha256 cellar: :any,                 arm64_ventura: "429cb5137167ebbc8514f3b72e6f4c5fb31638f060beba15c190f7da709676e4"
    sha256 cellar: :any,                 sonoma:        "cd3f2af21686de51775d79de85b61d7853e4a32bf1ebecafe0af19b982402247"
    sha256 cellar: :any,                 ventura:       "8f6d581fe89d46a3128011793c045d2a886a1386e592911f26d3d728f8747786"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a999e3ad0fe82b29d24dd69135d7180c3d53b663df8cd0e9764155d77020820a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2009e7baacaf96f69ada640dc5bc66ea3cc8e150fb6d362c88de35148eef5fca"
  end

  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "aiohappyeyeballs" do
    url "https:files.pythonhosted.orgpackages2630f84a107a9c4331c14b2b586036f40965c128aa4fee4dda5d3d51cb14ad54aiohappyeyeballs-2.6.1.tar.gz"
    sha256 "c3f9d0113123803ccadfdf3f0faa505bc78e6a72d1cc4806cbd719826e943558"
  end

  resource "aiohttp" do
    url "https:files.pythonhosted.orgpackages426eab88e7cb2a4058bed2f7870276454f85a7c56cd6da79349eb314fc7bbcaaaiohttp-3.12.13.tar.gz"
    sha256 "47e2da578528264a12e4e3dd8dd72a7289e5f812758fe086473fab037a10fcce"
  end

  resource "aiosignal" do
    url "https:files.pythonhosted.orgpackagesbab56d55e80f6d8a08ce22b982eafa278d823b541c925f11ee774b0b9c43473daiosignal-1.3.2.tar.gz"
    sha256 "a8c255c66fafb1e499c9351d0bf32ff2d8a0321595ebac3b93713656d2436f54"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackages5ab01367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagese43389c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12dcharset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages606c8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbcclick-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "frozenlist" do
    url "https:files.pythonhosted.orgpackages79b1b64018016eeb087db503b038296fd782586432b9c077fc5c7839e9cb6ef6frozenlist-1.7.0.tar.gz"
    sha256 "2e310d81923c2437ea8670467121cc3e9b0f76d3043cc1d2331d56c7fb7a3a8f"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "multidict" do
    url "https:files.pythonhosted.orgpackages46b559f27b4ce9951a4bce56b88ba5ff5159486797ab18863f2b4c1c5e8465bdmultidict-6.5.0.tar.gz"
    sha256 "942bd8002492ba819426a8d7aefde3189c1b87099cdf18aaaefefcf7f3f7b6d2"
  end

  resource "pathspec" do
    url "https:files.pythonhosted.orgpackagescabcf35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbfpathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "propcache" do
    url "https:files.pythonhosted.orgpackagesa61643264e4a779dd8588c21a70f0709665ee8f611211bdd2c87d952cfa7c776propcache-0.3.2.tar.gz"
    sha256 "20d7d62e4e7ef05f221e0db2856b979540686342e7dd9973b815599c7057e168"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages7c2dc3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "pyperclip" do
    url "https:files.pythonhosted.orgpackages30232f0a3efc4d6a32f3b63cdff36cd398d9701d26cda58e3ab97ac79fb5e60dpyperclip-1.9.0.tar.gz"
    sha256 "b7de0142ddc81bfc5c7507eea19da920b92252b548b96186caf94a5e2527d310"
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

  resource "sh" do
    url "https:files.pythonhosted.orgpackages5952f43920223c93e31874677c681b8603d36a40d3d8502d3a37f80d3995d43esh-2.2.2.tar.gz"
    sha256 "653227a7c41a284ec5302173fbc044ee817c7bad5e6e4d8d55741b9aeb9eb65b"
  end

  resource "typer" do
    url "https:files.pythonhosted.orgpackagese97db1e0399aa5e27071f0042784681d28417f3e526c61f62c8e3635ee5ad334typer-0.9.4.tar.gz"
    sha256 "f714c2d90afae3a7929fcd72a3abb08df305e1ff61719381384211c4070af57f"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesd1bc51647cd02527e87d05cb083ccc402f93e441606ff1f01739a62c8ad09ba5typing_extensions-4.14.0.tar.gz"
    sha256 "8676b788e32f02ab42d9e7c61324048ae4c6d844a399eebace3d4979d75ceef4"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages15229ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bcurllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "yarl" do
    url "https:files.pythonhosted.orgpackages3cfbefaa23fa4e45537b827620f04cf8f3cd658b76642205162e072703a5b963yarl-1.20.1.tar.gz"
    sha256 "d017a4997ee50c91fd5466cef416231bb82177b93b029906cefc542ce14c35ac"
  end

  def install
    # The source doesn't have a valid SOURCE_DATE_EPOCH, so here we set default.
    ENV["SOURCE_DATE_EPOCH"] = "1451574000"

    virtualenv_install_with_resources
  end

  test do
    (testpath"test.py").write <<~PYTHON
      def foo():
        print('Hello world!')
    PYTHON

    assert_includes shell_output("#{bin}codelimit check #{testpath}test.py"), "Refactoring not necessary"
  end
end