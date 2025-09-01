class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https://github.com/eza-community/eza"
  url "https://ghfast.top/https://github.com/eza-community/eza/archive/refs/tags/v0.23.1.tar.gz"
  sha256 "4c49f3ee6fc76ef45c489cd664eb2c68d96cda31b427605a48b074bcf269ee05"
  license "EUPL-1.2"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f717045cc48655b1fa869bdc4bf8fa0e96d4db4aba98802604fb68ec97744733"
    sha256 cellar: :any,                 arm64_sonoma:  "f6153b14469156ffd8a9a7828ee6a73064d5a08c5ecf6391432d261268cb8f2a"
    sha256 cellar: :any,                 arm64_ventura: "e10222333e9ea71fe889ae8f2ba350f113786964b7a8bd01cf4721278fed6f38"
    sha256 cellar: :any,                 sonoma:        "766b001042faed41f76c934dae7bf9ea3bcf01c030abaa9e3f8191a151b36bb8"
    sha256 cellar: :any,                 ventura:       "38d93947719d40dc95a1b3e35585c0d1409809e58ca6a2c23de3ea80a519ba09"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8823d51869d93c7497a20e8a9e0594619b992c1cdf9b8920e78ea5ac896d0093"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fa084e7c6942a8e7467fd65260e75112f1495bce18cd909e473d68501fced13"
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
    # `eza` is broken when not passed a file or directory name.
    # https://github.com/eza-community/eza/issues/1568
    assert_match testfile, shell_output("#{bin}/eza #{testpath}")

    # Test git integration
    flags = "--long --git --no-permissions --no-filesize --no-user --no-time --color=never"
    eza_output = proc { shell_output("#{bin}/eza #{flags} #{testpath}").lines.grep(/#{testfile}/).first.split.first }
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