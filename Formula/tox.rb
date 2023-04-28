class Tox < Formula
  include Language::Python::Virtualenv

  desc "Generic Python virtualenv management and test command-line tool"
  homepage "https://tox.wiki/en/latest/"
  url "https://files.pythonhosted.org/packages/1a/d0/db430b1b14724899f96cd832d71ae98de72bbe839b00d4537941807faac1/tox-4.5.1.tar.gz"
  sha256 "5a2eac5fb816779dfdf5cb00fecbc27eb0524e4626626bb1de84747b24cacc56"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e97085764faa53483764f1d44ccb92f610cb0457716e6c9c9294023ab5b7e8e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eea90014a6e2c90ff756848906ef785d9366b76102a34d5af5937aeba3a04426"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a0992596dc9e9a3ed037bc7b82ab252245cfe6b03484fbe6eba7e1cbc369c3ff"
    sha256 cellar: :any_skip_relocation, ventura:        "d3fbf7f153765b2694a5d8a8f113e228a2892e53d378bdc6f4341bdc12f1cc94"
    sha256 cellar: :any_skip_relocation, monterey:       "e8d40abd4b8021b6bd74c70009d281c96b79bf9c888633fee3d5b662937bbc6b"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6e034d4f9d0b97189dd37d90d36904ee7cf39b8482a08b9abc27c004ce9d375"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97e43111b953cacac3c5ddbdc4fe020560ed200e69f4e7595ee1de0f21d6caa2"
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
    url "https://files.pythonhosted.org/packages/24/85/cf4df939cc0a037ebfe18353005e775916faec24dcdbc7a2f6539ad9d943/filelock-3.12.0.tar.gz"
    sha256 "fc03ae43288c013d2ea83c8597001b1129db351aad9c57fe2409327916b8e718"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/5e/ac/26d3d2a99b5fc84852229fc8470ae612595900f7f52c78468fd3f3a15a27/platformdirs-3.4.0.tar.gz"
    sha256 "a5e1536e5ea4b1c238a1364da17ff2993d5bd28e15600c2c8224008aff6bbcad"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/a1/16/db2d7de3474b6e37cbb9c008965ee63835bba517e22cdb8c35b5116b5ce1/pluggy-1.0.0.tar.gz"
    sha256 "4224373bacce55f955a878bf9cfa763c1e360858e330072059e10bad68531159"
  end

  resource "pyproject-api" do
    url "https://files.pythonhosted.org/packages/23/6f/d02d1cab4a30998806687036e03ffecbf66e35df6bfab5a29f22ec61a075/pyproject_api-1.5.1.tar.gz"
    sha256 "435f46547a9ff22cf4208ee274fca3e2869aeb062a4834adfc99a4dd64af3cf9"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/12/c5/9e9c1dca8838e1eca43b23e5d8a34a6ad5065f15d702ee703c91b7e64b79/virtualenv-20.22.0.tar.gz"
    sha256 "278753c47aaef1a0f14e6db8a4c5e1e040e90aea654d0fc1dc7e0d8a42616cc3"
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