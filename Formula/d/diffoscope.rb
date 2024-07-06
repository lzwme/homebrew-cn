class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/1d/27/44077444f88a0bfe6129bf48041f55ad837735a7fa0b7f1847361c094d5f/diffoscope-272.tar.gz"
  sha256 "f8983580efb8f4644719705590a43817d1159d4136836d7ce6dd4fec754c3943"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2285cc7dbebb46a203d7f0fa168c058d1306fdfb3fc03171ff3e60c94b3c7553"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2285cc7dbebb46a203d7f0fa168c058d1306fdfb3fc03171ff3e60c94b3c7553"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2285cc7dbebb46a203d7f0fa168c058d1306fdfb3fc03171ff3e60c94b3c7553"
    sha256 cellar: :any_skip_relocation, sonoma:         "3e983a85e3796a64a9d2816f54230e4e6de96e8da0f286ed32f5ecca1abdbf8f"
    sha256 cellar: :any_skip_relocation, ventura:        "3e983a85e3796a64a9d2816f54230e4e6de96e8da0f286ed32f5ecca1abdbf8f"
    sha256 cellar: :any_skip_relocation, monterey:       "3e983a85e3796a64a9d2816f54230e4e6de96e8da0f286ed32f5ecca1abdbf8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16258b5ef48497f6a3c0b79f7b0bcdd822a684845486c7b231e46197163ca303"
  end

  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "python@3.12"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/db/ca/45176b8362eb06b68f946c2bf1184b92fc98d739a3f8c790999a257db91f/argcomplete-3.4.0.tar.gz"
    sha256 "c2abcdfe1be8ace47ba777d4fce319eb13bf8ad9dace8d085dcad6eded88057f"
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