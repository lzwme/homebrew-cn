class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/ab/f6/1680fea8bd91a2fb55fb2ec4c69fcd28ae816517d9c2ec48449c6c30315d/diffoscope-302.tar.gz"
  sha256 "7b5802d55a81dee59034d398cc6e0ee83b176281c1209d33df5bde29b586b328"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8124158af6fe8c269b9d580ea2afe2ce901f78446088e780ee2276416eda7795"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8124158af6fe8c269b9d580ea2afe2ce901f78446088e780ee2276416eda7795"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8124158af6fe8c269b9d580ea2afe2ce901f78446088e780ee2276416eda7795"
    sha256 cellar: :any_skip_relocation, sonoma:        "750ce4eed74f7c5c10ad7a54e8eaf2c59ad28e9897fba9f18de59838b8f08fa4"
    sha256 cellar: :any_skip_relocation, ventura:       "750ce4eed74f7c5c10ad7a54e8eaf2c59ad28e9897fba9f18de59838b8f08fa4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9887f871b731b049c816a6ecf184fab8caeb2beb907a38242e4989d42627b8a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9887f871b731b049c816a6ecf184fab8caeb2beb907a38242e4989d42627b8a1"
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