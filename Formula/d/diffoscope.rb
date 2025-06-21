class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/ff/cb/b3046862f1a61cf4e8c744896be8c213ed7ad9caaeeda478d69f77978cf2/diffoscope-299.tar.gz"
  sha256 "f40492b926e8ef38ba51bdda0bf0a350ad9f99b35db73506ee63f7be7a8e0465"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebbe9b795e329a019b7d3de4a6677ada18dc10cd8fab6f7b8479533d39b8a605"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ebbe9b795e329a019b7d3de4a6677ada18dc10cd8fab6f7b8479533d39b8a605"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ebbe9b795e329a019b7d3de4a6677ada18dc10cd8fab6f7b8479533d39b8a605"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3c786bf57c3fc005d48393448d1d71a818d10fdc5b6053d542578b5ea90f60c"
    sha256 cellar: :any_skip_relocation, ventura:       "f3c786bf57c3fc005d48393448d1d71a818d10fdc5b6053d542578b5ea90f60c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4332809b3c7522b2e6e1f5d4f738da10a2920cc9f43e32d65ee2d25b733eb42a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4332809b3c7522b2e6e1f5d4f738da10a2920cc9f43e32d65ee2d25b733eb42a"
  end

  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "python@3.13"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/16/0f/861e168fc813c56a78b35f3c30d91c6757d1fd185af1110f1aec784b35d0/argcomplete-3.6.2.tar.gz"
    sha256 "d0519b1bc867f5f4f4713c41ad0aba73a4a5f007449716b16f385f2166dc6adf"
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