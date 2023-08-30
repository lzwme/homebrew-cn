class Pipenv < Formula
  include Language::Python::Virtualenv

  desc "Python dependency management tool"
  homepage "https://github.com/pypa/pipenv"
  url "https://files.pythonhosted.org/packages/5c/a4/f5754fc061ce6554d11635d94b02b92a4389026801a18ec4ed88fcecbc14/pipenv-2023.8.28.tar.gz"
  sha256 "2f708e589725c7363e59a0a47e20bb008f3d06598bdb32d7df159549ad10b59b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af14bed58842a03ce329a7866e806b5612028f0299a087270beffef4c150dfe6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8463cb3b7d7fa072d1675e7d88e5d264ba5d9ac3baa75d486a832d9b8753832e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ce98def474ee9887d333740254bf586fba0ed561ce07693180b5d7bb5b722bd"
    sha256 cellar: :any_skip_relocation, ventura:        "fb1839cc3148e850ab8cdea7799e3c3540e3c57f24248c6d585163fa53101b9c"
    sha256 cellar: :any_skip_relocation, monterey:       "89a08800bc401a9ea5ce8882696f03225c08a31b12020810f364adbb2208d90e"
    sha256 cellar: :any_skip_relocation, big_sur:        "d9286d4990bbed4b952fe0673d3c20c173e233bced37f536ddfeaef242fac787"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06de110cc860b6ece9f0db2922cc92b152878f53f188c623160bfeff97138eb9"
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
    url "https://files.pythonhosted.org/packages/77/f9/f6319b17869e66571966060051894d7a6dc77feceb25a9ebb6daee7eed5a/virtualenv-20.24.3.tar.gz"
    sha256 "e5c3b4ce817b0b328af041506a2a299418c98747c4b1e68cb7527e74ced23efc"
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