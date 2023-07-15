class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/5a/14/dfb5d62f2a8010b30ce2d07777b7639fe0c2aa44f7365a52729f49443b83/diffoscope-244.tar.gz"
  sha256 "8bee8bbb144cdb7ddfa21886d5ce1822220139241c9a53def09b4adc3340db93"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a3703835205dca71ba72d3bcae4aca3dfa4916d3659f049c1e48cc9d0dc6aa1b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81ff709d3340596fa5faa63f13ca4f439683bcee7bff825525ae6e6756d0cba4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d8b4cf160f17ca441fad9a0a2645d9aa44aa7f9f0aed7552ec40e20bb506a74b"
    sha256 cellar: :any_skip_relocation, ventura:        "3b74c3fbdf21e0d22b8d54fb47c102af2a7440ebd3a719bb28125f217e886d37"
    sha256 cellar: :any_skip_relocation, monterey:       "0942b2e8d7b2519138cd29699616ba3b0b7fbe482af7c4cc4189aee443bc541a"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ce0693be3a9f7f59a4d5752c6e2fe83668c51924db4a54a76ef689496d480af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37f592b97e4bc4e7fe20783072c60a3292f4afd7ed42e182c3299b077b78bb50"
  end

  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "python@3.11"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/54/c9/41c4dfde7623e053cbc37ac8bc7ca03b28093748340871d4e7f1630780c4/argcomplete-3.1.1.tar.gz"
    sha256 "6c4c563f14f01440aaffa3eae13441c5db2357b5eec639abe7c0b15334627dff"
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
    venv = virtualenv_create(libexec, "python3.11")
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