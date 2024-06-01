class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/4d/3d/c6753ae5e63b41f745e4918544f8a73e0819071599beff7170fd6ea42801/diffoscope-269.tar.gz"
  sha256 "16163310efbf97bfef9e72595349453449f2ad4ffc67c88134805300899ebe02"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "09c0899f2ff95bf97926d469b64ebb138ea003118ba850dadddaec3677873b00"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "09c0899f2ff95bf97926d469b64ebb138ea003118ba850dadddaec3677873b00"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09c0899f2ff95bf97926d469b64ebb138ea003118ba850dadddaec3677873b00"
    sha256 cellar: :any_skip_relocation, sonoma:         "c493533f889256374530985340e9ccb0def5c81d0ab220a8a9b10b540150d06a"
    sha256 cellar: :any_skip_relocation, ventura:        "c493533f889256374530985340e9ccb0def5c81d0ab220a8a9b10b540150d06a"
    sha256 cellar: :any_skip_relocation, monterey:       "c493533f889256374530985340e9ccb0def5c81d0ab220a8a9b10b540150d06a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbc8c69059783237e1fa43ee9e9acb1d5f6cd11e149f2a9c4decffddec9e129b"
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