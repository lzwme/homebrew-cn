class GitInteractiveRebaseTool < Formula
  desc "Native sequence editor for Git interactive rebase"
  homepage "https:gitrebasetool.mitmaro.ca"
  url "https:github.comMitMarogit-interactive-rebase-toolarchiverefstags2.4.1.tar.gz"
  sha256 "0b1ba68a1ba1548f44209ce1228d17d6d5768d72ffa991909771df8e9d42d70d"
  license "GPL-3.0-or-later"
  revision 3

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "926261f60068a32cd3229d3ebbea05a4fda9316cd61e0c8b31ad562a70fe0539"
    sha256 cellar: :any,                 arm64_sonoma:  "6f0be8265fa58fc803e26490fbd39eafef6920195d6330d6dec870a8adf32b31"
    sha256 cellar: :any,                 arm64_ventura: "b43f15e6d752a5855bb8eb3c173ff2e40852e47bc5532f4b6501b7c2ce6cd7a9"
    sha256 cellar: :any,                 sonoma:        "7a792dcaa2cdd389bc5bb37bacc87be3b89a88c4bfec8ce1bd5149eb62c0a4eb"
    sha256 cellar: :any,                 ventura:       "ee00b033f71d593edf749bd9d476b01cc03e307a1e3935741802868061d3d022"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52b752d2fdf28e1cd087140f6ab05d05698fc3021b80821034ad55e273d8f15d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2@1.8" # needs https:github.comrust-langgit2-rsissues1109 to support libgit2 1.9

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
      Formula["libgit2@1.8"].opt_libshared_library("libgit2"),
    ].each do |library|
      assert check_binary_linkage(bin"interactive-rebase-tool", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end