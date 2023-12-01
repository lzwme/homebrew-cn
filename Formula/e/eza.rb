class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https://github.com/eza-community/eza"
  url "https://ghproxy.com/https://github.com/eza-community/eza/archive/refs/tags/v0.16.2.tar.gz"
  sha256 "4eef35467095f6006eb5c0431e6cafa514a885f571dcf9fef7c7d5952e90688f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7c0592f4087076eeb69356bdb68d7505ec4f444c21324049e4c8eb1f2545c4e8"
    sha256 cellar: :any,                 arm64_ventura:  "f32e9d39956539afb7a1a7dbea8e6eee942e14e9c8b4714f262e7afb3ee4d3f4"
    sha256 cellar: :any,                 arm64_monterey: "2c7434a5d1b3f4b86d0a9c03d0342f50bdc2eb80ac879ee4b0a7905c750eb5a7"
    sha256 cellar: :any,                 sonoma:         "d439704e390b259f1b8fee731bd765bc149850e43b0903801021e90f244ae6e1"
    sha256 cellar: :any,                 ventura:        "8df11642564ae81fe2425b302b53e0409c5b7ba60572739d6a7a95466d008632"
    sha256 cellar: :any,                 monterey:       "7fc228197f720ecc4ac994a0e79e7bba84c2a0e97f732efdd8550c3f56178cd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00b0746b3655bb621d458ec2eca2a4bbe8e1ad75531276c66b48b4e40af7d30c"
  end

  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  def install
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