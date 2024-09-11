class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "https:pre-commit.com"
  url "https:files.pythonhosted.orgpackages641097ee2fa54dff1e9da9badbc5e35d0bbaef0776271ea5907eccf64140f72fpre_commit-3.8.0.tar.gz"
  sha256 "8bb6494d4a20423842e198980c9ecf9f96607a07ea29549e180eef9ae80fe7af"
  license "MIT"
  head "https:github.compre-commitpre-commit.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "bea4d3515156f78af9a3210211ac741aa6d30f6413c35c2fbb8c7a3e396ece74"
    sha256 cellar: :any,                 arm64_sonoma:   "038b2592f3bfeec760057063e5f946e7e47f8f151d9983d77ba6b6cff6b5ba93"
    sha256 cellar: :any,                 arm64_ventura:  "561bbe8994339275497419d7eef007e8c696222cff93f65d7edd3a0b2f3399d3"
    sha256 cellar: :any,                 arm64_monterey: "1dd80d9ef9977b5bef5fead88553b984b1170d7d3bb3851682566d0a2386bcb8"
    sha256 cellar: :any,                 sonoma:         "4eee92e3da7bd144245205b70b8e8d7b45e7b3d10eec74408a45a21527d5742c"
    sha256 cellar: :any,                 ventura:        "1e1530c1811e238955b98eae971e855bab0e38831e620ac34ab8e5c190e1d8c0"
    sha256 cellar: :any,                 monterey:       "093e9df946e1e2eefbfa474b165608caaf4fd4b6b6026e7f020ecd8a9ec83aa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bdb2fb46ee71c585ac7260a73a03c682b86f367f04b7d4e28939bbe7e4718fa8"
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
    url "https:files.pythonhosted.orgpackages08dd49e06f09b6645156550fb9aee9cc1e59aba7efbc972d665a1bd6ae0435d4filelock-3.15.4.tar.gz"
    sha256 "2207938cbc1844345cb01a5a95524dae30f0ce089eba5b00378295a17e3e90cb"
  end

  resource "identify" do
    url "https:files.pythonhosted.orgpackages32f48e8f7db397a7ce20fbdeac5f25adaf567fc362472432938d25556008e03aidentify-2.6.0.tar.gz"
    sha256 "cb171c685bdc31bcc4c1734698736a7d5b6c8bf2e0c15117f4d469c8640ae5cf"
  end

  resource "nodeenv" do
    url "https:files.pythonhosted.orgpackages4316fc88b08840de0e0a72a2f9d8c6bae36be573e475a6326ae854bcc549fc45nodeenv-1.9.1.tar.gz"
    sha256 "6ec12890a2dab7946721edbfbcd91f3319c6ccc9aec47be7c7e6b7011ee6645f"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackagesf5520763d1d976d5c262df53ddda8d8d4719eedf9594d046f117c25a27261a19platformdirs-4.2.2.tar.gz"
    sha256 "38b7b51f512eed9e84a22788b4bce1de17c0adb134d6becb09836e37d8654cd3"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackagescde5af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "virtualenv" do
    url "https:files.pythonhosted.orgpackages6860db9f95e6ad456f1872486769c55628c7901fb4de5a72c2f7bdd912abf0c1virtualenv-20.26.3.tar.gz"
    sha256 "4c43a2a236279d9ea36a0d76f98d84bd6ca94ac4e0f4a3b9d46d05e10fea542a"
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
    dirs_to_fix = [libexec"libpython#{xy}"]
    dirs_to_fix << (libexec"bin") if OS.linux?
    dirs_to_fix.each do |folder|
      folder.each_child do |f|
        next unless f.symlink?

        realpath = f.realpath
        rm f
        ln_s realpath, f
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