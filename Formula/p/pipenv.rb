class Pipenv < Formula
  include Language::Python::Virtualenv

  desc "Python dependency management tool"
  homepage "https:github.compypapipenv"
  url "https:files.pythonhosted.orgpackages6f026aa9fdde1a235bdf70395ac4d94127186398e6511722c4d5e0c600918a2epipenv-2023.12.0.tar.gz"
  sha256 "067b1c94a7807f424f63660be8b4c1886b6b9db99bd80d223794da273cc4589c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "57f2f391352d63d99d6ca6f071ce6d80d5418c740e68ba50d0787a4d3191dbf4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bcfdebc44d6fe9302ef8a29b1a7a0f5b50303465fc36eb66f9ef2338fc6bd704"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0f97c7073177b33ade4a7929715b1dc54fe5639d8a226565bce9f27ed007701"
    sha256 cellar: :any_skip_relocation, sonoma:         "63bf1a8f8542af86ced41dccce3ff74f8edb629ea466c7aec68681c29cb9de6c"
    sha256 cellar: :any_skip_relocation, ventura:        "29617816b59863a35d32001767fd04e32f8808908becd5ae84b697f601df6419"
    sha256 cellar: :any_skip_relocation, monterey:       "3dddcfcf6570204970efc1cbe3ceade11960026c2e24af5bc3c4ec3d97f0abdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d30d887d0b4eece012a4995026a25bb2f196cb7358d6b6deff0646086fe678e6"
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
    url "https:files.pythonhosted.orgpackages96dcc1d911bf5bb0fdc58cc05010e9f3efe3b67970cef779ba7fbc3183b987a8platformdirs-4.2.0.tar.gz"
    sha256 "ef0cc731df711022c174543cb70a9b5bd22e5a9337c8624ef2c2ceb8ddad8768"
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