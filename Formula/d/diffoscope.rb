class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/61/41/49e3e9916b05ef3ab86def24712294a85b20bdc20f6e572587a7853603e9/diffoscope-248.tar.gz"
  sha256 "0a5cf630b773abef4ec9e2bc0bfe3cf04a86d73642f72f123082756124073763"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5ca27495c9bf6f6178b7097968566759315b7c68c0bd95ed151a7df7fcbd52c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77ba7a12fe6e910f8feb5ce011627d62d3fe186fe01cdac9c27e206b56871fde"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0ea4db761e2e4d144b31ecf50c2ef7834ea067bd644ab6ee807a56e5270a6ea2"
    sha256 cellar: :any_skip_relocation, ventura:        "cf7326d02a5c348932dad197b6be13542c31b707f38290c0125774803d5de80f"
    sha256 cellar: :any_skip_relocation, monterey:       "22529e51937a3b0017ee4fe134b5d87325b74244c695d01f1bd76c87da56f7fa"
    sha256 cellar: :any_skip_relocation, big_sur:        "a6e55ef290343c005f05b67ac09494c0fb38e2190c4cde6227f16bf1d43be2dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2feecedc903277a6215656ff642393aca2619ef5e4f30a099f5eeffc1420fae"
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