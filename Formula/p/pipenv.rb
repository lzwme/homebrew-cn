class Pipenv < Formula
  include Language::Python::Virtualenv

  desc "Python dependency management tool"
  homepage "https://github.com/pypa/pipenv"
  url "https://files.pythonhosted.org/packages/1b/6d/b52ecc9cbc385f5e67d254803c1b0c1a4be6c64f9fe57e42905626231c2d/pipenv-2023.11.14.tar.gz"
  sha256 "f5a5894960e6c196acfaffdd1361ea0a1b2c1853758ce1920a2238aff3671b37"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ba3f04a567be245ed462f44d9186252637edfc595485167212aa83579faca250"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "110de9517beba448b25075160790476b07e0319464ac230c69de9eda4d47ecc1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "333d4ceae42ae1d79c3620a3a72cb7eebfe592e831788415342cc9382cf63c46"
    sha256 cellar: :any_skip_relocation, sonoma:         "c555fc660b9041df49ab6fb0ef83cfbc541d935ec7c38ed185e196962e52e5dd"
    sha256 cellar: :any_skip_relocation, ventura:        "673f0089fc82ec628228d89c456007563d73aaf5cd4fc67d747f2e0324eeb5ad"
    sha256 cellar: :any_skip_relocation, monterey:       "a8ddf209d4b16e7c6a2ea65d4e2879fcdb2f3f05740489c71a29e8c3d4f8b188"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbf55664576d43ca7b248a1a0f3b3ebfc6c81465c0ad0442f3dab6e1a4809cd9"
  end

  depends_on "python-certifi"
  depends_on "python@3.12"
  depends_on "virtualenv"

  def python3
    "python3.12"
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
    url "https://files.pythonhosted.org/packages/d3/e3/aa14d6b2c379fbb005993514988d956f1b9fdccd9cbe78ec0dbe5fb79bf5/platformdirs-3.11.0.tar.gz"
    sha256 "cf8ee52a3afdb965072dcc652433e0c7e3e40cf5ea1477cd4b3b1d2eb75495b3"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/8d/e9/f4550b3af1b5c71d42913430d325ca270ace65896bfd8ba04472566709cc/virtualenv-20.24.6.tar.gz"
    sha256 "02ece4f56fbf939dbbc33c0715159951d6bf14aaf5457b092e4548e1382455af"
  end

  def install
    virtualenv_install_with_resources

    site_packages = Language::Python.site_packages("python3.12")
    paths = %w[virtualenv].map { |p| Formula[p].opt_libexec/site_packages }
    (libexec/site_packages/"homebrew-deps.pth").write paths.join("\n")

    generate_completions_from_executable(libexec/"bin/pipenv", shells:                 [:fish, :zsh],
                                                               shell_parameter_format: :click)
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
    ENV["LC_ALL"] = "en_US.UTF-8"
    assert_match "Commands", shell_output("#{bin}/pipenv")
    system "#{bin}/pipenv", "--python", which(python3)
    system "#{bin}/pipenv", "install", "requests"
    system "#{bin}/pipenv", "install", "boto3"
    assert_predicate testpath/"Pipfile", :exist?
    assert_predicate testpath/"Pipfile.lock", :exist?
    assert_match "requests", (testpath/"Pipfile").read
    assert_match "boto3", (testpath/"Pipfile").read
  end
end