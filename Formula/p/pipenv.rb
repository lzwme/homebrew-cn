class Pipenv < Formula
  include Language::Python::Virtualenv

  desc "Python dependency management tool"
  homepage "https:github.compypapipenv"
  url "https:files.pythonhosted.orgpackages7dce68f8b53ebd58fb895062384f1fa7820de24a6aaa4e6a701cdaca6acdfb11pipenv-2023.11.17.tar.gz"
  sha256 "408f2f1219e9bfe28f26a3511817e2a792eeafddc621f12a856fbd5ceca7bdf1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c6e70cc23f65a16be8ab8784ecd8758b4964463d26be4fbe18e00c95f727a265"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d47fdee4f700fb56f4c1814290846729aad893ed1cc0db9ff4493b47d5b67c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6a258cdbcbd6a6ad8e23e2225a31d6fe14ac0e15e970b645101a52dc9c1b378"
    sha256 cellar: :any_skip_relocation, sonoma:         "59efdfcd185f0768bd260b06234f19c5872bcea6bfc3b2b1480a8dec772b982b"
    sha256 cellar: :any_skip_relocation, ventura:        "fe716d98bec39e00ad407186ffc1c3e612199638c1b225fc5d7746d71bc028fb"
    sha256 cellar: :any_skip_relocation, monterey:       "01703b441ff8cbfe5b4baad8667fc2b18b46bcc011df67d1ea094d513f2829ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "531afd85d90adbd37551927ca7e7e494886ab1bbeb8ee840c9ba5f564153fea9"
  end

  depends_on "python-certifi"
  depends_on "python@3.12"
  depends_on "virtualenv"

  def python3
    "python3.12"
  end

  resource "distlib" do
    url "https:files.pythonhosted.orgpackagesc491e2df406fb4efacdf46871c25cde65d3c6ee5e173b7e5a4547a47bae91920distlib-0.3.8.tar.gz"
    sha256 "1530ea13e350031b6312d8580ddb6b27a104275a31106523b8f123787f494f64"
  end

  resource "filelock" do
    url "https:files.pythonhosted.orgpackages707041905c80dcfe71b22fb06827b8eae65781783d4a14194bce79d16a013263filelock-3.13.1.tar.gz"
    sha256 "521f5f56c50f8426f5e03ad3b281b490a87ef15bc6c526f168290f0c7148d44e"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackages62d17feaaacb1a3faeba96c06e6c5091f90695cc0f94b7e8e1a3a3fe2b33ff9aplatformdirs-4.1.0.tar.gz"
    sha256 "906d548203468492d432bcb294d4bc2fff751bf84971fbb2c10918cc206ee420"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackagesfcc9b146ca195403e0182a374e0ea4dbc69136bad3cd55bc293df496d625d0f7setuptools-69.0.3.tar.gz"
    sha256 "be1af57fc409f93647f2e8e4573a142ed38724b8cdd389706a867bb4efcf1e78"
  end

  resource "virtualenv" do
    url "https:files.pythonhosted.orgpackages94d7adb787076e65dc99ef057e0118e25becf80dd05233ef4c86f07aa35f6492virtualenv-20.25.0.tar.gz"
    sha256 "bf51c0d9c7dd63ea8e44086fa1e4fb1093a31e963b86959257378aef020e1f1b"
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
    system bin"pipenv", "--python", which(python3)
    system bin"pipenv", "install", "requests"
    system bin"pipenv", "install", "boto3"
    assert_predicate testpath"Pipfile", :exist?
    assert_predicate testpath"Pipfile.lock", :exist?
    assert_match "requests", (testpath"Pipfile").read
    assert_match "boto3", (testpath"Pipfile").read
  end
end