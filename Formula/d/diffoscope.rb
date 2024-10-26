class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/50/a2/2c4587936dd94b2dc810d9600e20902dbf6819e94c6978d25cd432d323bd/diffoscope-282.tar.gz"
  sha256 "04893051cbf68043aa5bc496a554f76e96b847375a74d7bc90ee150583c7488b"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d7ca41a81c455faa096bc1b3345a1d950589296f117d3e968babee049ccedd1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d7ca41a81c455faa096bc1b3345a1d950589296f117d3e968babee049ccedd1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9d7ca41a81c455faa096bc1b3345a1d950589296f117d3e968babee049ccedd1"
    sha256 cellar: :any_skip_relocation, sonoma:        "010ad063d89953a2545b3c5eaf0be8df1d3aa1080c25f79ed8960defe63de24d"
    sha256 cellar: :any_skip_relocation, ventura:       "010ad063d89953a2545b3c5eaf0be8df1d3aa1080c25f79ed8960defe63de24d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4a1a8e56d71cacfce4190a4a29b4a4eb566a93af8bf7ebce90b4535dff98ebb"
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