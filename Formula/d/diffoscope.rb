class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/c4/0e/5a6c65b642086ce6713f16e1fab1a228b622661f9bee15caa7130c99c194/diffoscope-256.tar.gz"
  sha256 "9937e3d70358d5cc00aa5fa8a3db9dd6be532a0d3cd2d064add2cda736a97c2a"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "98344187d21bb4bba5b16648a0f8053d4b6947a048f810b45b317c9aba2af24b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e71195030144c861332d2d7837716d130253baf94feb0b5a99990718c864975"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c87b1a386fc867f652345b993222288159888c777c779b95633167d3bd00906"
    sha256 cellar: :any_skip_relocation, sonoma:         "484382a1f6da70cef1450da84bd88811c54da1b3e0982e00d232cb28f99cfe39"
    sha256 cellar: :any_skip_relocation, ventura:        "0c6f4c37b91b7d3bc148928d5eec5b44d5c071180150f2c70dc52b446b67f8f4"
    sha256 cellar: :any_skip_relocation, monterey:       "889c317d6b7d57f90731933d1412e8f7440c886ec8ab8bb443183f3049a03266"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "921af80e3500be7c0ca6b5a5d930278c6d67d7155cbaa5b8f8e4a46dd5c63a93"
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