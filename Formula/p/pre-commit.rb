class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "https://pre-commit.com/"
  url "https://files.pythonhosted.org/packages/ff/29/7cf5bbc236333876e4b41f56e06857a87937ce4bf91e117a6991a2dbb02a/pre_commit-4.3.0.tar.gz"
  sha256 "499fe450cc9d42e9d58e606262795ecb64dd05438943c62b66f6a8673da30b16"
  license "MIT"
  head "https://github.com/pre-commit/pre-commit.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "68539bbf76255e4ad5fc5a17964ba30501238cb093a7dd7dfe43b2194e68f9eb"
    sha256 cellar: :any,                 arm64_sequoia: "49391e8a3fced6ef0771634063b4d3fb3652cf34956571b13bcc7494fc086d05"
    sha256 cellar: :any,                 arm64_sonoma:  "14203088fd2ff4ec749112ebb5d76ee45da5ef748e74d837b5a864d925e75bf8"
    sha256 cellar: :any,                 sonoma:        "94bd944ac86f44ae5969ae93aa5ec1397afd330ab6826e34c0731bf540039e7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67d35d7e19d9537bb070d6293a98dd9ec3c45ece7c0a02479384cc8e88058942"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0569196fdb4a85648ce0d89f369ed96033538aef91a81f6c6c1335a0350832e0"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  resource "cfgv" do
    url "https://files.pythonhosted.org/packages/11/74/539e56497d9bd1d484fd863dd69cbbfa653cd2aa27abfe35653494d85e94/cfgv-3.4.0.tar.gz"
    sha256 "e52591d4c5f5dead8e0f673fb16db7949d2cfb3f7da4582893288f0ded8fe560"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/96/8e/709914eb2b5749865801041647dc7f4e6d00b549cfe88b65ca192995f07c/distlib-0.4.0.tar.gz"
    sha256 "feec40075be03a04501a973d81f633735b4b69f98b05450592310c0f401a4e0d"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/58/46/0028a82567109b5ef6e4d2a1f04a583fb513e6cf9527fcdd09afd817deeb/filelock-3.20.0.tar.gz"
    sha256 "711e943b4ec6be42e1d4e6690b48dc175c822967466bb31c0c293f34334c13f4"
  end

  resource "identify" do
    url "https://files.pythonhosted.org/packages/ff/e7/685de97986c916a6d93b3876139e00eef26ad5bbbd61925d670ae8013449/identify-2.6.15.tar.gz"
    sha256 "e4f4864b96c6557ef2a1e1c951771838f4edc9df3a72ec7118b338801b11c7bf"
  end

  resource "nodeenv" do
    url "https://files.pythonhosted.org/packages/43/16/fc88b08840de0e0a72a2f9d8c6bae36be573e475a6326ae854bcc549fc45/nodeenv-1.9.1.tar.gz"
    sha256 "6ec12890a2dab7946721edbfbcd91f3319c6ccc9aec47be7c7e6b7011ee6645f"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/61/33/9611380c2bdb1225fdef633e2a9610622310fed35ab11dac9620972ee088/platformdirs-4.5.0.tar.gz"
    sha256 "70ddccdd7c99fc5942e9fc25636a8b34d04c24b335100223152c2803e4063312"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/a4/d5/b0ccd381d55c8f45d46f77df6ae59fbc23d19e901e2d523395598e5f4c93/virtualenv-20.35.3.tar.gz"
    sha256 "4f1a845d131133bdff10590489610c98c168ff99dc75d6c96853801f7f67af44"
  end

  def python3
    "python3.14"
  end

  def install
    # Avoid Cellar path reference, which is only good for one version.
    inreplace "pre_commit/commands/install_uninstall.py",
              "f'INSTALL_PYTHON={shlex.quote(sys.executable)}\\n'",
              "f'INSTALL_PYTHON={shlex.quote(\"#{opt_libexec}/bin/#{python3}\")}\\n'"

    virtualenv_install_with_resources
  end

  test do
    system "git", "init"
    (testpath/".pre-commit-config.yaml").write <<~YAML
      repos:
      -   repo: https://github.com/pre-commit/pre-commit-hooks
          rev: v0.9.1
          hooks:
          -   id: trailing-whitespace
    YAML
    system bin/"pre-commit", "install"
    (testpath/"f").write "hi\n"
    system "git", "add", "f"

    ENV["GIT_AUTHOR_NAME"] = "test user"
    ENV["GIT_AUTHOR_EMAIL"] = "test@example.com"
    ENV["GIT_COMMITTER_NAME"] = "test user"
    ENV["GIT_COMMITTER_EMAIL"] = "test@example.com"
    git_exe = which("git")
    ENV["PATH"] = "/usr/bin:/bin"
    system git_exe, "commit", "-m", "test"
  end
end