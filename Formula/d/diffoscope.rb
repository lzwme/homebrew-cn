class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/41/16/918f05c001f3be0d9abb9f930565edb0779ed262fc395e81bde25d82cd49/diffoscope-274.tar.gz"
  sha256 "f324de203b2c20479bf1875803d4780d46d921aa86065fd5b1a889865f04abb0"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "590f240344a3dcce04ad5903f1f007e723cb1b2848d6136968628cdeaf74dfb9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "590f240344a3dcce04ad5903f1f007e723cb1b2848d6136968628cdeaf74dfb9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "590f240344a3dcce04ad5903f1f007e723cb1b2848d6136968628cdeaf74dfb9"
    sha256 cellar: :any_skip_relocation, sonoma:         "16f1989ab6f48c6311a48a950c14bf9e9170e1f2e10ee582fa0ee88027a381c2"
    sha256 cellar: :any_skip_relocation, ventura:        "16f1989ab6f48c6311a48a950c14bf9e9170e1f2e10ee582fa0ee88027a381c2"
    sha256 cellar: :any_skip_relocation, monterey:       "16f1989ab6f48c6311a48a950c14bf9e9170e1f2e10ee582fa0ee88027a381c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b140651dd86f76abacb3628c88c676b49dd90064028598eaf21bff8347a4b5c3"
  end

  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "python@3.12"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/75/33/a3d23a2e9ac78f9eaf1fce7490fee430d43ca7d42c65adabbb36a2b28ff6/argcomplete-3.5.0.tar.gz"
    sha256 "4349400469dccfb7950bb60334a680c58d88699bff6159df61251878dc6bf74b"
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