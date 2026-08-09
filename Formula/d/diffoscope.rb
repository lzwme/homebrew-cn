class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/85/6f/28628abde8d9113222efc515380b59ec5642afb19f081e09a1ec9cca36ef/diffoscope-327.tar.gz"
  sha256 "b5a398de17b180637cf091ba5c3c9fecde9dc8f5c2c80204ff8dd78e1b9d5358"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1cc875db141cd7e93375631bce3e07fd1e7351a12362419d735e607083506204"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1cc875db141cd7e93375631bce3e07fd1e7351a12362419d735e607083506204"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1cc875db141cd7e93375631bce3e07fd1e7351a12362419d735e607083506204"
    sha256 cellar: :any_skip_relocation, sonoma:        "6685200bdb14858a92c3f900bdf0c0c50c6a8ddf94ce90083f851bc93f8b97be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27032e4332a59b4883d4a6c45df441cd3184f353f35017930826fe1c9138bc2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27032e4332a59b4883d4a6c45df441cd3184f353f35017930826fe1c9138bc2a"
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
    venv = virtualenv_create(libexec, "python3.14")
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