class Pipenv < Formula
  include Language::Python::Virtualenv

  desc "Python dependency management tool"
  homepage "https:github.compypapipenv"
  url "https:files.pythonhosted.orgpackagesf12a453a44f0c99ebd56ea041bb5063edf30edab0f2739d977b346c406ca20f5pipenv-2024.4.0.tar.gz"
  sha256 "87b82407a9e2de3cf32a742c131708d7460d5985076c6a9b3c11d774d2929fb1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ea25df0eb0ed154edd4cca9291882f7d1bb7d732adf033163f06d02d736e3be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ea25df0eb0ed154edd4cca9291882f7d1bb7d732adf033163f06d02d736e3be"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3ea25df0eb0ed154edd4cca9291882f7d1bb7d732adf033163f06d02d736e3be"
    sha256 cellar: :any_skip_relocation, sonoma:        "f395c4fca21ee6c7e6873a417f741438f273b275e9da0b6e05489c1c5ba5cba5"
    sha256 cellar: :any_skip_relocation, ventura:       "f395c4fca21ee6c7e6873a417f741438f273b275e9da0b6e05489c1c5ba5cba5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5847d7add40d9348e2db4f43152047782b7fe1f7fa46f2d639bc8c994a839a76"
  end

  depends_on "certifi"
  depends_on "python@3.13"

  def python3
    "python3.13"
  end

  resource "distlib" do
    url "https:files.pythonhosted.orgpackages0ddd1bec4c5ddb504ca60fc29472f3d27e8d4da1257a854e1d96742f15c1d02ddistlib-0.3.9.tar.gz"
    sha256 "a60f20dea646b8a33f3e7772f74dc0b2d0772d2837ee1342a00645c81edf9403"
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
    url "https:files.pythonhosted.orgpackagesed22a438e0caa4576f8c383fa4d35f1cc01655a46c75be358960d815bfbb12bdsetuptools-75.3.0.tar.gz"
    sha256 "fba5dd4d766e97be1b1681d98712680ae8f2f26d7881245f2ce9e40714f1a686"
  end

  resource "virtualenv" do
    url "https:files.pythonhosted.orgpackages8cb37b6a79c5c8cf6d90ea681310e169cf2db2884f4d583d16c6e1d5a75a4e04virtualenv-20.27.1.tar.gz"
    sha256 "142c6be10212543b32c6c45d3d3893dff89112cc588b7d0879ae5a1ec03a47ba"
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