class GitInteractiveRebaseTool < Formula
  desc "Native sequence editor for Git interactive rebase"
  homepage "https:gitrebasetool.mitmaro.ca"
  url "https:github.comMitMarogit-interactive-rebase-toolarchiverefstags2.4.1.tar.gz"
  sha256 "0b1ba68a1ba1548f44209ce1228d17d6d5768d72ffa991909771df8e9d42d70d"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4ac649d64eb740c263b9ad078d03653d3ddcd0749f421e8f3338a14a118c4ab4"
    sha256 cellar: :any,                 arm64_ventura:  "a9651edfb9767af29f1616798bda32cd94114cfa1d175a5367d7539560b7aba6"
    sha256 cellar: :any,                 arm64_monterey: "e6d25224763538b1732a4489dd02b56e1a5069113f1f949336a780de68fa3628"
    sha256 cellar: :any,                 sonoma:         "3f1e8c8ebf19d085050d76d1541e400f0a85ab867681244d5a169a9c83df0210"
    sha256 cellar: :any,                 ventura:        "d8704de335fe2d5fdb1f9a43a87ff650a92b733846f366ddeb394239e59903b2"
    sha256 cellar: :any,                 monterey:       "c001b62f173b7b355e34ac2ffc379430ebae1e5660ed2c1b3fb9b9f7f909ff6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18ea56c826b260bd6028f99818cfdb98a5ff684c2c581712dbd76527161c5877"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  uses_from_macos "zlib"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    require "pty"
    require "ioconsole"

    mkdir testpath"repo" do
      system "git", "init"
    end

    (testpath"repo.gitrebase-mergegit-rebase-todo").write <<~EOS
      noop
    EOS

    expected_git_rebase_todo = <<~EOS
      noop
    EOS

    env = { "GIT_DIR" => testpath"repo.git" }
    executable = bin"interactive-rebase-tool"
    todo_file = testpath"repo.gitrebase-mergegit-rebase-todo"

    _, _, pid = PTY.spawn(env, executable, todo_file)
    Process.wait(pid)

    assert_equal 0, $CHILD_STATUS.exitstatus
    assert_equal expected_git_rebase_todo, todo_file.read

    [
      Formula["libgit2"].opt_libshared_library("libgit2"),
    ].each do |library|
      assert check_binary_linkage(bin"interactive-rebase-tool", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end