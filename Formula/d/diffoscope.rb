class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/0a/48/96d106a6b6bc567da8fdf43a6949aef1c90932a526193031c96c8fd786b9/diffoscope-293.tar.gz"
  sha256 "15315d09babdee45449be7042ad1f57104a5f04853bd6951cdc0da171c13ac3b"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75345e8e2520cd505e8deeff49828bbbe0c5830e1ee737fb5f59249f0f547711"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75345e8e2520cd505e8deeff49828bbbe0c5830e1ee737fb5f59249f0f547711"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "75345e8e2520cd505e8deeff49828bbbe0c5830e1ee737fb5f59249f0f547711"
    sha256 cellar: :any_skip_relocation, sonoma:        "fae709eec7ccd30101a71e1e93b4d3ebb16dff784d23b36da1da503759d0a218"
    sha256 cellar: :any_skip_relocation, ventura:       "fae709eec7ccd30101a71e1e93b4d3ebb16dff784d23b36da1da503759d0a218"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b756d617cb981c6a8f1c43090fce21c96e7821fd347a600f3012514927bebfcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b756d617cb981c6a8f1c43090fce21c96e7821fd347a600f3012514927bebfcf"
  end

  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "python@3.13"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/0a/35/aacd2207c79d95e4ace44292feedff8fccfd8b48135f42d84893c24cc39b/argcomplete-3.6.1.tar.gz"
    sha256 "927531c2fbaa004979f18c2316f6ffadcfc5cc2de15ae2624dfe65deaf60e14f"
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