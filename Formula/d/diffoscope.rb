class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/29/48/7ce3bb2998b6b04a6167e35753c5a6eb089c1f8f2d4602152ee014e859a7/diffoscope-255.tar.gz"
  sha256 "db03f02c9c2c178207dba9d2f9e8be25daf11770e7a87be008ff58a8adb7cd9e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d99d64796ae0991032f17617a8fd0fa83d95a7c420bfdc5aa77c55bff59dd8ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8750dd224d88493abd9c36c0ee691a8f64db3c4b12598c67a12a35152cdfc027"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e0d60e81f656b4973755247aef2d299f0e79427c99360f1ea095b87a34f1c3b"
    sha256 cellar: :any_skip_relocation, sonoma:         "921b2ee4cdf9b59619033d982f77c2120d40c975243be52f5d266bb2610b995e"
    sha256 cellar: :any_skip_relocation, ventura:        "096dbc29485e8a20485fb47d5c1398d01e386bbe414597f367a127c427f483cf"
    sha256 cellar: :any_skip_relocation, monterey:       "7a22c2955e03eec4205c9b82c46ee2ef922517f2ca541f1a84d395c7719d8f2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c1cd4346d5ade6e6c1e3f577dd54ad187b19525f2cc123af774e29f58e797bf"
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