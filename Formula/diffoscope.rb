class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/79/1f/692d01d49286b68083735b16ca7ab52bdc007203bd21ed74290fece9f04e/diffoscope-246.tar.gz"
  sha256 "5247030aa3f34bae762dbd34ff0e747743c2673640d9c6d800e0603ffffedc6a"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e3b079b98a59201f3a02399c734f6e05ce9bcafee7ad8a708434d0ceb986fd8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7171b8e9ec6942601eb456486952c07a4c78b4563d4958f5d6050ac4fc815503"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c3837efcccfbe7b86edd128eb6043b467ff9c0982cb0c690c3a7dd7ae5be3707"
    sha256 cellar: :any_skip_relocation, ventura:        "0c733d64b56ad035314c833982e64bd284357840b7a23f22ef8bf98c7bb64205"
    sha256 cellar: :any_skip_relocation, monterey:       "756c374dd35360eda9524829af07c451eaddb804801988cb167fadde29382cb5"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e86f4b7b0e3a107971251b534a09f78517945118cc8528a94459ca1c5108fcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3855f09ee9f73849c963a424861795d3e306e72cc8b28faa253b4069447dbc8d"
  end

  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "python@3.11"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/54/c9/41c4dfde7623e053cbc37ac8bc7ca03b28093748340871d4e7f1630780c4/argcomplete-3.1.1.tar.gz"
    sha256 "6c4c563f14f01440aaffa3eae13441c5db2357b5eec639abe7c0b15334627dff"
  end

  resource "libarchive-c" do
    url "https://files.pythonhosted.org/packages/59/d6/eab966f12b33a97c78d319c38a38105b3f843cf7d79300650b7ac8c9d349/libarchive-c-5.0.tar.gz"
    sha256 "d673f56673d87ec740d1a328fa205cafad1d60f5daca4685594deb039d32b159"
  end

  resource "progressbar" do
    url "https://files.pythonhosted.org/packages/a3/a6/b8e451f6cff1c99b4747a2f7235aa904d2d49e8e1464e0b798272aa84358/progressbar-2.5.tar.gz"
    sha256 "5d81cb529da2e223b53962afd6c8ca0f05c6670e40309a7219eacc36af9b6c63"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/da/db/0b3e28ac047452d079d375ec6798bf76a036a08182dbb39ed38116a49130/python-magic-0.4.27.tar.gz"
    sha256 "c1ba14b08e4a5f5c31a302b7721239695b2f0f058d125bd5ce1ee36b9d9d3c3b"
  end

  def install
    venv = virtualenv_create(libexec, "python3.11")
    venv.pip_install resources
    venv.pip_install buildpath

    bin.install libexec/"bin/diffoscope"
    libarchive = Formula["libarchive"].opt_lib/shared_library("libarchive")
    bin.env_script_all_files(libexec/"bin", LIBARCHIVE: libarchive)
  end

  test do
    (testpath/"test1").write "test"
    cp testpath/"test1", testpath/"test2"
    system bin/"diffoscope", "--progress", "test1", "test2"
  end
end