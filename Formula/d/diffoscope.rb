class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/23/66/33c502a4a24ed94a676f6220225fe8da102bfc2c87d212d344de0f1eadde/diffoscope-326.tar.gz"
  sha256 "21aaa977a9fbdf6e2b70b675a700ad1f80e878ac1dac59cf6fb0ba5f319616c7"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "878f7b2e38ae2c9fc3cf8278a691bc203a644fafe91b5e52d51595b0ab419f7a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "878f7b2e38ae2c9fc3cf8278a691bc203a644fafe91b5e52d51595b0ab419f7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "878f7b2e38ae2c9fc3cf8278a691bc203a644fafe91b5e52d51595b0ab419f7a"
    sha256 cellar: :any_skip_relocation, sonoma:        "18907f3831817cb350605720381d2deb7fcf6d46a7d5d329a528ae978085186d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fa665d7fabca886234ac3142a393c8094cb81100a2d8fdb712d0b7d683c3a4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fa665d7fabca886234ac3142a393c8094cb81100a2d8fdb712d0b7d683c3a4f"
  end

  depends_on "libarchive"
  depends_on "libmagic" => :no_linkage
  depends_on "python@3.14"

  pypi_packages package_name: "diffoscope[cmdline]"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/95/c0/c8e94135e66fabf89a120d9b4b123fe6993506beca6c1938a74c24cfa5fd/argcomplete-3.7.0.tar.gz"
    sha256 "afde224f753f874807b1dc1414e883ab8fe0cda9c04807b6047dcb8e1ac23913"
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