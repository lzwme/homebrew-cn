class Enex2notion < Formula
  include Language::Python::Virtualenv

  desc "Import Evernote ENEX files to Notion"
  homepage "https:github.comvzhd1701enex2notion"
  url "https:files.pythonhosted.orgpackagesde5cc0ce22d810226345411b03177f9b43c35b82c3a671d5d73f56fc43b0858eenex2notion-0.3.1.tar.gz"
  sha256 "f11d8a7b6c135b4d08c63e1256279d56b3798cdd48ad3b6e39c0770dc3bd82e6"
  license "MIT"
  revision 4

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "73284a6e52fd4c0cff240708f1a028010462967b2d9a416f360a8f0ccd6c6300"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a93633e279074ac241df98c8d31f7a74fd3bfe053394e23b7353842029475eac"
    sha256 cellar: :any,                 arm64_monterey: "3e3c796d68af8f761c2d45b524b514dcdd7b04d4fd7f786d4ca9b42c929dc11b"
    sha256 cellar: :any_skip_relocation, sonoma:         "85c1f41a5b90e831033f32f800ef40d4c324ae182d544e5072326dd234fb89cc"
    sha256 cellar: :any_skip_relocation, ventura:        "2a4eda0458c44e4d5c0b8e7311ebcc42abac002884a086d40336b33f74c8fd0d"
    sha256 cellar: :any,                 monterey:       "368e6d6202c328f9d1ab6a4188f3e29bcfc03655cf72f4e1bd4d561b69116228"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74d5b37e44becd480b08a7f75da0ad1c71e6dcbcede527f2acf9b3bd1190a7cf"
  end

  depends_on "certifi"
  depends_on "pymupdf"
  depends_on "python@3.12"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "beautifulsoup4" do
    url "https:files.pythonhosted.orgpackagesb3ca824b1195773ce6166d388573fc106ce56d4a805bd7427b624e063596ec58beautifulsoup4-4.12.3.tar.gz"
    sha256 "74e3d1928edc070d21748185c46e3fb33490f22f52a3addee9aee0f4f7781051"
  end

  resource "bs4" do
    url "https:files.pythonhosted.orgpackages10ed7e8b97591f6f456174139ec089c769f89a94a1a4025fe967691de971f314bs4-0.0.1.tar.gz"
    sha256 "36ecea1fd7cc5c0c6e4a1ff075df26d50da647b75376626cc186e2212886dd3a"
  end

  resource "cached-property" do
    url "https:files.pythonhosted.orgpackages612cd21c1c23c2895c091fa7a91a54b6872098fea913526932d21902088a7c41cached-property-1.5.2.tar.gz"
    sha256 "9fa5755838eecbb2d234c3aa390bd80fbd3ac6b6869109bfc1b499f7bd89a130"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "commonmark" do
    url "https:files.pythonhosted.orgpackages6048a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "dictdiffer" do
    url "https:files.pythonhosted.orgpackages617b35cbccb7effc5d7e40f4c55e2b79399e1853041997fcda15c9ff160abba0dictdiffer-0.9.0.tar.gz"
    sha256 "17bacf5fbfe613ccf1b6d512bd766e6b21fb798822a133aa86098b8ac9997578"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesbf3fea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "lxml" do
    url "https:files.pythonhosted.orgpackages8414c2070b5e37c650198de8328467dd3d1681e80986f81ba0fea04fc4ec9883lxml-4.9.4.tar.gz"
    sha256 "b1541e50b78e15fa06a2670157a1962ef06591d4c998b998047fff5e3236880e"
  end

  resource "notion-vzhd1701-fork" do
    url "https:files.pythonhosted.orgpackages775b314816c876cae1dac143c3e0221a9b4b9b186576ef92e75e0aab041c179cnotion_vzhd1701_fork-0.0.37.tar.gz"
    sha256 "36bab3b5257a3019ada5b085d9c6f7d1f5d466d38bb8a089b850ce792fd561bc"
  end

  resource "pdfkit" do
    url "https:files.pythonhosted.orgpackages58bb6ddc62b4622776a6514fd749041c2b4bccd343e006d00de590f8090ac8b1pdfkit-1.0.0.tar.gz"
    sha256 "992f821e1e18fc8a0e701ecae24b51a2d598296a180caee0a24c0af181da02a9"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-slugify" do
    url "https:files.pythonhosted.orgpackages5d45915967d7bcc28fd12f36f554e1a64aeca36214f2be9caf87158168b5a575python-slugify-6.1.2.tar.gz"
    sha256 "272d106cb31ab99b3496ba085e3fea0e9e76dcde967b5e9992500d1f785ce4e1"
  end

  resource "pytz-deprecation-shim" do
    url "https:files.pythonhosted.orgpackages94f0909f94fea74759654390a3e1a9e4e185b6cd9aa810e533e3586f39da3097pytz_deprecation_shim-0.1.0.post0.tar.gz"
    sha256 "af097bae1b616dde5c5744441e2ddc69e74dfdcb0c263129610d85b87445a59d"
  end

  resource "ratelimit" do
    url "https:files.pythonhosted.orgpackagesab38ff60c8fc9e002d50d48822cc5095deb8ebbc5f91a6b8fdd9731c87a147c9ratelimit-2.2.1.tar.gz"
    sha256 "af8a9b64b821529aca09ebaf6d8d279100d766f19e90b5059ac6a718ca6dee42"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "soupsieve" do
    url "https:files.pythonhosted.orgpackagesce21952a240de1c196c7e3fbcd4e559681f0419b1280c617db21157a0390717bsoupsieve-2.5.tar.gz"
    sha256 "5663d5a7b3bfaeee0bc4372e7fc48f9cff4940b3eec54a6451cc5299f1097690"
  end

  resource "text-unidecode" do
    url "https:files.pythonhosted.orgpackagesabe2e9a00f0ccb71718418230718b3d900e71a5d16e701a3dae079a21e9cd8f8text-unidecode-1.3.tar.gz"
    sha256 "bad6603bb14d279193107714b288be206cac565dfa49aa5b105294dd5c4aab93"
  end

  resource "tinycss2" do
    url "https:files.pythonhosted.orgpackages75be24179dfaa1d742c9365cbd0e3f0edc5d3aa3abad415a2327c5a6ff8ca077tinycss2-1.2.1.tar.gz"
    sha256 "8cff3a8f066c2ec677c06dbc7b45619804a6938478d9d73c284b29d14ecb0627"
  end

  resource "tqdm" do
    url "https:files.pythonhosted.orgpackagesea853ce0f9f7d3f596e7ea57f4e5ce8c18cb44e4a9daa58ddb46ee0d13d6bff8tqdm-4.66.2.tar.gz"
    sha256 "6cd52cdf0fef0e0f543299cfc96fec90d7b8a7e88745f411ec33eb44d5ed3531"
  end

  resource "tzdata" do
    url "https:files.pythonhosted.orgpackages745be025d02cb3b66b7b76093404392d4b44343c69101cc85f4d180dd5784717tzdata-2024.1.tar.gz"
    sha256 "2674120f8d891909751c38abcdfd386ac0a5a1127954fbc332af6b5ceae07efd"
  end

  resource "tzlocal" do
    url "https:files.pythonhosted.orgpackagesd73368fe21c4a3ecf5e093b5179ea23be777037b1e83722f5559a1e2223d2422tzlocal-4.3.1.tar.gz"
    sha256 "ee32ef8c20803c19a96ed366addd3d4a729ef6309cb5c7359a0cc2eeeb7fa46a"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages7a507fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  resource "w3lib" do
    url "https:files.pythonhosted.orgpackages47790c62d246fcc9e6fe520c196fe4dad2070db64692bde49c15c4f71fe7d1cbw3lib-2.1.2.tar.gz"
    sha256 "ed5b74e997eea2abe3c1321f916e344144ee8e9072a6f33463ee8e57f858a4b1"
  end

  resource "webencodings" do
    url "https:files.pythonhosted.orgpackages0b02ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  # build patch to support pymupdf 1.23.15, https:github.comvzhd1701enex2notionpull108
  patch do
    url "https:github.comvzhd1701enex2notioncommit2d05d856c73030b340f0a6326ba3725bece23c2b.patch?full_index=1"
    sha256 "e5c2d013fcc083370cbc1d458ecffa6a6d9ad44cb3781e8629aa57bda4b25ff5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath"test.enex").write <<~EOF
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE en-export SYSTEM "http:xml.evernote.compubevernote-export3.dtd">
      <en-export>
        <note>
          <title>Test<title>
          <content>
            <![CDATA[<?xml version="1.0" encoding="UTF-8" standalone="no"?>
              <!DOCTYPE en-note SYSTEM "http:xml.evernote.compubenml2.dtd">
              <en-note><div><br ><div><en-note>
            ]]>
          <content>
        <note>
      <en-export>
    EOF

    assert_match "No token provided", shell_output("#{bin}enex2notion test.enex 2>&1")

    assert_match version.to_s, shell_output("#{bin}enex2notion --version")
  end
end