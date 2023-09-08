class Gitup < Formula
  include Language::Python::Virtualenv

  desc "Update multiple git repositories at once"
  homepage "https://github.com/earwig/git-repo-updater"
  url "https://files.pythonhosted.org/packages/7f/07/4835f8f4de5924b5f38b816c648bde284f0cec9a9ae65bd7e5b7f5867638/gitup-0.5.1.tar.gz"
  sha256 "4f787079cd65d8f60c5842181204635e1b72d3533ae91f0c619624c6b20846dd"
  license "MIT"
  revision 8
  head "https://github.com/earwig/git-repo-updater.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d3fd4d20fe43e22811b9c88f534f49174d7615156468062447ff39e5fd24c0e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c55701fb2e8a02c5d945fc66a621444d729f18eb8fd60d76576358036144b993"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d809057c6d2dd1322525c4df8cdae82cb8505fa65ea0fd24a0a6681c1f1cba6"
    sha256 cellar: :any_skip_relocation, ventura:        "95ae3ae553e64eaa3b951b201061d3b64d338de42924e805d448fd86d8833f39"
    sha256 cellar: :any_skip_relocation, monterey:       "09ebaf983b0f644685ae22216cae93873409cbc2fb663fdaabc132b81fc4d397"
    sha256 cellar: :any_skip_relocation, big_sur:        "7ed4b2111cb0f515cf4b23162c9c59be9d061c66fac2c78fc7089fd8887d6ed5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fd20ccbc473ba71bd82f4405a5bd649f0554eb0673156c923dbc7af91057b66"
  end

  depends_on "python@3.11"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/4b/47/dc98f3d5d48aa815770e31490893b92c5f1cd6c6cf28dd3a8ae0efffac14/gitdb-4.0.10.tar.gz"
    sha256 "6eb990b69df4e15bad899ea868dc46572c3f75339735663b81de79b06f17eb9a"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/f6/7e/74206b2ac9f63a40cbfc7bfdf69cda4a3bde9d932129bee2352f6bdec555/GitPython-3.1.34.tar.gz"
    sha256 "85f7d365d1f6bf677ae51039c1ef67ca59091c7ebd5a3509aa399d4eda02d6dd"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/21/2d/39c6c57032f786f1965022563eec60623bb3e1409ade6ad834ff703724f3/smmap-5.0.0.tar.gz"
    sha256 "c840e62059cd3be204b0c9c9f74be2c09d5648eddd4580d9314c3ecde0b30936"
  end

  def install
    virtualenv_install_with_resources
  end

  def prepare_repo(uri, local_head)
    system "git", "init"
    system "git", "remote", "add", "origin", uri
    system "git", "fetch", "origin"
    system "git", "checkout", local_head
    system "git", "reset", "--hard"
    system "git", "checkout", "-b", "master"
    system "git", "branch", "--set-upstream-to=origin/master", "master"
  end

  test do
    first_head_start = "f47ab45abdbc77e518776e5dc44f515721c523ae"
    mkdir "first" do
      prepare_repo("https://github.com/pr0d1r2/homebrew-contrib.git", first_head_start)
    end

    second_head_start = "f863d5ca9e39e524e8c222428e14625a5053ed2b"
    mkdir "second" do
      prepare_repo("https://github.com/pr0d1r2/homebrew-cask-games.git", second_head_start)
    end

    system bin/"gitup", "first", "second"

    first_head = Utils.git_head(testpath/"first")
    refute_equal first_head, first_head_start

    second_head = Utils.git_head(testpath/"second")
    refute_equal second_head, second_head_start

    third_head_start = "f47ab45abdbc77e518776e5dc44f515721c523ae"
    mkdir "third" do
      prepare_repo("https://github.com/pr0d1r2/homebrew-contrib.git", third_head_start)
    end

    system bin/"gitup", "--add", "third"

    system bin/"gitup"
    third_head = Utils.git_head(testpath/"third")
    refute_equal third_head, third_head_start

    assert_match %r{#{Dir.pwd}/third}, `#{bin}/gitup --list`.strip

    system bin/"gitup", "--delete", "#{Dir.pwd}/third"
  end
end