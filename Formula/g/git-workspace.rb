class GitWorkspace < Formula
  desc "Sync personal and work git repositories from multiple providers"
  homepage "https:github.comorfgit-workspace"
  url "https:github.comorfgit-workspacearchiverefstagsv1.9.0.tar.gz"
  sha256 "d5e2a5a0a568c46b408f82f981ea3672066d4496755fc14837e553e451c69f2d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "aca4615cfa66778ae5a83c844d9fe1952d7de360694b68623ec46379b8b4ca2e"
    sha256 cellar: :any,                 arm64_sonoma:  "f12db6ccd51a5f0ec5d15daac7628e238b96686dde7e770411183ed6868e90aa"
    sha256 cellar: :any,                 arm64_ventura: "2738201a322b30e61be60ff97f4bbbdd3a8f6cbe3bfa20a1fe5865c8b4e3563a"
    sha256 cellar: :any,                 sonoma:        "9206846d477b1a921ea76ccb71977e356d265ef639d46aaeda0ba243b8fab6ff"
    sha256 cellar: :any,                 ventura:       "ef8f8e6fdf09e75d75e1193cb548f796c05769a68b528a45ba21498f5e1035e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed2e0ab62b3ce2e7a6f1a71bedf3c994aab673901ff5cede97f2a0a0bffabc9f"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@3"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["GIT_WORKSPACE"] = Pathname.pwd
    ENV["GITHUB_TOKEN"] = "foo"
    system bin"git-workspace", "add", "github", "foo"
    assert_match "provider = \"github\"", File.read("workspace.toml")
    output = shell_output("#{bin}git-workspace update 2>&1", 1)
    assert_match "Error fetching repositories from Github userorg foo", output

    linkage_with_libgit2 = (bin"git-workspace").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2"].opt_libshared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end