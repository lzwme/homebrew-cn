class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "https://pre-commit.com/"
  url "https://files.pythonhosted.org/packages/74/89/1f3e8e1fc3e97de0fa963495832f581f025f29471602a309e48808244292/pre_commit-4.6.2.tar.gz"
  sha256 "8f5d7bfb021ecdbcd9d49d89847082dd24172ccde534390081a679ad046e2441"
  license "MIT"
  revision 1
  head "https://github.com/pre-commit/pre-commit.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6c5894a48aff8fdff0bae2c37af4566d6c2fb91625a51de909b17884155153b2"
    sha256 cellar: :any, arm64_tahoe:       "e1905e551949c702c7769b6654e519fdc91a796162d207a067f65f4f51378311"
    sha256 cellar: :any, arm64_sequoia:     "277f466c98a288a5f281c0db965f1fc5bd966874ce0b14a8c60ddf1a269502fb"
    sha256 cellar: :any, arm64_linux:       "562bf7d99254bc1e2ed17543d27954c9e3464067846804a8007541c43aef9747"
    sha256 cellar: :any, x86_64_linux:      "4161573fbd0ef86e14be666b2729add4a2216e0e967c4db3d401b59ea689c20e"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  resource "cfgv" do
    url "https://files.pythonhosted.org/packages/4e/b5/721b8799b04bf9afe054a3899c6cf4e880fcf8563cc71c15610242490a0c/cfgv-3.5.0.tar.gz"
    sha256 "d5b1034354820651caa73ede66a6294d6e95c1b00acc5e9b098e917404669132"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/c9/02/bd72be9134d25ed783ecbbc38a539ffaefbf90c78418c7fb7229600dbac7/distlib-0.4.3.tar.gz"
    sha256 "f152097224a0ae24be5a0f6bae1b9359af82133bce63f98a95f86cae1aede9ed"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/cc/19/d4f21fc4b7ad098dd3c774ccb2a2929178b15d6e1a3ba7d0929817c0b30c/filelock-4.0.8.tar.gz"
    sha256 "733d9b6b153fc63672f86104324186818b6bbe9dd7db84e9bb9887b6a04a2775"
  end

  resource "identify" do
    url "https://files.pythonhosted.org/packages/53/35/d70c0006c7cee65999ea94a6273e60b2094f600a3d8b71b04318253fc643/identify-2.6.20.tar.gz"
    sha256 "ad729860a923858d26917c2f4fb0a1d83d27a75b1e090c06440c573f048f3285"
  end

  resource "nodeenv" do
    url "https://files.pythonhosted.org/packages/9a/8e/105de02c1322cfada6d9710d9146ef8026419d433c9d08359a2d35805811/nodeenv-1.11.0.tar.gz"
    sha256 "3ce8fe5b71d16e8af7039ca65257354100bc772965d6bc549070649e53b1b146"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/17/c8/721b3855fe457da514fe249247d404b9b39c5d16532278f70ebaa6acf18b/platformdirs-4.12.2.tar.gz"
    sha256 "eab5f70271a490ef74618bb314fbb86e3c7e82fa3b9c922c2ea0e0a1a155d329"
  end

  resource "python-discovery" do
    url "https://files.pythonhosted.org/packages/0c/57/250bd238b966cece44328235eb85290045d059265fdaf7527a3a958123db/python_discovery-1.6.1.tar.gz"
    sha256 "cf87d3627dfb4412437fdd5b13eae402607722998d21567993aedbc59b23c15e"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/67/57/630a01cf5ab58f33b9c7dc8a7f13464cb5740b5227f8a08cab9d798bd532/virtualenv-21.14.2.tar.gz"
    sha256 "571930928b11e43db690073ad8228162eca8a3f8fd3a87acdeae07df7dd57068"
  end

  def install
    # Avoid Cellar path reference, which is only good for one version.
    inreplace "pre_commit/commands/install_uninstall.py",
              "f'INSTALL_PYTHON={shlex.quote(sys.executable)}\\n'",
              "f'INSTALL_PYTHON={shlex.quote(\"#{opt_libexec}/bin/#{python3.basename}\")}\\n'"

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