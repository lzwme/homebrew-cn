class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/b0/ab/1c5cc184a859ab7c21efbcc7a0d6396a7e0be4d36c1615d76865ec9aadb7/diffoscope-252.tar.gz"
  sha256 "e268384fa484f3dd8a936da626e6ef1b231dcb286d09a360f37548637f8dd46d"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7bd8a0671e2569fd21cf460d7df2b9f593180a5623f4db09a6e920b14bf4c18d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "67511a0b34d9a332209d13889b1eaa1dd7c8fbeddfb274f0739d9d5603d18204"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92c2f7a2ae6adaddd44b72b0f469a630b534ee17b7806200af1a3be741593561"
    sha256 cellar: :any_skip_relocation, sonoma:         "5245c93a4a42713d07353512b498704eecad3d50ce4a3eabedcc755eae128cf1"
    sha256 cellar: :any_skip_relocation, ventura:        "a6fc0c2e6afccdacc9b14460a755d2cc3095ca116439e9dd6446805d79743b55"
    sha256 cellar: :any_skip_relocation, monterey:       "21418594a72a29130078a86a81665b1dc8b384a2c88b31888ccaadceb463478e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4514b06245da88d1d1e194ee768f027d29a5359fcbde78a24193bf90b4ae628d"
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