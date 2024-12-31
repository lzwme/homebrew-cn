class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "https:pre-commit.com"
  url "https:files.pythonhosted.orgpackages2ec8e22c292035f1bac8b9f5237a2622305bc0304e776080b246f3df57c4ff9fpre_commit-4.0.1.tar.gz"
  sha256 "80905ac375958c0444c65e9cebebd948b3cdb518f335a091a670a89d652139d2"
  license "MIT"
  head "https:github.compre-commitpre-commit.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia: "80505e919f42270c85f11bb79ba839347023cdc6afaf318d0c41aec7d393fe0b"
    sha256 cellar: :any,                 arm64_sonoma:  "286e00716c42375a6389e168640c864d47331d0f3378a5f91151b726f278c60f"
    sha256 cellar: :any,                 arm64_ventura: "55ad204e8c16a7e1771d072cb2e064845b870384f3b531cf57dd0292fa2b0ef1"
    sha256 cellar: :any,                 sonoma:        "e5005217b42db6d1955ecabaabdd2f197d15f9a6017f1a531e65e596bc4f1ed0"
    sha256 cellar: :any,                 ventura:       "02d1f96671b025343c1eafd7798bb64fd3496d051c55ca7faf23269c5236d6f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "238700fc36e3a5d5233fc837eaaeb354bb290e4d363bcd96a497182b0f8950cf"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "cfgv" do
    url "https:files.pythonhosted.orgpackages1174539e56497d9bd1d484fd863dd69cbbfa653cd2aa27abfe35653494d85e94cfgv-3.4.0.tar.gz"
    sha256 "e52591d4c5f5dead8e0f673fb16db7949d2cfb3f7da4582893288f0ded8fe560"
  end

  resource "distlib" do
    url "https:files.pythonhosted.orgpackages0ddd1bec4c5ddb504ca60fc29472f3d27e8d4da1257a854e1d96742f15c1d02ddistlib-0.3.9.tar.gz"
    sha256 "a60f20dea646b8a33f3e7772f74dc0b2d0772d2837ee1342a00645c81edf9403"
  end

  resource "filelock" do
    url "https:files.pythonhosted.orgpackages9ddb3ef5bb276dae18d6ec2124224403d1d67bccdbefc17af4cc8f553e341ab1filelock-3.16.1.tar.gz"
    sha256 "c249fbfcd5db47e5e2d6d62198e565475ee65e4831e2561c8e313fa7eb961435"
  end

  resource "identify" do
    url "https:files.pythonhosted.orgpackages49a57de3053524ee006b91099968d7ecb2e0b420f7ae728094394c33e8a2a2b9identify-2.6.4.tar.gz"
    sha256 "285a7d27e397652e8cafe537a6cc97dd470a970f48fb2e9d979aa38eae5513ac"
  end

  resource "nodeenv" do
    url "https:files.pythonhosted.orgpackages4316fc88b08840de0e0a72a2f9d8c6bae36be573e475a6326ae854bcc549fc45nodeenv-1.9.1.tar.gz"
    sha256 "6ec12890a2dab7946721edbfbcd91f3319c6ccc9aec47be7c7e6b7011ee6645f"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackages13fc128cc9cb8f03208bdbf93d3aa862e16d376844a14f9a0ce5cf4507372de4platformdirs-4.3.6.tar.gz"
    sha256 "357fb2acbc885b0419afd3ce3ed34564c13c9b95c89360cd9563f73aa5e2b907"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "virtualenv" do
    url "https:files.pythonhosted.orgpackages3f40abc5a766da6b0b2457f819feab8e9203cbeae29327bd241359f866a3da9dvirtualenv-20.26.6.tar.gz"
    sha256 "280aede09a2a5c317e409a00102e7077c6432c5a38f0ef938e643805a7ad2c48"
  end

  def python3
    "python3.13"
  end

  def install
    # Avoid Cellar path reference, which is only good for one version.
    inreplace "pre_commitcommandsinstall_uninstall.py",
              "f'INSTALL_PYTHON={shlex.quote(sys.executable)}\\n'",
              "f'INSTALL_PYTHON={shlex.quote(\"#{opt_libexec}bin#{python3}\")}\\n'"

    virtualenv_install_with_resources
  end

  # Avoid relative paths
  def post_install
    xy = Language::Python.major_minor_version Formula["python@3.13"].opt_binpython3
    python_opt = Formula["python@3.13"].opt_prefix
    python_cellar = python_opt.realpath
    dirs_to_fix = [libexec"libpython#{xy}"]
    dirs_to_fix << (libexec"bin") if OS.linux?
    dirs_to_fix.each do |folder|
      folder.each_child do |f|
        next unless f.symlink?

        abspath = f.realpath.sub python_cellar, python_opt
        rm f
        ln_s abspath, f
      end
    end
  end

  test do
    system "git", "init"
    (testpath".pre-commit-config.yaml").write <<~YAML
      repos:
      -   repo: https:github.compre-commitpre-commit-hooks
          rev: v0.9.1
          hooks:
          -   id: trailing-whitespace
    YAML
    system bin"pre-commit", "install"
    (testpath"f").write "hi\n"
    system "git", "add", "f"

    ENV["GIT_AUTHOR_NAME"] = "test user"
    ENV["GIT_AUTHOR_EMAIL"] = "test@example.com"
    ENV["GIT_COMMITTER_NAME"] = "test user"
    ENV["GIT_COMMITTER_EMAIL"] = "test@example.com"
    git_exe = which("git")
    ENV["PATH"] = "usrbin:bin"
    system git_exe, "commit", "-m", "test"
  end
end