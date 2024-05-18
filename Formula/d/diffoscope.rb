class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/6e/6a/7f434e66ededc543a9363e020d829c255153df9342a10fe1f0d17d4ebcfa/diffoscope-267.tar.gz"
  sha256 "c0a807aa66e18eae88c1adca28988675c9749d3ad1a8db3d2eb7e2afb8763568"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9450c648ccbbe34aaada84146ca6747ebeb553b8b87d7d31abf1e4b105c661b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "55757312b0bb6733679e29116b92f5facce3b1b6969d5027ce3b838a65fecc0d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "089e692bfd4cb6970c0e0459d4bd12c6686a874ecda935cc83e5177ceff7d3f4"
    sha256 cellar: :any_skip_relocation, sonoma:         "b5256ece0c0bb5515b8894d76a82d67b471120193d77868c215fddb2c2d1c1c2"
    sha256 cellar: :any_skip_relocation, ventura:        "fb5d69f48020b88cb67c3a7ac7674c239f6f2bff69c13a0bad1446cdc671cb78"
    sha256 cellar: :any_skip_relocation, monterey:       "f0707c27a40930ca7590f2890764ecec52aa8fde163fde43eca6419fe4cd61ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b93b78a4f5c02416d789d2bcce8d2042948b2f1f0c58bfbd041d44772a8e9f7a"
  end

  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "python@3.12"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/79/51/fd6e293a64ab6f8ce1243cf3273ded7c51cbc33ef552dce3582b6a15d587/argcomplete-3.3.0.tar.gz"
    sha256 "fd03ff4a5b9e6580569d34b273f741e85cd9e072f3feeeee3eba4891c70eda62"
  end

  resource "libarchive-c" do
    url "https://files.pythonhosted.org/packages/a0/f9/3b6cd86e683a06bc28b9c2e1d9fe0bd7215f2750fd5c85dce0df96db8eca/libarchive-c-5.1.tar.gz"
    sha256 "7bcce24ea6c0fa3bc62468476c6d2f6264156db2f04878a372027c10615a2721"
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