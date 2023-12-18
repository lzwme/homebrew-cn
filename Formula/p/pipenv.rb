class Pipenv < Formula
  include Language::Python::Virtualenv

  desc "Python dependency management tool"
  homepage "https:github.compypapipenv"
  url "https:files.pythonhosted.orgpackages081ed8e3b937de28491a887683600d6496b05c10a5e0693ec703f3c89638ea66pipenv-2023.11.15.tar.gz"
  sha256 "f587ffff47e8aa76f17803d571f64cf5a24b2bdfb9334435e6528b22ad5e304f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "055d602a93b4b3490f8514660b900192b5e5be491415e072b1f5f29f14310026"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dbb0534c483c8dd03315e68a21d905737116d5d63b6f63e0a057b1fd8e76effe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "743092a7873f15087d0034ce0be4f832b14e235c6a97a1c8f32ee487bd95385c"
    sha256 cellar: :any_skip_relocation, sonoma:         "97d805ed42e0caca315b5e777e5c719dfffca438aca3f23f9ed3bbe94c58f1df"
    sha256 cellar: :any_skip_relocation, ventura:        "8adf4d38d542dee41ba5714fbcc540dbe68b15472dbba43983303cf197f9e4b1"
    sha256 cellar: :any_skip_relocation, monterey:       "9a88861ae90216936a690728fd3a01a432820830078b0cd9cc39fc7e512470cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b4de6cd0aa4d05694581293540994e1cbc5fdcedd7464dc6247bb0babcd3f9c"
  end

  depends_on "python-certifi"
  depends_on "python@3.12"
  depends_on "virtualenv"

  def python3
    "python3.12"
  end

  resource "distlib" do
    url "https:files.pythonhosted.orgpackages293463be59bdf57b3a8a8dcc252ef45c40f3c018777dc8843d45dd9b869868f0distlib-0.3.7.tar.gz"
    sha256 "9dafe54b34a028eafd95039d5e5d4851a13734540f1331060d31c9916e7147a8"
  end

  resource "filelock" do
    url "https:files.pythonhosted.orgpackages707041905c80dcfe71b22fb06827b8eae65781783d4a14194bce79d16a013263filelock-3.13.1.tar.gz"
    sha256 "521f5f56c50f8426f5e03ad3b281b490a87ef15bc6c526f168290f0c7148d44e"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackagesd3e3aa14d6b2c379fbb005993514988d956f1b9fdccd9cbe78ec0dbe5fb79bf5platformdirs-3.11.0.tar.gz"
    sha256 "cf8ee52a3afdb965072dcc652433e0c7e3e40cf5ea1477cd4b3b1d2eb75495b3"
  end

  resource "virtualenv" do
    url "https:files.pythonhosted.orgpackages8de9f4550b3af1b5c71d42913430d325ca270ace65896bfd8ba04472566709ccvirtualenv-20.24.6.tar.gz"
    sha256 "02ece4f56fbf939dbbc33c0715159951d6bf14aaf5457b092e4548e1382455af"
  end

  def install
    virtualenv_install_with_resources

    site_packages = Language::Python.site_packages("python3.12")
    paths = %w[virtualenv].map { |p| Formula[p].opt_libexecsite_packages }
    (libexecsite_packages"homebrew-deps.pth").write paths.join("\n")

    generate_completions_from_executable(libexec"binpipenv", shells:                 [:fish, :zsh],
                                                               shell_parameter_format: :click)
  end

  # Avoid relative paths
  def post_install
    lib_python_path = Pathname.glob(libexec"libpython*").first
    lib_python_path.each_child do |f|
      next unless f.symlink?

      realpath = f.realpath
      rm f
      ln_s realpath, f
    end
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    assert_match "Commands", shell_output("#{bin}pipenv")
    system "#{bin}pipenv", "--python", which(python3)
    system "#{bin}pipenv", "install", "requests"
    system "#{bin}pipenv", "install", "boto3"
    assert_predicate testpath"Pipfile", :exist?
    assert_predicate testpath"Pipfile.lock", :exist?
    assert_match "requests", (testpath"Pipfile").read
    assert_match "boto3", (testpath"Pipfile").read
  end
end