class Convco < Formula
  desc "Conventional commits, changelog, versioning, validation"
  homepage "https://convco.github.io"
  url "https://ghproxy.com/https://github.com/convco/convco/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "1e63e07e3d98aa0bcce10824d9aa2de89f0bda90bad3a322311dba4efe7a1d13"
  license "MIT"
  head "https://github.com/convco/convco.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea517cbafb83b9a4ce1420773d0d89b71eea5ac42ad4f05690dc9ee475554d1a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5322db8557f1ca86ea4a94593ac5fe30efdada6600a6eae4808b697cdf7f1af2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "426a1db5b23301a0b322ea49dc9e7f9f8ddeab1c6bcd860953ea3bc85b94ebd6"
    sha256 cellar: :any_skip_relocation, ventura:        "407fb94a65ca83c8be823b86b4b49e0d0ffee37003defea44b654750516ab3e5"
    sha256 cellar: :any_skip_relocation, monterey:       "2740d00336264d7adb9c143ce7c058add67e3e36680645d809a85d117d899296"
    sha256 cellar: :any_skip_relocation, big_sur:        "61abb3e9faea2d5b130f19d412d51404ad9d9c84705d94b0ca57589b79f1de24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b045246fa28644eafc66816dca6b7c738a142f357c4aa0fe7a711c52566e7959"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args

    bash_completion.install "target/completions/convco.bash" => "convco"
    zsh_completion.install  "target/completions/_convco" => "_convco"
    fish_completion.install "target/completions/convco.fish" => "convco.fish"
  end

  test do
    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "invalid"
    assert_match(/FAIL  \w+  first line doesn't match `<type>\[optional scope\]: <description>`  invalid\n/,
      shell_output("#{bin}/convco check", 1).lines.first)

    # Verify that we are using the libgit2 library
    linkage_with_libgit2 = (bin/"convco").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2"].opt_lib/shared_library("libgit2")).realpath.to_s
    end
    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end