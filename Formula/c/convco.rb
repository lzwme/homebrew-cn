class Convco < Formula
  desc "Conventional commits, changelog, versioning, validation"
  homepage "https:convco.github.io"
  url "https:github.comconvcoconvcoarchiverefstagsv0.6.1.tar.gz"
  sha256 "ed68341e065f76f22b6d93ff3686836a812f6a031dc7ee00bed7e048b0da4294"
  license "MIT"
  revision 1
  head "https:github.comconvcoconvco.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c5e8f4af7167c711b94120c2a0dd293289b3e4a3ba78945a6fb9c5d1efd2aab2"
    sha256 cellar: :any,                 arm64_sonoma:  "65b439d389ddf9612d3d3cef18df84d60eb220530eacf121857dd27e8273ef6b"
    sha256 cellar: :any,                 arm64_ventura: "da85dd370e5714c0c13a3d9c6760d58862c84e3b7a34af4827511b241bebe555"
    sha256 cellar: :any,                 sonoma:        "c7e429b28b7d7848958beaa73bec1c06ecabfeeddfa3c568f6420d9795e99ed0"
    sha256 cellar: :any,                 ventura:       "729b6ff47aaab6e8d52f85de48a959ce5f764d9860385e63fc7b0d95236555e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "015cbd770a86d0b53e43de0721a256ed27c8326c10c76bccb2e53438ec872df0"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2@1.8" # needs https:github.comrust-langgit2-rsissues1109 to support libgit2 1.9

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", "--no-default-features", *std_cargo_args

    bash_completion.install "targetcompletionsconvco.bash" => "convco"
    zsh_completion.install  "targetcompletions_convco" => "_convco"
    fish_completion.install "targetcompletionsconvco.fish" => "convco.fish"
  end

  test do
    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "invalid"
    assert_match(FAIL  \w+  first line doesn't match `<type>\[optional scope\]: <description>`  invalid\n,
      shell_output("#{bin}convco check", 1).lines.first)

    # Verify that we are using the libgit2 library
    linkage_with_libgit2 = (bin"convco").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2@1.8"].opt_libshared_library("libgit2")).realpath.to_s
    end
    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end