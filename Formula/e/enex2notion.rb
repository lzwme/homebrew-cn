class Enex2notion < Formula
  include Language::Python::Virtualenv

  desc "Import Evernote ENEX files to Notion"
  homepage "https:github.comvzhd1701enex2notion"
  url "https:files.pythonhosted.orgpackagesde5cc0ce22d810226345411b03177f9b43c35b82c3a671d5d73f56fc43b0858eenex2notion-0.3.1.tar.gz"
  sha256 "f11d8a7b6c135b4d08c63e1256279d56b3798cdd48ad3b6e39c0770dc3bd82e6"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bd2e88d6b73520b37140cf866b6590a58a22aff654fbcb76a576b72142249c11"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ebcba69344dd662af056f4a3a4e9642e96c0cd3caa74c69f0d45d621690ed70"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4619bfef993a4a4a440b118c2956f80b89bee6e6ef84f687bdc2b5eff0f803ec"
    sha256 cellar: :any_skip_relocation, sonoma:         "bc02815148edbdf374e44bf11a627969da5dec10f8e49c3a5f09715c508d20ab"
    sha256 cellar: :any_skip_relocation, ventura:        "c5121211adf25093c0048681a486addc986a2be847acead2116838ae5cf99ef2"
    sha256 cellar: :any_skip_relocation, monterey:       "63f0e58e7617b1279ac70de4ae0e69c48bb5cce0bc5e3bb250b5a0298b9b3468"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5033eaec71899ffbf63f44162e18553fa2341ebc4c394acaa5e4419e9c6d3c56"
  end

  depends_on "python-setuptools" => :build
  depends_on "pymupdf"
  depends_on "python-certifi"
  depends_on "python-lxml"
  depends_on "python@3.12"
  depends_on "six"

  resource "beautifulsoup4" do
    url "https:files.pythonhosted.orgpackagesaf0b44c39cf3b18a9280950ad63a579ce395dda4c32193ee9da7ff0aed547094beautifulsoup4-4.12.2.tar.gz"
    sha256 "492bbc69dca35d12daac71c4db1bfff0c876c00ef4a2ffacce226d4638eb72da"
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
    url "https:files.pythonhosted.orgpackages6db3aa417b4e3ace24067f243e45cceaffc12dba6b8bd50c229b43b3b163768bcharset-normalizer-3.3.1.tar.gz"
    sha256 "d9137a876020661972ca6eec0766d81aef8a5627df628b664b234b73396e727e"
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
    url "https:files.pythonhosted.orgpackages8be143beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
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
    url "https:files.pythonhosted.orgpackages4cc413b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
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
    url "https:files.pythonhosted.orgpackages6206d5604a70d160f6a6ca5fd2ba25597c24abd5c5ca5f437263d177ac242308tqdm-4.66.1.tar.gz"
    sha256 "d88e651f9db8d8551a62556d3cff9e3034274ca5d66e93197cf2490e2dcb69c7"
  end

  resource "tzdata" do
    url "https:files.pythonhosted.orgpackages70e581f99b9fced59624562ab62a33df639a11b26c582be78864b339dafa420dtzdata-2023.3.tar.gz"
    sha256 "11ef1e08e54acb0d4f95bdb1be05da659673de4acbd21bf9c69e94cc5e907a3a"
  end

  resource "tzlocal" do
    url "https:files.pythonhosted.orgpackagesd73368fe21c4a3ecf5e093b5179ea23be777037b1e83722f5559a1e2223d2422tzlocal-4.3.1.tar.gz"
    sha256 "ee32ef8c20803c19a96ed366addd3d4a729ef6309cb5c7359a0cc2eeeb7fa46a"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesaf47b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3curllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  resource "w3lib" do
    url "https:files.pythonhosted.orgpackages47790c62d246fcc9e6fe520c196fe4dad2070db64692bde49c15c4f71fe7d1cbw3lib-2.1.2.tar.gz"
    sha256 "ed5b74e997eea2abe3c1321f916e344144ee8e9072a6f33463ee8e57f858a4b1"
  end

  resource "webencodings" do
    url "https:files.pythonhosted.orgpackages0b02ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
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