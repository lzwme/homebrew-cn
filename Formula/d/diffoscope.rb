class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/dd/a0/9394868fb75e5ce6dc3cbc06255ad74a97c3960ba1debc8f6bd6128d1948/diffoscope-313.tar.gz"
  sha256 "f2f3ca5f1a933e21155c3c96ef1b5c50233dd24f080c05d3fc1d4283e652f7fd"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b2f21ff6e40acace2d12551881e3f1b2a445f561d9ce784b2cb05f95fb1925c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b2f21ff6e40acace2d12551881e3f1b2a445f561d9ce784b2cb05f95fb1925c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b2f21ff6e40acace2d12551881e3f1b2a445f561d9ce784b2cb05f95fb1925c"
    sha256 cellar: :any_skip_relocation, sonoma:        "fdcf4fe046541d5efd69fa652dcdf3487ff107f42b0e1024513392a7dc0edf9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04e58e49d9be55bf4bbde14a9587dfffa149a3d46b250d2aee0ae6afe0a30c51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04e58e49d9be55bf4bbde14a9587dfffa149a3d46b250d2aee0ae6afe0a30c51"
  end

  depends_on "libarchive"
  depends_on "libmagic" => :no_linkage
  depends_on "python@3.14"

  # pypi_packages package_name: "diffoscope[cmdline]"
  pypi_packages extra_packages: %w[argcomplete progressbar]

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/38/61/0b9ae6399dd4a58d8c1b1dc5a27d6f2808023d0b5dd3104bb99f45a33ff6/argcomplete-3.6.3.tar.gz"
    sha256 "62e8ed4fd6a45864acc8235409461b72c9a28ee785a2011cc5eb78318786c89c"
  end

  resource "libarchive-c" do
    url "https://files.pythonhosted.org/packages/26/23/e72434d5457c24113e0c22605cbf7dd806a2561294a335047f5aa8ddc1ca/libarchive_c-5.3.tar.gz"
    sha256 "5ddb42f1a245c927e7686545da77159859d5d4c6d00163c59daff4df314dae82"
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
    venv = virtualenv_create(libexec, "python3.14")
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