class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/6b/6b/c9ccbef5d686a8bca94cd02415619c859fc09e793e6e15131d8423a8b892/diffoscope-283.tar.gz"
  sha256 "0469ff70e1f37b5e96496f5e3c88dbafcf03fafff409a90601ed84febc31c543"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aba5a004257d0481922c2c1eb687bd1b4437cfcb4595425f9461ffd1a9a3e5b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aba5a004257d0481922c2c1eb687bd1b4437cfcb4595425f9461ffd1a9a3e5b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aba5a004257d0481922c2c1eb687bd1b4437cfcb4595425f9461ffd1a9a3e5b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e76ec3eef2b37b942d93a65b14b9d152516556a1ff0c88920f905116b8e187c"
    sha256 cellar: :any_skip_relocation, ventura:       "1e76ec3eef2b37b942d93a65b14b9d152516556a1ff0c88920f905116b8e187c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "751192d712a9b4218866af9e5871cee8ba78c452ec1354516e69a873dba58acc"
  end

  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "python@3.13"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/5f/39/27605e133e7f4bb0c8e48c9a6b87101515e3446003e0442761f6a02ac35e/argcomplete-3.5.1.tar.gz"
    sha256 "eb1ee355aa2557bd3d0145de7b06b2a45b0ce461e1e7813f5d066039ab4177b4"
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
    venv = virtualenv_create(libexec, "python3.13")
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