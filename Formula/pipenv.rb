class Pipenv < Formula
  include Language::Python::Virtualenv

  desc "Python dependency management tool"
  homepage "https://github.com/pypa/pipenv"
  url "https://files.pythonhosted.org/packages/6f/7f/389e0d3839c53a7ab5e99fe0dcd0dbd8c4ea269acf95861fb7cb2ca2ef1a/pipenv-2023.7.23.tar.gz"
  sha256 "77b1ba91d3cbfa85acb05fb447f5c8ab452dc377e0aea0f3ded8b2c36b669a45"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a1c543e9be92cad8402e757ee97f04896bb83396b3f7ce99cfe11631ccf4352"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d715fd87ab2a0215339bb38ad3b9cf22d73e92a36ca1033afee850536254cf1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d0282adfe9940080f93e5799117f1c139a5fe524b9a1958f67d437fc17c7d829"
    sha256 cellar: :any_skip_relocation, ventura:        "401b4e55cfcb22f33e4771ea7ecb0bdd5ca9f15b9cd050529761dfa4158ed38b"
    sha256 cellar: :any_skip_relocation, monterey:       "b06b21566ceaa3efa57308b528acae77d57e9abb2cd49b137ac18fea5d9587b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "4982294606a6dd74db20da018eac874b6b55a70d93f2515f2c6799daf94d293d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61ca8783c7868e256ac05da5eaa548f6744f1c9ca9b140b0acdc1d890e415dbc"
  end

  depends_on "python@3.11"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/98/98/c2ff18671db109c9f10ed27f5ef610ae05b73bd876664139cf95bd1429aa/certifi-2023.7.22.tar.gz"
    sha256 "539cc1d13202e33ca466e88b2807e29f4c13049d6d87031a3c110744495cb082"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/29/34/63be59bdf57b3a8a8dcc252ef45c40f3c018777dc8843d45dd9b869868f0/distlib-0.3.7.tar.gz"
    sha256 "9dafe54b34a028eafd95039d5e5d4851a13734540f1331060d31c9916e7147a8"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/00/0b/c506e9e44e4c4b6c89fcecda23dc115bf8e7ff7eb127e0cb9c114cbc9a15/filelock-3.12.2.tar.gz"
    sha256 "002740518d8aa59a26b0c76e10fb8c6e15eae825d34b6fdf670333fd7b938d81"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/a1/70/c1d14c0c58d975f06a449a403fac69d3c9c6e8ae2a529f387d77c29c2e56/platformdirs-3.9.1.tar.gz"
    sha256 "1b42b450ad933e981d56e59f1b97495428c9bd60698baab9f3eb3d00d5822421"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/7c/08/cc69e4b3d499ee9570c4c57f23d5e71ed814fcf03988a4edd3081cb74577/virtualenv-20.24.1.tar.gz"
    sha256 "2ef6a237c31629da6442b0bcaa3999748108c7166318d1f55cc9f8d7294e97bd"
  end

  resource "virtualenv-clone" do
    url "https://files.pythonhosted.org/packages/85/76/49120db3bb8de4073ac199a08dc7f11255af8968e1e14038aee95043fafa/virtualenv-clone-0.5.7.tar.gz"
    sha256 "418ee935c36152f8f153c79824bb93eaf6f0f7984bae31d3f48f350b9183501a"
  end

  def python3
    "python3.11"
  end

  def install
    # Using the virtualenv DSL here because the alternative of using
    # write_env_script to set a PYTHONPATH breaks things.
    # https://github.com/Homebrew/homebrew-core/pull/19060#issuecomment-338397417
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources
    venv.pip_install buildpath

    # `pipenv` needs to be able to find `virtualenv` on PATH. So we
    # install symlinks for those scripts in `#{libexec}/tools` and create a
    # wrapper script for `pipenv` which adds `#{libexec}/tools` to PATH.
    (libexec/"tools").install_symlink libexec/"bin/pip", libexec/"bin/virtualenv"
    (bin/"pipenv").write_env_script libexec/"bin/pipenv", PATH: "#{libexec}/tools:${PATH}"

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