class Pipenv < Formula
  include Language::Python::Virtualenv

  desc "Python dependency management tool"
  homepage "https://github.com/pypa/pipenv"
  url "https://files.pythonhosted.org/packages/51/5d/023a47dc5971f8d29d7436dbde97be63c92b9b2149dcd00cacf71a3ebda9/pipenv-2026.10.4.tar.gz"
  sha256 "8a4ea0e0dda9e1e26aff8a960b5603229bd662ecf72562fb5f9859a596370238"
  license "MIT"
  head "https://github.com/pypa/pipenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d8276f23baee99f8da066096306e3cf12d6e754e63465b80d20ba7c8ce0dd9c6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d8276f23baee99f8da066096306e3cf12d6e754e63465b80d20ba7c8ce0dd9c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d8276f23baee99f8da066096306e3cf12d6e754e63465b80d20ba7c8ce0dd9c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "91d0f07f1c8365b6fddaaa3969bace83e0f2f523055e769d1b3acacbd105cd34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "91d0f07f1c8365b6fddaaa3969bace83e0f2f523055e769d1b3acacbd105cd34"
  end

  depends_on "certifi" => :no_linkage
  depends_on "python@3.15"

  pypi_packages package_name:     "pipenv[completion]",
                exclude_packages: "certifi"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/87/6f/5a73f04007ca950701765949209f068da628bd11f9c2da287278ce91e0ee/argcomplete-3.7.2.tar.gz"
    sha256 "aad8b69a0b9969edb62db0d1752354c0d50717b10e0cbb00e2a958381b9fc6b9"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/68/bc/d36966de7304047a1001a7559fbf266c464bb5d8cc85464536ef8c9bcc32/distlib-0.4.4.tar.gz"
    sha256 "ca4175b4ac7f71223cc30ed7248c45d2b38c2439d8ee6e498ab67ed63cf3508d"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/d8/28/3893324bcadf8f89b1616637468d766af3f625008c0735bf704fdfa86617/filelock-4.2.4.tar.gz"
    sha256 "c6d8663535e1650ee430507b4ffbac7b464dd64b7647ea0112a9f406499d163d"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/40/28/1c058a9143d2304b3078f8dadcbb9dc27f7d3581b5d05157c84869c4cc0d/platformdirs-4.14.0.tar.gz"
    sha256 "83f009c1e8c5fc36869b5171755b291887bd2cade7965233cdfabd23d754720b"
  end

  resource "python-discovery" do
    url "https://files.pythonhosted.org/packages/a3/0b/908da9ef8a14b600fc188eee8d63ede071996114613721153f6fc9ea3cd5/python_discovery-1.6.7.tar.gz"
    sha256 "7f7c28568c8ec3d988d8bddbdbec8e65f08e8767e52f734e18b8b498549b9b70"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/70/b3/c19426f783614d625699a4b247faf628ea9ab1db228674491767b417f9e1/setuptools-84.2.1.tar.gz"
    sha256 "3ff8b3b5492a0aa66960f4419365a86b84e013070d4313e4d4a6894f5d64d6bc"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/b2/24/20282bc8e69ff8dee680dc2b95e9dc81fa7e7894b14c1a8d06330e97fef7/virtualenv-21.15.1.tar.gz"
    sha256 "e79c90b8f601701599c25905e02839924fede2c798d52325670d24fbdaab74ee"
  end

  def install
    venv = virtualenv_install_with_resources

    generate_completions_from_executable(libexec/"bin/register-python-argcomplete", "pipenv", "--shell")

    # Build an `:all` bottle by replacing comments
    file = venv.site_packages.glob("argcomplete-*.dist-info/METADATA")
    inreplace file, "/opt/homebrew/bin/bash", "$HOMEBREW_PREFIX/bin/bash"
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    system bin/"pipenv", "--python", python3
    system bin/"pipenv", "install", "requests"
    system bin/"pipenv", "install", "boto3"
    assert_path_exists testpath/"Pipfile"
    assert_path_exists testpath/"Pipfile.lock"
    assert_match "requests", (testpath/"Pipfile").read
    assert_match "boto3", (testpath/"Pipfile").read
  end
end