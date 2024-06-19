class Enex2notion < Formula
  include Language::Python::Virtualenv

  desc "Import Evernote ENEX files to Notion"
  homepage "https:github.comvzhd1701enex2notion"
  url "https:files.pythonhosted.orgpackagesde5cc0ce22d810226345411b03177f9b43c35b82c3a671d5d73f56fc43b0858eenex2notion-0.3.1.tar.gz"
  sha256 "f11d8a7b6c135b4d08c63e1256279d56b3798cdd48ad3b6e39c0770dc3bd82e6"
  license "MIT"
  revision 8

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "680d1144e6b20fe7bfda6d62f1ddf4f4cb2010b688ffb470d4cddda61f7aae98"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f4214132c7eb46630b99028a65d186345f0e14d9f2bbff97d7595ec26756f350"
    sha256 cellar: :any,                 arm64_monterey: "491fde46fb53e77fc13c69c08108101ecc5e2d88457f7029887ef143f28688d6"
    sha256 cellar: :any_skip_relocation, sonoma:         "06460fdb9fdaddeed39ba9e9cb965edc5e2b5c7fa35fc8d02bf4a200a90a66e2"
    sha256 cellar: :any_skip_relocation, ventura:        "7a056dc31373aa7afef5919b57ac1cecd2137428ce90aa5083145e9265619295"
    sha256 cellar: :any,                 monterey:       "0e90fa58cb8fe13f91263d6553b0f2ba458faa6bbacc427fddc9d26636fcc13e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b66ddd2dffc21fc837b4db87dc6d97ad8aabb9932dd07b80485fb09adf29a40"
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
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
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
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
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
    url "https:files.pythonhosted.orgpackages446f38d2335a2b70b9982d112bb177e3dbe169746423e33f718bf5e9c7b3ddd3tinycss2-1.3.0.tar.gz"
    sha256 "152f9acabd296a8375fbca5b84c961ff95971fcfc32e79550c8df8e29118c54d"
  end

  resource "tqdm" do
    url "https:files.pythonhosted.orgpackages5ac0b7599d6e13fe0844b0cda01b9aaef9a0e87dbb10b06e4ee255d3fa1c79a2tqdm-4.66.4.tar.gz"
    sha256 "e4d936c9de8727928f3be6079590e97d9abfe8d39a590be678eb5919ffc186bb"
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
    url "https:files.pythonhosted.orgpackages436dfa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  resource "w3lib" do
    url "https:files.pythonhosted.orgpackagesccdd8d080c3bf19f4e853433193e0ffd894d9f5c5a55c11d7283038ee822a0dbw3lib-2.2.1.tar.gz"
    sha256 "756ff2d94c64e41c8d7c0c59fea12a5d0bc55e33a531c7988b4a163deb9b07dd"
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