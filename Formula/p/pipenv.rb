class Pipenv < Formula
  include Language::Python::Virtualenv

  desc "Python dependency management tool"
  homepage "https://github.com/pypa/pipenv"
  url "https://files.pythonhosted.org/packages/b6/67/fdc44f47b4fc9d99729c0e6588407642a4e8ec0d7522736cfe29fea4ebdf/pipenv-2026.5.0.tar.gz"
  sha256 "5402ac5fb1dae2c3d89e504496502da21fa38ff7c293b2e289a809e2f77b036e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "960486cfef9ab3cee301a63918251d101c45c00e600004675df8f8ba99234331"
  end

  depends_on "certifi" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  def python3
    "python3.14"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/96/8e/709914eb2b5749865801041647dc7f4e6d00b549cfe88b65ca192995f07c/distlib-0.4.0.tar.gz"
    sha256 "feec40075be03a04501a973d81f633735b4b69f98b05450592310c0f401a4e0d"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/94/b8/00651a0f559862f3bb7d6f7477b192afe3f583cc5e26403b44e59a55ab34/filelock-3.25.2.tar.gz"
    sha256 "b64ece2b38f4ca29dd3e810287aa8c48182bbecd1ae6e9ae126c9b35f1382694"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/65/ee/299d360cdc32edc7d2cf530f3accf79c4fca01e96ffc950d8a52213bd8e4/packaging-26.0.tar.gz"
    sha256 "00243ae351a257117b6a241061796684b084ed1c516a08c48a3f7e147a9d80b4"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/19/56/8d4c30c8a1d07013911a8fdbd8f89440ef9f08d07a1b50ab8ca8be5a20f9/platformdirs-4.9.4.tar.gz"
    sha256 "1ec356301b7dc906d83f371c8f487070e99d3ccf9e501686456394622a01a934"
  end

  resource "python-discovery" do
    url "https://files.pythonhosted.org/packages/b9/88/815e53084c5079a59df912825a279f41dd2e0df82281770eadc732f5352c/python_discovery-1.2.1.tar.gz"
    sha256 "180c4d114bff1c32462537eac5d6a332b768242b76b69c0259c7d14b1b680c9e"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/4f/db/cfac1baf10650ab4d1c111714410d2fbb77ac5a616db26775db562c8fab2/setuptools-82.0.1.tar.gz"
    sha256 "7d872682c5d01cfde07da7bccc7b65469d3dca203318515ada1de5eda35efbf9"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/aa/92/58199fe10049f9703c2666e809c4f686c54ef0a68b0f6afccf518c0b1eb9/virtualenv-21.2.0.tar.gz"
    sha256 "1720dc3a62ef5b443092e3f499228599045d7fea4c79199770499df8becf9098"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(libexec/"bin/pipenv", shell_parameter_format: :click)
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
    system bin/"pipenv", "--python", which(python3)
    system bin/"pipenv", "install", "requests"
    system bin/"pipenv", "install", "boto3"
    assert_path_exists testpath/"Pipfile"
    assert_path_exists testpath/"Pipfile.lock"
    assert_match "requests", (testpath/"Pipfile").read
    assert_match "boto3", (testpath/"Pipfile").read
  end
end