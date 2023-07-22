class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/b2/cd/cda13379a30bca3e9e5a2cc924eddd0bc91b95b6eb964cdb5b414947e16f/diffoscope-245.tar.gz"
  sha256 "922930b14a7189e12a67f08c9e21b09bb621a1005bcaf58fead5df1a42bc4d7b"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "03d2c0d756795603ed91d446e833ae65120b2c2a2db06d26b045376d482bd683"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41a900d62b9922ea7fa8d24957ee4185a65fca63185deb9b37d57e5a566e67e0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2fddde9db6f873c41785ad9e84621de4ff72a957e7f905839f52d00e4e1f35c4"
    sha256 cellar: :any_skip_relocation, ventura:        "df1dee3d1388dd0494d82f59f912c1a0c77423b5d54a9927e70be30342f648d7"
    sha256 cellar: :any_skip_relocation, monterey:       "99ce249b3ab39f760a9f8e988ada49cb398702d0809a12ae6ad1cc7eab7a4352"
    sha256 cellar: :any_skip_relocation, big_sur:        "938e1b43332010b93d6f6d66e66f8514bf7c601fb8c2369fcf1a2e953388aec6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12c3a9951fa16c594818dc573f0d40a417b5176452290f929c6fe239c7563cc2"
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