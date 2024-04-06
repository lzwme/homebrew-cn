class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/4b/1a/02922061a5e5ea718fe1a63b1b7a8f932a8420b914904ca5b5987369f926/diffoscope-263.tar.gz"
  sha256 "9de909523729b9e700dcbdea362d23e09d8a31d71da499edd02ea4e3222b46bf"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2b5e26a3654ffe6fb78a68b13ce4bcf407d65f9d755576c37a8c2e86e35897f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b5e26a3654ffe6fb78a68b13ce4bcf407d65f9d755576c37a8c2e86e35897f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b5e26a3654ffe6fb78a68b13ce4bcf407d65f9d755576c37a8c2e86e35897f7"
    sha256 cellar: :any_skip_relocation, sonoma:         "b9005a1615352fb9f18e01c9180d5e6550f098d6860502cd0c027951ba539ad1"
    sha256 cellar: :any_skip_relocation, ventura:        "b9005a1615352fb9f18e01c9180d5e6550f098d6860502cd0c027951ba539ad1"
    sha256 cellar: :any_skip_relocation, monterey:       "b9005a1615352fb9f18e01c9180d5e6550f098d6860502cd0c027951ba539ad1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc6395f797ce4606299c36e87363cef9641be754fad9da6399401127cd7eedc9"
  end

  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "python@3.12"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/3c/c0/031c507227ce3b715274c1cd1f3f9baf7a0f7cec075e22c7c8b5d4e468a9/argcomplete-3.2.3.tar.gz"
    sha256 "bf7900329262e481be5a15f56f19736b376df6f82ed27576fa893652c5de6c23"
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