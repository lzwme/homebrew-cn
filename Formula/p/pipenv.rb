class Pipenv < Formula
  include Language::Python::Virtualenv

  desc "Python dependency management tool"
  homepage "https:github.compypapipenv"
  url "https:files.pythonhosted.orgpackages8d6cb349dc5b438c442a1c7a28d83e7008b8fd25e5e6d4fd8ac257b270a9ed60pipenv-2024.1.0.tar.gz"
  sha256 "422b09dc40798994a9641961983a1a4d1e831de8b91b2ad4d3d2ecb0ec42887c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eba3faaa31512e5c8259cbbdbfa30e2723fef523b6a7a2df965a653ef6e8e6c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eba3faaa31512e5c8259cbbdbfa30e2723fef523b6a7a2df965a653ef6e8e6c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eba3faaa31512e5c8259cbbdbfa30e2723fef523b6a7a2df965a653ef6e8e6c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f5bd8b6968909ef0e0550882a928a2971abbc9b192edff7af8b79a52145d7df"
    sha256 cellar: :any_skip_relocation, ventura:       "2f5bd8b6968909ef0e0550882a928a2971abbc9b192edff7af8b79a52145d7df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb0498334f994c5991c2c66d52de589cabbc480326776529e127f11427398096"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  resource "distlib" do
    url "https:files.pythonhosted.orgpackagesc491e2df406fb4efacdf46871c25cde65d3c6ee5e173b7e5a4547a47bae91920distlib-0.3.8.tar.gz"
    sha256 "1530ea13e350031b6312d8580ddb6b27a104275a31106523b8f123787f494f64"
  end

  resource "filelock" do
    url "https:files.pythonhosted.orgpackages9ddb3ef5bb276dae18d6ec2124224403d1d67bccdbefc17af4cc8f553e341ab1filelock-3.16.1.tar.gz"
    sha256 "c249fbfcd5db47e5e2d6d62198e565475ee65e4831e2561c8e313fa7eb961435"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackages516550db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackages13fc128cc9cb8f03208bdbf93d3aa862e16d376844a14f9a0ce5cf4507372de4platformdirs-4.3.6.tar.gz"
    sha256 "357fb2acbc885b0419afd3ce3ed34564c13c9b95c89360cd9563f73aa5e2b907"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages27b8f21073fde99492b33ca357876430822e4800cdf522011f18041351dfa74bsetuptools-75.1.0.tar.gz"
    sha256 "d59a21b17a275fb872a9c3dae73963160ae079f1049ed956880cd7c09b120538"
  end

  resource "virtualenv" do
    url "https:files.pythonhosted.orgpackages3f40abc5a766da6b0b2457f819feab8e9203cbeae29327bd241359f866a3da9dvirtualenv-20.26.6.tar.gz"
    sha256 "280aede09a2a5c317e409a00102e7077c6432c5a38f0ef938e643805a7ad2c48"
  end

  def install
    virtualenv_install_with_resources

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
    assert_match "Commands", shell_output(bin"pipenv")
    system bin"pipenv", "--python", which(python3)
    system bin"pipenv", "install", "requests"
    system bin"pipenv", "install", "boto3"
    assert_predicate testpath"Pipfile", :exist?
    assert_predicate testpath"Pipfile.lock", :exist?
    assert_match "requests", (testpath"Pipfile").read
    assert_match "boto3", (testpath"Pipfile").read
  end
end