class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/65/33/6b150dd23df29dadf21735cdd684fd0883d6c582be4263ebb825a53bfb3a/diffoscope-330.tar.gz"
  sha256 "92fb70b930077282ceaf104b4eb02c6368c860b0c89d6aab98f0a55682ee0361"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4db89aa9a96e233274ce8d35caa4dbda0b558e2d834d450e7c690388e6a5120f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4db89aa9a96e233274ce8d35caa4dbda0b558e2d834d450e7c690388e6a5120f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4db89aa9a96e233274ce8d35caa4dbda0b558e2d834d450e7c690388e6a5120f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "dfad5909980f049a6b6c0271b05ee5979e3ea910aeab2ecc66e3752d26cf56a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "dfad5909980f049a6b6c0271b05ee5979e3ea910aeab2ecc66e3752d26cf56a4"
  end

  depends_on "libarchive"
  depends_on "libmagic" => :no_linkage
  depends_on "python@3.14"

  pypi_packages package_name: "diffoscope[cmdline]"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/87/6f/5a73f04007ca950701765949209f068da628bd11f9c2da287278ce91e0ee/argcomplete-3.7.2.tar.gz"
    sha256 "aad8b69a0b9969edb62db0d1752354c0d50717b10e0cbb00e2a958381b9fc6b9"
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
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources
    venv.pip_install buildpath

    bin.install libexec/"bin/diffoscope"
    libarchive = formula_opt_lib("libarchive")/shared_library("libarchive")
    bin.env_script_all_files(libexec/"bin", LIBARCHIVE: libarchive)
  end

  test do
    (testpath/"test1").write "test"
    cp testpath/"test1", testpath/"test2"
    system bin/"diffoscope", "--progress", "test1", "test2"
  end
end