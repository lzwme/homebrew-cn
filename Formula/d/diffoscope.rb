class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/1e/01/d3167b950a7176052b56bc0453bd4f15b80096e5d250f00b15904ca5ed11/diffoscope-268.tar.gz"
  sha256 "6d4105eae8c3b1f03a4a211bbc495689f45934241f0257744fee666ddc2691f9"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a05dfcc8f40cdcf121c355e73ba5da82d8523f9182d370759665c4bf06796115"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da8948c628e546ddb0ef96d0f9d57ed49de4c908f7a00697d80b4c8490802ae2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a208f0126dc8ec877c04c1ff4056ee81a88d46cc163f259bc73b2da748747222"
    sha256 cellar: :any_skip_relocation, sonoma:         "ef51b6b4d72c2ebc5fac85154eed6a3e55cd5ad29be7d47516ab43d7dcd3a5de"
    sha256 cellar: :any_skip_relocation, ventura:        "832481a2860b20340be6110b70747960cc2acbd97ae19096102bb3abdbcf8f19"
    sha256 cellar: :any_skip_relocation, monterey:       "028f765a3fc70f2e4c08abfe5410b87c88bf31c2fd03bffefc4380131b476d64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2431e2905a00c2685b9a3d54485ad33cf36d18a1adb0e9b44962a540f4d9131e"
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