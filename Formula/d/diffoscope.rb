class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/9a/62/393a4f0aa465a4aa525b3fe683124040294a07aa0739ed8893b4ab4150b4/diffoscope-288.tar.gz"
  sha256 "5b39fde58d6fc4a4c05cb21eecb48b0b67167c2ad9e23d90ac749d891156abd2"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a3b001c75fa867e71e0958da7dc4ed8de3a9c5313e5f1bca118093eb757f704"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a3b001c75fa867e71e0958da7dc4ed8de3a9c5313e5f1bca118093eb757f704"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5a3b001c75fa867e71e0958da7dc4ed8de3a9c5313e5f1bca118093eb757f704"
    sha256 cellar: :any_skip_relocation, sonoma:        "593d5d14e8a9e2a0c781ee88c77e375cb6e46d8f7b6b67dc0b677c2a337a26ff"
    sha256 cellar: :any_skip_relocation, ventura:       "593d5d14e8a9e2a0c781ee88c77e375cb6e46d8f7b6b67dc0b677c2a337a26ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b387ca0e51b07be121e3d4596703d55765dbc819e1e0e1c7044def57989bafdf"
  end

  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "python@3.13"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/0c/be/6c23d80cb966fb8f83fb1ebfb988351ae6b0554d0c3a613ee4531c026597/argcomplete-3.5.3.tar.gz"
    sha256 "c12bf50eded8aebb298c7b7da7a5ff3ee24dffd9f5281867dfe1424b58c55392"
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