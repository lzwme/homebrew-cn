class Pipenv < Formula
  include Language::Python::Virtualenv

  desc "Python dependency management tool"
  homepage "https:github.compypapipenv"
  url "https:files.pythonhosted.orgpackages7af83ee7fc0120832780392f5cefa17c617764cf1416df812f3e696a02d8b122pipenv-2024.2.0.tar.gz"
  sha256 "7aafe2cf582b563c8ead5c7c6ecac1dcec490ab080efdcaf96b0e074c5cb7fa2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4cc701a0ea32925c8997845fc2bfaf4f191d696af48d9310e49140934ff7e8da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4cc701a0ea32925c8997845fc2bfaf4f191d696af48d9310e49140934ff7e8da"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4cc701a0ea32925c8997845fc2bfaf4f191d696af48d9310e49140934ff7e8da"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7646504566a5532a7e17f750d60d8ae367bf94774cb107e83863506e78c5585"
    sha256 cellar: :any_skip_relocation, ventura:       "d7646504566a5532a7e17f750d60d8ae367bf94774cb107e83863506e78c5585"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9cdbd91797b50551c23c8798354a4a5e03073283daac93116afaf6d901013744"
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
    url "https:files.pythonhosted.orgpackages0737b31be7e4b9f13b59cde9dcaeff112d401d49e0dc5b37ed4a9fc8fb12f409setuptools-75.2.0.tar.gz"
    sha256 "753bb6ebf1f465a1912e19ed1d41f403a79173a9acf66a42e7e6aec45c3c16ec"
  end

  resource "virtualenv" do
    url "https:files.pythonhosted.orgpackages107f192dd6ab6d91ebea7adf6c030eaf549b1ec0badda9f67a77b633602f66acvirtualenv-20.27.0.tar.gz"
    sha256 "2ca56a68ed615b8fe4326d11a0dca5dfbe8fd68510fb6c6349163bed3c15f2b2"
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