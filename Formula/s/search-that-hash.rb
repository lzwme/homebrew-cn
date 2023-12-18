class SearchThatHash < Formula
  include Language::Python::Virtualenv

  desc "Searches Hash APIs to crack your hash quickly"
  homepage "https:github.comHashPalsSearch-That-Hash"
  url "https:files.pythonhosted.orgpackages5eb9a304a92ba77a9e18b3023b66634e71cded5285cef7e3b56d3c1874e9d84esearch-that-hash-0.2.8.tar.gz"
  sha256 "384498abbb9a611aa173b20d06b135e013674670fecc01b34d456bfe536e0bca"
  license "GPL-3.0-or-later"
  revision 6
  head "https:github.comHashPalsSearch-That-Hash.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "354a02bb045db86f60161b4d8bb395f850483fca2433fa9b064d3c4845e9228a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "787e063861cfba51dba2b1232db09032f20f134d0c4a03943fca5546fd971e0b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e2b59220c9287608e76892f891ea691c8faf778830b68188a3cadfc88e339d3"
    sha256 cellar: :any_skip_relocation, sonoma:         "88833c4b4cdab2860aab715f538b8caa26357052b3cbd5962ecc0c90659a998e"
    sha256 cellar: :any_skip_relocation, ventura:        "e378ac015b287b04647feba9102f465d78ee98062fc1fa3233ab8056e986e02d"
    sha256 cellar: :any_skip_relocation, monterey:       "c81254051fd25f243d5170530c67ab10bba7409dc67e3a00d0af2d17085de823"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a64017fd9b628e65ce3bb6f7eb5a5b18e763a8f1513297c4d25f30729d401b2"
  end

  depends_on "name-that-hash"
  depends_on "pygments"
  depends_on "python-certifi"
  depends_on "python-pyparsing"
  depends_on "python-toml"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"

  resource "appdirs" do
    url "https:files.pythonhosted.orgpackagesd7d805696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagescface89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "cloudscraper" do
    url "https:files.pythonhosted.orgpackagesac256d0481860583f44953bd791de0b7c4f6d7ead7223f8a17e776247b34a5b4cloudscraper-1.2.71.tar.gz"
    sha256 "429c6e8aa6916d5bad5c8a5eac50f3ea53c9ac22616f6cb21b18dcc71517d0d3"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "coloredlogs" do
    url "https:files.pythonhosted.orgpackagesccc7eed8f27100517e8c0e6b923d5f0845d0cb99763da6fdee00478f91db7325coloredlogs-15.0.1.tar.gz"
    sha256 "7c991aa71a4577af2f82600d8f8f3a89f936baeaf9b50a9c197da014e5bf16b0"
  end

  resource "humanfriendly" do
    url "https:files.pythonhosted.orgpackagescc3f2c29224acb2e2df4d2046e4c73ee2662023c58ff5b113c4c1adac0886c43humanfriendly-10.0.tar.gz"
    sha256 "6b0b831ce8f15f7300721aa49829fc4e83921a9a301cc7f606be6686a2288ddc"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages8be143beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "loguru" do
    url "https:files.pythonhosted.orgpackages6d250d65383fc7b4f4ce9505d16773b2b2a9f0f465ef00ab337d66afff47594aloguru-0.5.3.tar.gz"
    sha256 "b28e72ac7a98be3d28ad28570299a393dfcd32e5e3f6a353dec94675767b6319"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-toolbelt" do
    url "https:files.pythonhosted.orgpackagesf361d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bbrequests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesaf47b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3curllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  def python3
    "python3.12"
  end

  def install
    # Switch build-system to poetry-core to avoid rust dependency on Linux.
    # Remove when mergedreleased: https:github.comHashPalsSearch-That-Hashpull184
    inreplace "pyproject.toml", 'requires = ["poetry>=0.12"]', 'requires = ["poetry-core>=1.0"]'
    inreplace "pyproject.toml", 'build-backend = "poetry.masonry.api"', 'build-backend = "poetry.core.masonry.api"'

    virtualenv_install_with_resources

    # link dependent virtualenvs to this one
    site_packages = Language::Python.site_packages(python3)
    paths = %w[name-that-hash].map do |package_name|
      package = Formula[package_name].opt_libexec
      packagesite_packages
    end
    (libexecsite_packages"homebrew-deps.pth").write paths.join("\n")

    site_packages = Language::Python.site_packages(python3)
    pth_contents = "import site; site.addsitedir('#{libexecsite_packages}')\n"
    (prefixsite_packages"homebrew-search_that_hash.pth").write pth_contents
  end

  test do
    hash = "5f4dcc3b5aa765d61d8327deb882cf99"
    output = shell_output("#{bin}sth --text #{hash}")
    assert_match "#{hash}\n", output
    assert_match "Text : password\nType : MD5\n", output

    system python3, "-c", "from search_that_hash import api"
  end
end