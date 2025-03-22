class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/79/e8/7006c2434df59ce5027745256269c27b67d533dcae91c9c07290a248808a/diffoscope-291.tar.gz"
  sha256 "fee52063f963b30bb940042b7f279c2321e33386221dfa210e360dde82eb6d01"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c34e3531ed45431cab7f5046af09e32395126c6e8a454ab747c36a77b4dad662"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c34e3531ed45431cab7f5046af09e32395126c6e8a454ab747c36a77b4dad662"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c34e3531ed45431cab7f5046af09e32395126c6e8a454ab747c36a77b4dad662"
    sha256 cellar: :any_skip_relocation, sonoma:        "933f5f45b545019bfd57dfce5519e066b1ef66d6bb65bd075eca393e36c41101"
    sha256 cellar: :any_skip_relocation, ventura:       "933f5f45b545019bfd57dfce5519e066b1ef66d6bb65bd075eca393e36c41101"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fdb743e664e82047572bb24a3351aff65d0db0c6f862345da00669ecf110aac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fdb743e664e82047572bb24a3351aff65d0db0c6f862345da00669ecf110aac"
  end

  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "python@3.13"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/ee/be/29abccb5d9f61a92886a2fba2ac22bf74326b5c4f55d36d0a56094630589/argcomplete-3.6.0.tar.gz"
    sha256 "2e4e42ec0ba2fff54b0d244d0b1623e86057673e57bafe72dda59c64bd5dee8b"
  end

  resource "libarchive-c" do
    url "https://files.pythonhosted.org/packages/bc/0d/c45fe1307564cf550a407fca69cab3969a093d1d41bcd633b278440b4c30/libarchive_c-5.2.tar.gz"
    sha256 "fd44a8e28509af6e78262c98d1a54f306eabd2963dfee57bf298977de5057417"
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