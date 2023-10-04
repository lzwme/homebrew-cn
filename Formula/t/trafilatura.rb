class Trafilatura < Formula
  include Language::Python::Virtualenv

  desc "Discovery, extraction and processing for Web text"
  homepage "https://trafilatura.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/a5/81/f7818b3d805427e8448429fd1bfc126a06b2e5daa58ea97a8b153e5454fb/trafilatura-1.6.2.tar.gz"
  sha256 "a984630ad9c54d9fe803555d00f5a028ca65c766ce89bfd87d976f561c55b503"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "207d37b656abe6b21804304cc829b492b3ba46eb73e8288b9145385218f80f01"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4da8f60737dacdfd825f79953bdd2076fb1d9e3709e1b533d7b8fb98f6b4565b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2d22475b7800854fef8c514492d810f82994c09bf9028e18af9f486a4b453e4"
    sha256 cellar: :any_skip_relocation, sonoma:         "02025798c1acfa41a50465467b72fd91a78ae5219506270b598723ee0f1be81a"
    sha256 cellar: :any_skip_relocation, ventura:        "4255d7187591832a718a5aef5379d621da1eae301888df4bce8a5753fb8faca6"
    sha256 cellar: :any_skip_relocation, monterey:       "639c2f2a40071a0c4ac2603199348d1f25c83aebeb686fe3b073bb9bb0209f52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d79c4d15a4c4bc173b0e71a3c2b1a0bbf23ae3489938e98c280870123009db1f"
  end

  depends_on "python-certifi"
  depends_on "python-lxml"
  depends_on "python@3.11"
  depends_on "six"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "courlan" do
    url "https://files.pythonhosted.org/packages/53/35/d141b5ffc381cef94c95d32d7082aff443cfea22b2a75c2839297064d408/courlan-0.9.4.tar.gz"
    sha256 "6906aa9a15ae9d442821e06ae153c60f385cff41a8d44b9597c00b349f7043c5"
  end

  resource "dateparser" do
    url "https://files.pythonhosted.org/packages/7e/16/e95f1d2f8014bac38e00d037e192222e52de7db7c71268ed3b2e12d4893c/dateparser-1.1.8.tar.gz"
    sha256 "86b8b7517efcc558f085a142cdb7620f0921543fcabdb538c8a4c4001d8178e3"
  end

  resource "htmldate" do
    url "https://files.pythonhosted.org/packages/eb/e7/734003a0f198347fa7f95b5edb3e02a9d22e42df5f2f96261366fe7f220e/htmldate-1.5.1.tar.gz"
    sha256 "00530d34618b6e770df537e6a8be74d8359ffe2cc5ee86e06ef20990049b6db6"
  end

  resource "justext" do
    url "https://files.pythonhosted.org/packages/80/6f/72e69f69ae55a9e7d8a1b1a5c8f809ccc615ca0a16dee2ce0ca48dc32dc9/jusText-3.0.0.tar.gz"
    sha256 "7640e248218795f6be65f6c35fe697325a3280fcb4675d1525bcdff2b86faadf"
  end

  resource "langcodes" do
    url "https://files.pythonhosted.org/packages/5f/ec/9955d772ecac0bdfb5d706d64f185ac68bd0d4092acdc2c5a1882c824369/langcodes-3.3.0.tar.gz"
    sha256 "794d07d5a28781231ac335a1561b8442f8648ca07cd518310aeb45d6f0807ef6"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/69/4f/7bf883f12ad496ecc9514cd9e267b29a68b3e9629661a2bbc24f80eff168/pytz-2023.3.post1.tar.gz"
    sha256 "7b4fddbeb94a1eba4b557da24f19fdf9db575192544270a9101d8509f9f43d7b"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/4f/1d/6998ba539616a4c8f58b07fd7c9b90c6b0f0c0ecbe8db69095a6079537a7/regex-2023.8.8.tar.gz"
    sha256 "fcbdc5f2b0f1cd0f6a56cdb46fe41d2cce1e644e3b68832f3eeebc5fb0f7712e"
  end

  resource "tld" do
    url "https://files.pythonhosted.org/packages/19/2b/678082222bc1d2823ea8384c6806085b85226ff73885c703fe0c7143ef64/tld-0.13.tar.gz"
    sha256 "93dde5e1c04bdf1844976eae440706379d21f4ab235b73c05d7483e074fb5629"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/ee/f5/3e644f08771b242f7460438cdc0aaad4d1484c1f060f1e52f4738d342983/tzlocal-5.0.1.tar.gz"
    sha256 "46eb99ad4bdb71f3f72b7d24f4267753e240944ecfc16f25d2719ba89827a803"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/51/13/62cb4a0af89fdf72db4a0ead8026e724c7f3cbf69706d84a4eff439be853/urllib3-2.0.5.tar.gz"
    sha256 "13abf37382ea2ce6fb744d4dad67838eec857c9f4f57009891805e0b5e123594"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/trafilatura --version")

    assert_match "Search\nImages\nMaps\nPlay", shell_output("#{bin}/trafilatura -u https://www.google.com")
  end
end