class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/2d/74/503aad308b7e80e151063d5a254f35e8cfd821627d5aa900a882fcddc967/diffoscope-303.tar.gz"
  sha256 "eb68c3708df66e314c072724a12fc8180df28d626320178b3c9ac6029f3436bb"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bbc448010bb66337d9f816724d2e6d77ad04554c415fc85377df9c1c0e4e32dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bbc448010bb66337d9f816724d2e6d77ad04554c415fc85377df9c1c0e4e32dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bbc448010bb66337d9f816724d2e6d77ad04554c415fc85377df9c1c0e4e32dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef6a73e5550f262fa34df1cbd69b81c98215d617163c789619410238be64d07e"
    sha256 cellar: :any_skip_relocation, ventura:       "ef6a73e5550f262fa34df1cbd69b81c98215d617163c789619410238be64d07e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ead376ca5f112422ce87d9a878bc3f1da9c8b888bdc3b5658755e6ac38840dec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ead376ca5f112422ce87d9a878bc3f1da9c8b888bdc3b5658755e6ac38840dec"
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