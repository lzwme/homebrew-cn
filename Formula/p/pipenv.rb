class Pipenv < Formula
  include Language::Python::Virtualenv

  desc "Python dependency management tool"
  homepage "https://github.com/pypa/pipenv"
  url "https://files.pythonhosted.org/packages/d2/df/ae6fb870d53ac0b2dcce8078986772bf381bfdb50e3c7237279865d17392/pipenv-2023.10.20.tar.gz"
  sha256 "5d14a13b4dc42b6aecfc84d9b4976c4aeef622eb020fd337afded71849ee3551"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fba63e345b2e6a17cf27e1106737808b14b11e04481114eadac4ba9d2bf4af28"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f8aac4cf7a1a6fcbe49c240508340da7c5a0fd4f6227b54c35fc4a0bfc2cba4f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7bb326619cfc5307ecbed4e1053ca435474e03eec84fb0b8dbc7c8b3d5edd16"
    sha256 cellar: :any_skip_relocation, sonoma:         "33bf91915cbdc9ab39823747427cc2a385da31e113e89ec471d34b35c23fdd90"
    sha256 cellar: :any_skip_relocation, ventura:        "55e2ac11e7ca77fb7b08f40ae82a109487268653b8788903153832c15b7a0fd5"
    sha256 cellar: :any_skip_relocation, monterey:       "0f03948a337d3c975ec9ce044b2c346235ec3b0c9bae44f61933e99d756d767d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "938c3e20c132b0b8aa2b979d4a6fdb52c31bee106cda8bae70a567e62fb062af"
  end

  depends_on "python-certifi"
  depends_on "python@3.12"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/29/34/63be59bdf57b3a8a8dcc252ef45c40f3c018777dc8843d45dd9b869868f0/distlib-0.3.7.tar.gz"
    sha256 "9dafe54b34a028eafd95039d5e5d4851a13734540f1331060d31c9916e7147a8"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/d5/71/bb1326535231229dd69a9dd2e338f6f54b2d57bd88fc4a52285c0ab8a5f6/filelock-3.12.4.tar.gz"
    sha256 "2e6f249f1f3654291606e046b09f1fd5eac39b360664c27f5aad072012f8bcbd"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d3/e3/aa14d6b2c379fbb005993514988d956f1b9fdccd9cbe78ec0dbe5fb79bf5/platformdirs-3.11.0.tar.gz"
    sha256 "cf8ee52a3afdb965072dcc652433e0c7e3e40cf5ea1477cd4b3b1d2eb75495b3"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/d3/50/fa955bbda25c0f01297843be105f9d022f461423e69a6ab487ed6cabf75d/virtualenv-20.24.5.tar.gz"
    sha256 "e8361967f6da6fbdf1426483bfe9fca8287c242ac0bc30429905721cefbff752"
  end

  def python3
    "python3.12"
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