class Pipenv < Formula
  include Language::Python::Virtualenv

  desc "Python dependency management tool"
  homepage "https://github.com/pypa/pipenv"
  url "https://files.pythonhosted.org/packages/3e/dd/6bd6fd521d52e757fa12915063d7701ea759fe32f822c021503c79e48d48/pipenv-2023.9.7.tar.gz"
  sha256 "6de1c34666e144fe84aa893ecbe012218350802657eef67feccc6b4f0e3002b5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f289c89a0d767688fa5ae22dd40f093baa0b3e45a8b47091039f327575bf2b68"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7bc5a56029c5cd2ff232159ff6ffb39e97001a3f2fb710eb296ff54c95d4cade"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3e09976a30fa0f79844aca812c335065b4708d6890038c45030a7b4302233fc6"
    sha256 cellar: :any_skip_relocation, ventura:        "bb0612fb7e7ec6299ea363a80f148cbe6ac954d85e9280078d19ea721b0f11d8"
    sha256 cellar: :any_skip_relocation, monterey:       "88633b4129bd70350095ac65ac4dccfdfe8385bc6be9328e0e7f702957fb9cd5"
    sha256 cellar: :any_skip_relocation, big_sur:        "10282e07b36674e2107cd30ec212c2ee0ec8f995cb320ad042535a8c1efe0927"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b04916fcfb8fbe33fd3a4731e12a467ac1183d482f54b9f8a1cae7aa37f0527"
  end

  depends_on "python-certifi"
  depends_on "python@3.11"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/29/34/63be59bdf57b3a8a8dcc252ef45c40f3c018777dc8843d45dd9b869868f0/distlib-0.3.7.tar.gz"
    sha256 "9dafe54b34a028eafd95039d5e5d4851a13734540f1331060d31c9916e7147a8"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/5a/47/f1f3f5b6da710d5a7178a7f8484d9b86b75ee596fb4fefefb50e8dd2205a/filelock-3.12.3.tar.gz"
    sha256 "0ecc1dd2ec4672a10c8550a8182f1bd0c0a5088470ecd5a125e45f49472fac3d"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/dc/99/c922839819f5d00d78b3a1057b5ceee3123c69b2216e776ddcb5a4c265ff/platformdirs-3.10.0.tar.gz"
    sha256 "b45696dab2d7cc691a3226759c0d3b00c47c8b6e293d96f6436f733303f77f6d"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/a6/8e/2ebdf99a0dd15249272780e34fa40e3becfd28689505979d3ec6aa2f6ce1/virtualenv-20.24.4.tar.gz"
    sha256 "772b05bfda7ed3b8ecd16021ca9716273ad9f4467c801f27e83ac73430246dca"
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