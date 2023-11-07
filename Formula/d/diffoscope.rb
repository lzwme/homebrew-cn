class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/e5/92/5d4b06ebe9c9bd30ccf0c462c1c87825ecc8dfb7e50057bd98cb3e1dda6b/diffoscope-251.tar.gz"
  sha256 "c9ba2fc24379b2ba4457dc7be6970884cc2ee94c20d44f3889c2a4741e6178d3"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4cf378dacb0d1e6d6f969c8f21894788ce26a079ee583e70d753a1549eff95cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "058d72a78cebe0ec91b1bbd594fa059a2aec96ceeb3364be95cef7b165d7f385"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "771187004ce6700ceea252450e724ccd69d932b3f96ae9968059ffa464042438"
    sha256 cellar: :any_skip_relocation, sonoma:         "587f4548019054b8e44f652454cf0f897e3eeb6b71b0bb13cd9b07549ee2220d"
    sha256 cellar: :any_skip_relocation, ventura:        "417cb183255a25788f4a8246254c058c447a9c15d0f7f1b926c33f4ed0198cf2"
    sha256 cellar: :any_skip_relocation, monterey:       "a7e46edce1aa61dc32fd53547c09e534afd5f6d08ee9b1a48ef234f4100d4d9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca743cfe061f9fc8daac51f65527952ee4a0d753d03139ca501a1815a4e33ec7"
  end

  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "python-argcomplete"
  depends_on "python@3.12"

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
    venv = virtualenv_create(libexec, "python3.12")
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