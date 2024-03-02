class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/53/98/a4ed0243a90fd1c654fb8b39345f49d25470149ab60f80867ff7367de5f2/diffoscope-259.tar.gz"
  sha256 "c1f14452467f84c4be804a3725cbfdd5eadf977ece7ad463be8b647d1a87fb42"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b07fe661db38cc829b727ba0a2b420878cb09e967c42154b542f29b7560c5f8b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "526aed66923ff9f75123c59e4639846ab04fd11946eeb4cef9d4fd3e45788918"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd4ef835ac5617e8f0dec2d1db5f2d6d45c7658467ff495904a7c0713114aeaa"
    sha256 cellar: :any_skip_relocation, sonoma:         "8fbdd4e7060f9a0ab8920d8561157f0651e752bf1fed59c06edcfcb42cd0db15"
    sha256 cellar: :any_skip_relocation, ventura:        "d1d37c380b9e846a0cb53a5a4bca88f176bda514949734b081c537fc8fc0ff35"
    sha256 cellar: :any_skip_relocation, monterey:       "240d77827edc94fb3676bc8fba82f5d8ffeda6ab7c96ea04ecebc2949ca5fb1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7353916b9742e15d6bf0a52192852b30540190bd08fbccb8f88d10e068293ab"
  end

  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "python@3.12"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/f0/a2/ce706abe166457d5ef68fac3ffa6cf0f93580755b7d5f883c456e94fab7b/argcomplete-3.2.2.tar.gz"
    sha256 "f3e49e8ea59b4026ee29548e24488af46e30c9de57d48638e24f54a1ea1000a2"
  end

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