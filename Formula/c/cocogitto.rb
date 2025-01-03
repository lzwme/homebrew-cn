class Cocogitto < Formula
  desc "Conventional Commits toolbox"
  homepage "https:docs.cocogitto.io"
  url "https:github.comcocogittococogittoarchiverefstags6.2.0.tar.gz"
  sha256 "fd7d69fb5b6d64e292877d87a77864d5081906b6e515e20b93348b7f05bd05c1"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3475b0711ea44c686df09a0291f4460d7b7ebcc5c875dee87843ad92fb78e37a"
    sha256 cellar: :any,                 arm64_sonoma:  "d42d4265db5f0b59377c90438b2e0fae62b4bd3df51b87c6b8eea41a65e53283"
    sha256 cellar: :any,                 arm64_ventura: "1c620a2e86a848bc471f09030b07fd78fa273ef496abd6b4c36bf4a27e135a32"
    sha256 cellar: :any,                 sonoma:        "5849ca6b15217adc79b5d586a76279c106ca5b55b376b16d637ac491c5a0e2a5"
    sha256 cellar: :any,                 ventura:       "92a509b0b0abbe45719479c63ed0d487eb47431b85e3c1ef49355a8b9f88e309"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8338df38de50ce8a00b8dcb98805b4ef5cef67ca19963bfea9e844bc8083132c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2@1.8" # needs https:github.comrust-langgit2-rsissues1109 to support libgit2 1.9

  conflicts_with "cog", because: "both install `cog` binaries"

  # support libgit2 1.8, upstream pr ref, https:github.comcocogittococogittopull433
  patch do
    url "https:github.comcocogittococogittocommit47689fe4f431d7b1371ff34cb430fbffc19f40c5.patch?full_index=1"
    sha256 "508a34432f907500d2a92940647501512e789cac53e85497a83b1b99089ae07b"
  end

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin"cog", "generate-completions")

    system bin"cog", "generate-manpages", buildpath
    man1.install Dir["*.1"]
  end

  test do
    # Check that a typical Conventional Commit is considered correct.
    system "git", "init", "--initial-branch=main"
    (testpath"some-file").write("")
    system "git", "add", "some-file"
    system "git", "config", "user.name", "'A U Thor'"
    system "git", "config", "user.email", "author@example.com"
    system "git", "commit", "-m", "chore: initial commit"
    assert_equal "No errored commits", shell_output("#{bin}cog check 2>&1").strip

    linkage_with_libgit2 = (bin"cog").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2@1.8"].opt_libshared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end