class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/dd/da/208187b9a1df4a01f1d64aacdc353a07a8304b3b2cf7689938db5c191d35/diffoscope-296.tar.gz"
  sha256 "a1e9f43052a8b99984ba0bb13649ba0b18fd7da65a359e4f87170c89f8da325e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e55cf6c48fe2c3ef9815a063cdf36945a5cb65a9e7e19ee4fb1a72f7c8d636d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e55cf6c48fe2c3ef9815a063cdf36945a5cb65a9e7e19ee4fb1a72f7c8d636d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e55cf6c48fe2c3ef9815a063cdf36945a5cb65a9e7e19ee4fb1a72f7c8d636d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "38d1469eb00a9c6c11376818a33fb23ff6d5da6ef242ccab7974c97755b10977"
    sha256 cellar: :any_skip_relocation, ventura:       "38d1469eb00a9c6c11376818a33fb23ff6d5da6ef242ccab7974c97755b10977"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "593d4cd0ff8e19df25a548015c3d68b810774fded6bd685633f76da14eb78e7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "593d4cd0ff8e19df25a548015c3d68b810774fded6bd685633f76da14eb78e7a"
  end

  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "python@3.13"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/16/0f/861e168fc813c56a78b35f3c30d91c6757d1fd185af1110f1aec784b35d0/argcomplete-3.6.2.tar.gz"
    sha256 "d0519b1bc867f5f4f4713c41ad0aba73a4a5f007449716b16f385f2166dc6adf"
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