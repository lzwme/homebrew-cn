class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "https:pre-commit.com"
  url "https:files.pythonhosted.orgpackages2a13b62d075317d8686071eb843f0bb1f195eb332f48869d3c31a4c6f1e063acpre_commit-4.1.0.tar.gz"
  sha256 "ae3f018575a588e30dfddfab9a05448bfbd6b73d78709617b5a2b853549716d4"
  license "MIT"
  head "https:github.compre-commitpre-commit.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "734176ac95c15e280885ad9eb98bc7de726f6773afb3767796eff4c913c95cf2"
    sha256 cellar: :any,                 arm64_sonoma:  "393f024ff7ef27ec8e43fcff20f26cbeded94e7a79bbc32424eb2c0f660e59cf"
    sha256 cellar: :any,                 arm64_ventura: "8b09d54f0dd55ec613944f7defed9ba122218eff6fa3901ab83f7a92ea0d7c3f"
    sha256 cellar: :any,                 sonoma:        "168a9d6cb61aa9a0ead5208c288ea746d2a0a8bf1ec8b31c05da03b09308e183"
    sha256 cellar: :any,                 ventura:       "aa0366972c337f9233551d5e2ecb09eacb4ad6721f1aca813def750030f3a0e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bfc1911800f93eed813a96a7127e14229e663078af9b539bd7d7c44dae1ec6d"
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
    url "https:files.pythonhosted.orgpackagescf9269934b9ef3c31ca2470980423fda3d00f0460ddefdf30a67adf7f17e2e00identify-2.6.5.tar.gz"
    sha256 "c10b33f250e5bba374fae86fb57f3adcebf1161bce7cdf92031915fd480c13bc"
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
    url "https:files.pythonhosted.orgpackagesa7caf23dcb02e161a9bba141b1c08aa50e8da6ea25e6d780528f1d385a3efe25virtualenv-20.29.1.tar.gz"
    sha256 "b8b8970138d32fb606192cb97f6cd4bb644fa486be9308fb9b63f81091b5dc35"
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