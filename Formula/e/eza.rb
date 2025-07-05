class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https://github.com/eza-community/eza"
  url "https://ghfast.top/https://github.com/eza-community/eza/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "9ff08a8e82e558d596291a15fcf89f7f7259d8fe3968cbf26e23315c982cf3e8"
  license "EUPL-1.2"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "be4e3489e28cd189f622be49ab18f3e4c21cbc8cf8e3645306fac8a34ef20c6f"
    sha256 cellar: :any,                 arm64_sonoma:  "b2e934ebb006296a790575a2f228cbd6b8d193973a8e694ace508be4e370def5"
    sha256 cellar: :any,                 arm64_ventura: "d917fb0a0cb3b8e1f1298983c3b93a4a4aad353e0b919342f1fb75b4c8a1a897"
    sha256 cellar: :any,                 sonoma:        "b58359970a2a4a78a6b41e87a0e04655fa38d7ae90b772549dcb453eb5109af4"
    sha256 cellar: :any,                 ventura:       "a06709009c71b6e967ac55ca9b55f205ad9573c5f5c1fa7df9299f644187db8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15a0854f860c98762937da3a4f5b5665abf61e0414328d7877fd9a7ab1837c47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b98150882f6afe30125986edb1d822c19e6d00dc9d8e8cc0c2d0b15663f9c9af"
  end

  depends_on "pandoc" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/bash/eza"
    fish_completion.install "completions/fish/eza.fish"
    zsh_completion.install  "completions/zsh/_eza"

    args = %w[
      --standalone
      --from=markdown
      --to=man
    ]
    system "pandoc", *args, "man/eza.1.md", "-o", "eza.1"
    system "pandoc", *args, "man/eza_colors.5.md", "-o", "eza_colors.5"
    system "pandoc", *args, "man/eza_colors-explanation.5.md", "-o", "eza_colors-explanation.5"

    man1.install buildpath.glob("*.1")
    man5.install buildpath.glob("*.5")
  end

  test do
    testfile = "test.txt"
    touch testfile
    assert_match testfile, shell_output(bin/"eza")

    # Test git integration
    flags = "--long --git --no-permissions --no-filesize --no-user --no-time --color=never"
    eza_output = proc { shell_output("#{bin}/eza #{flags}").lines.grep(/#{testfile}/).first.split.first }
    system "git", "init"
    assert_equal "-N", eza_output.call
    system "git", "add", testfile
    assert_equal "N-", eza_output.call
    system "git", "commit", "-m", "Initial commit"
    assert_equal "--", eza_output.call

    linkage_with_libgit2 = (bin/"eza").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2"].opt_lib/shared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end