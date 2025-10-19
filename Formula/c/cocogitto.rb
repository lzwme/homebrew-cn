class Cocogitto < Formula
  desc "Conventional Commits toolbox"
  homepage "https://docs.cocogitto.io/"
  url "https://ghfast.top/https://github.com/cocogitto/cocogitto/archive/refs/tags/6.4.0.tar.gz"
  sha256 "4e62b280e818d3b0c1320dd6e4b9d51d3ff1a65c79b9b2cd8d46b33e1ca6886b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "24d35cc8041b18d7f87fb3386da4e9e933fa1149284c03139834c5a499e4befc"
    sha256 cellar: :any,                 arm64_sequoia: "053010fa520bedc3b06974d73d44f7ff4af5aa7ca0c68602f4c3c37ac3fd36e7"
    sha256 cellar: :any,                 arm64_sonoma:  "b77bb2fd3ab132e0af8bf4eaeddeab3f2f6d65c775395b97385a7a0afd46b1b8"
    sha256 cellar: :any,                 sonoma:        "06de79a32b602121bed4545f023d4c9e513811bc3ea3c4f68bf8f1515ab38fc0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "debb5de55ec6e4fa7d7c740f3e6f01eda8d00f1ac0d52d3889e1789e21fcf741"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed7c3c5f78279fedd2dc7f254b76fad62c05ed5e33e36d775870ebd0035bae26"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  conflicts_with "cog", because: "both install `cog` binaries"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"cog", "generate-completions")

    system bin/"cog", "generate-manpages", buildpath
    man1.install Dir["*.1"]
  end

  test do
    # Check that a typical Conventional Commit is considered correct.
    system "git", "init", "--initial-branch=main"
    (testpath/"some-file").write("")
    system "git", "add", "some-file"
    system "git", "config", "user.name", "'A U Thor'"
    system "git", "config", "user.email", "author@example.com"
    system "git", "commit", "-m", "chore: initial commit"
    assert_equal "No errored commits", shell_output("#{bin}/cog check 2>&1").strip

    linkage_with_libgit2 = (bin/"cog").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2"].opt_lib/shared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end