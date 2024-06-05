class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/d5/11/63e6482bd559fbbb3f485b231cb461aea5da739f785177fd9d34ce4dc43d/diffoscope-270.tar.gz"
  sha256 "13508023d21220c22c1b889dd85617af92a9e1200d1ef028681987f3f2101e3f"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4196f777f5f1322050ea42c4a97f1af5a1c43cdd134433d223e430e883c21662"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4196f777f5f1322050ea42c4a97f1af5a1c43cdd134433d223e430e883c21662"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4196f777f5f1322050ea42c4a97f1af5a1c43cdd134433d223e430e883c21662"
    sha256 cellar: :any_skip_relocation, sonoma:         "8d6bba13dd81ad39f1edac643f901cab86dcc97edbfe54c33188336f8dedbaa9"
    sha256 cellar: :any_skip_relocation, ventura:        "8d6bba13dd81ad39f1edac643f901cab86dcc97edbfe54c33188336f8dedbaa9"
    sha256 cellar: :any_skip_relocation, monterey:       "8d6bba13dd81ad39f1edac643f901cab86dcc97edbfe54c33188336f8dedbaa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c479efccb53670c0672c7d3f3e4ca46aac18be8f00e6f093d2b52839ab9437d"
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