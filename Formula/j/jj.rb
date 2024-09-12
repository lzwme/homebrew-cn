class Jj < Formula
  desc "Git-compatible distributed version control system"
  homepage "https:github.commartinvonzjj"
  url "https:github.commartinvonzjjarchiverefstagsv0.21.0.tar.gz"
  sha256 "c38d98d7db42f08b799f5c51f33cd8454867bc4862a15aa0897b72f2d32eea0a"
  license "Apache-2.0"
  head "https:github.commartinvonzjj.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "a624ce835eea8ce00f6e24610daddb3dcd6a1f2ba7922394d3580df5dd889b5f"
    sha256 cellar: :any,                 arm64_sonoma:   "480e79febb201bce9489537676ee8a1bcae7b9e6eb2aa2b56466f14bf19d2c8b"
    sha256 cellar: :any,                 arm64_ventura:  "3d3b0fe905ecf1b01e99d66fc81fbeb4bb5f09dad59e58ee87a17d60d64bddee"
    sha256 cellar: :any,                 arm64_monterey: "d2384491e0b6d77154408cdc00a07aa66c2e15a515dd23360f65e2a60802e588"
    sha256 cellar: :any,                 sonoma:         "91a9c7edcd860d5fa2a1bb99c0c7ae13b3dcc550eca6d2caab8436749426bd4b"
    sha256 cellar: :any,                 ventura:        "ac373ee6f9c8d3a877d528849de2134d29ac57b62912f4b8d17be35e65ee6664"
    sha256 cellar: :any,                 monterey:       "44f7e8fcbefab6f8f700be5ef56af71a163d0dd6cd908a1a8f49c16e8abecd18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e940ba6143588d61d6339d8601888c8dde9fe887f21a5463c29448fdbfeacbc"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@3"
  uses_from_macos "zlib"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "cli")

    generate_completions_from_executable(bin"jj", "util", "completion", shell_parameter_format: :flag)
    (man1"jj.1").write Utils.safe_popen_read(bin"jj", "util", "mangen")
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    system bin"jj", "init", "--git"
    assert_predicate testpath".jj", :exist?

    [
      Formula["libgit2"].opt_libshared_library("libgit2"),
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
      Formula["openssl@3"].opt_libshared_library("libssl"),
    ].each do |library|
      assert check_binary_linkage(bin"jj", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end