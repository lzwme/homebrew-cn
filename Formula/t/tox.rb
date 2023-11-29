class Tox < Formula
  include Language::Python::Virtualenv

  desc "Generic Python virtualenv management and test command-line tool"
  homepage "https://tox.wiki/en/latest/"
  url "https://files.pythonhosted.org/packages/1a/78/e9672163a341a557b6fb9f6723c771835c763c0de2bccc9f4abc29e0a4a2/tox-4.11.4.tar.gz"
  sha256 "73a7240778fabf305aeb05ab8ea26e575e042ab5a18d71d0ed13e343a51d6ce1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6fea36d5a677bb7e4b050497a3a42eea3bc0d2fddc201cd9e6b059ab2a42c174"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "20ca2ab4be288070f183d67c47c1f58bd090dab7fe56077510cf05eed75358e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "586d3f704218ace8496a3746e305136fb438eaa6160bb776597ee38c4c167af6"
    sha256 cellar: :any_skip_relocation, sonoma:         "553e20153b435ad357488edc3024a9d18a906e7d692bd0016c523187deabbb93"
    sha256 cellar: :any_skip_relocation, ventura:        "26417b21750f7fc4b4761813d197bad1029647bd4c75b8e42287f31ef2f624b8"
    sha256 cellar: :any_skip_relocation, monterey:       "daed1ed6e7a0ce8fd957c810440543c1205994b01f1a9f3ecf65a520e6d647b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81ce3f5f7f4460a70a14d4cc988423d17281a8e304ea714c597e78ca4e8179d4"
  end

  depends_on "python-packaging"
  depends_on "python@3.12"
  depends_on "virtualenv"

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/10/21/1b6880557742c49d5b0c4dcf0cf544b441509246cdd71182e0847ac859d5/cachetools-5.3.2.tar.gz"
    sha256 "086ee420196f7b2ab9ca2db2520aca326318b68fe5ba8bc4d49cca91add450f2"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/29/34/63be59bdf57b3a8a8dcc252ef45c40f3c018777dc8843d45dd9b869868f0/distlib-0.3.7.tar.gz"
    sha256 "9dafe54b34a028eafd95039d5e5d4851a13734540f1331060d31c9916e7147a8"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/70/70/41905c80dcfe71b22fb06827b8eae65781783d4a14194bce79d16a013263/filelock-3.13.1.tar.gz"
    sha256 "521f5f56c50f8426f5e03ad3b281b490a87ef15bc6c526f168290f0c7148d44e"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/31/28/e40d24d2e2eb23135f8533ad33d582359c7825623b1e022f9d460def7c05/platformdirs-4.0.0.tar.gz"
    sha256 "cb633b2bcf10c51af60beb0ab06d2f1d69064b43abf4c185ca6b28865f3f9731"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/36/51/04defc761583568cae5fd533abda3d40164cbdcf22dee5b7126ffef68a40/pluggy-1.3.0.tar.gz"
    sha256 "cf61ae8f126ac6f7c451172cf30e3e43d3ca77615509771b3a984a0730651e12"
  end

  resource "pyproject-api" do
    url "https://files.pythonhosted.org/packages/1b/c6/b39e42e1d721dcb35be6a7d35157795398193ec0b78a034c110bd0ab3e48/pyproject_api-1.6.1.tar.gz"
    sha256 "1817dc018adc0d1ff9ca1ed8c60e1623d5aaca40814b953af14a9cf9a5cae538"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/ac/fe/028d5b32d0a54fe3ecac1c170966757f185f84b81e06af98c820a546c691/virtualenv-20.24.7.tar.gz"
    sha256 "69050ffb42419c91f6c1284a7b24e0475d793447e35929b488bf6a0aade39353"
  end

  def install
    virtualenv_install_with_resources

    site_packages = Language::Python.site_packages("python3.12")
    paths = %w[virtualenv].map { |p| Formula[p].opt_libexec/site_packages }
    (libexec/site_packages/"homebrew-deps.pth").write paths.join("\n")
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
    pyver = Language::Python.major_minor_version(Formula["python@3.12"].opt_bin/"python3.12").to_s.delete(".")

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