class Tox < Formula
  include Language::Python::Virtualenv

  desc "Generic Python virtualenv management and test command-line tool"
  homepage "https://tox.wiki/en/latest/"
  url "https://files.pythonhosted.org/packages/d7/75/02b8654c1150a05f4f3967e470b459b07937cba862d698d5b02765f971cc/tox-4.4.6.tar.gz"
  sha256 "9786671d23b673ace7499c602c5746e2a225d1ecd9d9f624d0461303f40bd93b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "610f471144ec447e853b2801f0929e008f00ea4ec0dbb168501ef2e7e604d9a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "799f2b5b16c122bb0ffef64fd68253e128717fdba3d4296d7d5e5d8d667bac0a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8570b52ae4c015f200660f09d14c6118df10dc341de4a46d47dec193477c01cc"
    sha256 cellar: :any_skip_relocation, ventura:        "4b0a03861aa3477d870bd4b0a9aae7a83773169f95cdcc80f5fde9fcecf0d583"
    sha256 cellar: :any_skip_relocation, monterey:       "82818eaa58ed16e1c825d75551a0eb6c07d08a7f4ce7699bccef29fa7029e1c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "c1b41382d32cf71a2ea3da5272416b88edf5ea5c7e33bb1e0f421a609b6227ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40cc0e44351dac50a7ca1330788470524068d0c8ee3dff3bd5c8d75ce97310ab"
  end

  depends_on "python@3.11"

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/4d/91/5837e9f9e77342bb4f3ffac19ba216eef2cd9b77d67456af420e7bafe51d/cachetools-5.3.0.tar.gz"
    sha256 "13dfddc7b8df938c21a940dfa6557ce6e94a2f1cdfa58eb90c805721d58f2c14"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/41/32/cdc91dcf83849c7385bf8e2a5693d87376536ed000807fa07f5eab33430d/chardet-5.1.0.tar.gz"
    sha256 "0d62712b956bc154f85fb0a266e2a3c5913c2967e00348701b32411d6def31e5"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/58/07/815476ae605bcc5f95c87a62b95e74a1bce0878bc7a3119bc2bf4178f175/distlib-0.3.6.tar.gz"
    sha256 "14bad2d9b04d3a36127ac97f30b12a19268f211063d8f8ee4f47108896e11b46"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/0b/dc/eac02350f06c6ed78a655ceb04047df01b02c6b7ea3fc02d4df24ca87d24/filelock-3.9.0.tar.gz"
    sha256 "7b319f24340b51f55a2bf7a12ac0755a9b03e718311dac567a0f4f7fabd2f5de"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/47/d5/aca8ff6f49aa5565df1c826e7bf5e85a6df852ee063600c1efa5b932968c/packaging-23.0.tar.gz"
    sha256 "b6ad297f8907de0fa2fe1ccbd26fdaf387f5f47c7275fedf8cce89f99446cf97"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/11/39/702094fc1434a4408783b071665d9f5d8a1d0ba4dddf9dadf3d50e6eb762/platformdirs-3.0.0.tar.gz"
    sha256 "8a1228abb1ef82d788f74139988b137e78692984ec7b08eaa6c65f1723af28f9"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/a1/16/db2d7de3474b6e37cbb9c008965ee63835bba517e22cdb8c35b5116b5ce1/pluggy-1.0.0.tar.gz"
    sha256 "4224373bacce55f955a878bf9cfa763c1e360858e330072059e10bad68531159"
  end

  resource "pyproject-api" do
    url "https://files.pythonhosted.org/packages/86/92/a63e1fd25adfde23f21d87676a4dc39fb969d2979c60aac9d7b3425d6223/pyproject_api-1.5.0.tar.gz"
    sha256 "0962df21f3e633b8ddb9567c011e6c1b3dcdfc31b7860c0ede7e24c5a1200fbe"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/3d/ad/906d59bbcb0e6178989cee52166a8a6651ddaea18b38e728eaac22e61cad/virtualenv-20.19.0.tar.gz"
    sha256 "37a640ba82ed40b226599c522d411e4be5edb339a0c0de030c0dc7b646d61590"
  end

  def install
    virtualenv_install_with_resources
  end

  # Avoid relative paths
  def post_install
    lib_python_path = Pathname.glob(libexec/"lib/python*").first
    lib_python_path.each_child do |f|
      next unless f.symlink?

      realpath = f.realpath
      rm f
      ln_s realpath, f
    end
  end

  test do
    assert_match "usage", shell_output("#{bin}/tox --help")
    system bin/"tox"
    pyver = Language::Python.major_minor_version(Formula["python@3.11"].opt_bin/"python3.11").to_s.delete(".")

    system bin/"tox", "quickstart", "src"
    (testpath/"src/test_trivial.py").write <<~EOS
      def test_trivial():
          assert True
    EOS
    chdir "src" do
      system bin/"tox", "run"
    end
    assert_predicate testpath/"src/.tox/py#{pyver}", :exist?
  end
end