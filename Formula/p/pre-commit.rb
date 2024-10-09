class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "https:pre-commit.com"
  url "https:files.pythonhosted.orgpackages2ec8e22c292035f1bac8b9f5237a2622305bc0304e776080b246f3df57c4ff9fpre_commit-4.0.1.tar.gz"
  sha256 "80905ac375958c0444c65e9cebebd948b3cdb518f335a091a670a89d652139d2"
  license "MIT"
  head "https:github.compre-commitpre-commit.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f37138629dff35ae7367ab433d46ee115aefa6212f408063a81063ff55374ae3"
    sha256 cellar: :any,                 arm64_sonoma:  "6c2f28b42145d27c1a311e136ff53efcdf190f3c8ba9a164b9952427c4e88b7b"
    sha256 cellar: :any,                 arm64_ventura: "2666fe5dddbe88ad370d910d4bc975513bd6352ea8c5fc0ce1226961d12ac4a4"
    sha256 cellar: :any,                 sonoma:        "c888cd69314622d1fdbcacc73143bea228b1ec30a9db874d13d0368761bb3992"
    sha256 cellar: :any,                 ventura:       "41ddd5768986cb8839b57627ef6edfc84e8ef4cb9f115841473dcb3ce187a5a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e06fefd1ea5489a010b3d75ff77665ffb2dd23338140adc165b03e4a15d6250d"
  end

  depends_on "libyaml"
  depends_on "python@3.12"

  resource "cfgv" do
    url "https:files.pythonhosted.orgpackages1174539e56497d9bd1d484fd863dd69cbbfa653cd2aa27abfe35653494d85e94cfgv-3.4.0.tar.gz"
    sha256 "e52591d4c5f5dead8e0f673fb16db7949d2cfb3f7da4582893288f0ded8fe560"
  end

  resource "distlib" do
    url "https:files.pythonhosted.orgpackagesc491e2df406fb4efacdf46871c25cde65d3c6ee5e173b7e5a4547a47bae91920distlib-0.3.8.tar.gz"
    sha256 "1530ea13e350031b6312d8580ddb6b27a104275a31106523b8f123787f494f64"
  end

  resource "filelock" do
    url "https:files.pythonhosted.orgpackages9ddb3ef5bb276dae18d6ec2124224403d1d67bccdbefc17af4cc8f553e341ab1filelock-3.16.1.tar.gz"
    sha256 "c249fbfcd5db47e5e2d6d62198e565475ee65e4831e2561c8e313fa7eb961435"
  end

  resource "identify" do
    url "https:files.pythonhosted.orgpackages29bb25024dbcc93516c492b75919e76f389bac754a3e4248682fba32b250c880identify-2.6.1.tar.gz"
    sha256 "91478c5fb7c3aac5ff7bf9b4344f803843dc586832d5f110d672b19aa1984c98"
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
    "python3.12"
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
    xy = Language::Python.major_minor_version Formula["python@3.12"].opt_binpython3
    python_opt = Formula["python@3.12"].opt_prefix
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
    (testpath".pre-commit-config.yaml").write <<~EOS
      repos:
      -   repo: https:github.compre-commitpre-commit-hooks
          rev: v0.9.1
          hooks:
          -   id: trailing-whitespace
    EOS
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