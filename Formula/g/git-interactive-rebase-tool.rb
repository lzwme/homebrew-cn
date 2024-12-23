class GitInteractiveRebaseTool < Formula
  desc "Native sequence editor for Git interactive rebase"
  homepage "https:gitrebasetool.mitmaro.ca"
  url "https:github.comMitMarogit-interactive-rebase-toolarchiverefstags2.4.1.tar.gz"
  sha256 "0b1ba68a1ba1548f44209ce1228d17d6d5768d72ffa991909771df8e9d42d70d"
  license "GPL-3.0-or-later"
  revision 2

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "894400658f898110f441ffd7af03c3a1237e5f6f4167e787e5f672899d84cc0d"
    sha256 cellar: :any,                 arm64_sonoma:  "70aff4188c99a363f4948e17ec4cf4f83ee848c37d5d6a0d58784e7d0331255c"
    sha256 cellar: :any,                 arm64_ventura: "95a7ad09ba7ab81e9a441465e47598e263fbe69da00777be1896d9577482d7b8"
    sha256 cellar: :any,                 sonoma:        "9966b6bdcb2a6be0f522028239bfab8cc2b907c24a71efb9829524e51fce6963"
    sha256 cellar: :any,                 ventura:       "f8e437e497161e6f299566af6ea83f6f7fbeac5513ed9a9722e53b573f195dc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5250912b7545ef558806147fc2b229c2615afba6930fdee2bf3de03ab2004395"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  uses_from_macos "zlib"

  # support libgit2 1.8, upstream pr ref, https:github.comMitMarogit-interactive-rebase-toolpull948
  patch do
    url "https:github.comMitMarogit-interactive-rebase-toolcommit508291ca003d5cd380a1c34f27efde913b488888.patch?full_index=1"
    sha256 "1256c6e9fa3a7c3ed196d30a2a35b9c05e06434ed954e8a4e58e1d2ceb1ae7d8"
  end

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