class GitBranchless < Formula
  desc "High-velocity, monorepo-scale workflow for Git"
  homepage "https:github.comarxanasgit-branchless"
  url "https:github.comarxanasgit-branchlessarchiverefstagsv0.10.0.tar.gz"
  sha256 "1eb8dbb85839c5b0d333e8c3f9011c3f725e0244bb92f4db918fce9d69851ff7"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1
  head "https:github.comarxanasgit-branchless.git", branch: "master"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ca739d76b3d52de81f0ec9e679aba6847426b0c4d9c84b8db0c934ad576dc439"
    sha256 cellar: :any,                 arm64_sonoma:  "993e9b56d4598738d7c5fd6fb6b90393396cd59a3bfb630294c7709a6507b04b"
    sha256 cellar: :any,                 arm64_ventura: "a1e2afd8baea79531f7774ec70cc2230c945edde309036d0fb0aa5a9809b87fa"
    sha256 cellar: :any,                 sonoma:        "4ca5e3cd013c7556f3b32d06cac5186e3bdf369afdc2fe92c81ef52e08f631ff"
    sha256 cellar: :any,                 ventura:       "c72f47a4f49662451cd7154370b69240f75ceb7db7f33b90bc0e8532f39dd5c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c6f31ef2352a3bbcc8e2478b7edfcf91df250d22084ade647a3fb187ace0f32"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2@1.8" # needs https:github.comrust-langgit2-rsissues1109 to support libgit2 1.9

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    # make sure git can find git-branchless
    ENV.prepend_path "PATH", bin

    system "cargo", "install", *std_cargo_args(path: "git-branchless")

    system "git", "branchless", "install-man-pages", man
  end

  test do
    system "git", "init"
    %w[haunted house].each { |f| touch testpathf }
    system "git", "add", "haunted", "house"
    system "git", "commit", "-a", "-m", "Initial Commit"

    system "git", "branchless", "init"
    assert_match "Initial Commit", shell_output("git sl").strip

    linkage_with_libgit2 = (bin"git-branchless").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2@1.8"].opt_libshared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end