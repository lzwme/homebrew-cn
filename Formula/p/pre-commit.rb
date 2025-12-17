class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "https://pre-commit.com/"
  url "https://files.pythonhosted.org/packages/40/f1/6d86a29246dfd2e9b6237f0b5823717f60cad94d47ddc26afa916d21f525/pre_commit-4.5.1.tar.gz"
  sha256 "eb545fcff725875197837263e977ea257a402056661f09dae08e4b149b030a61"
  license "MIT"
  head "https://github.com/pre-commit/pre-commit.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "16c1252f5bd0a81f175ab6aff6bf93405971659330fd51a3cc1545c7f4a8b0a5"
    sha256 cellar: :any,                 arm64_sequoia: "3d54bae652cdd39b8f922bfe1186dba80a7862bd820c0ec2e88bc4e75da25003"
    sha256 cellar: :any,                 arm64_sonoma:  "44b4d70a2fd1a2c5247b5ed1abac8be8624808341eb13f5c0d99abf3b18e89b3"
    sha256 cellar: :any,                 sonoma:        "0b59b7e5b7de56c6993d78ec20bc499a86df315ffea4b138a72281e3c0826689"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12ff35db1fcdc293b2cfc7fe0180a4b2d86eb28d7578a72695dc606f465702b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b88d2a56a3b51bebbd4d4ac625eacc4c7b1801b0fd4d393f16cf31dc56afc81"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  resource "cfgv" do
    url "https://files.pythonhosted.org/packages/4e/b5/721b8799b04bf9afe054a3899c6cf4e880fcf8563cc71c15610242490a0c/cfgv-3.5.0.tar.gz"
    sha256 "d5b1034354820651caa73ede66a6294d6e95c1b00acc5e9b098e917404669132"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/96/8e/709914eb2b5749865801041647dc7f4e6d00b549cfe88b65ca192995f07c/distlib-0.4.0.tar.gz"
    sha256 "feec40075be03a04501a973d81f633735b4b69f98b05450592310c0f401a4e0d"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/a7/23/ce7a1126827cedeb958fc043d61745754464eb56c5937c35bbf2b8e26f34/filelock-3.20.1.tar.gz"
    sha256 "b8360948b351b80f420878d8516519a2204b07aefcdcfd24912a5d33127f188c"
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
    url "https://files.pythonhosted.org/packages/cf/86/0248f086a84f01b37aaec0fa567b397df1a119f73c16f6c7a9aac73ea309/platformdirs-4.5.1.tar.gz"
    sha256 "61d5cdcc6065745cdd94f0f878977f8de9437be93de97c1c12f853c9c0cdcbda"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/20/28/e6f1a6f655d620846bd9df527390ecc26b3805a0c5989048c210e22c5ca9/virtualenv-20.35.4.tar.gz"
    sha256 "643d3914d73d3eeb0c552cbb12d7e82adf0e504dbf86a3182f8771a153a1971c"
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