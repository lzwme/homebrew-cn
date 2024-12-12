class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https:github.comeza-communityeza"
  url "https:github.comeza-communityezaarchiverefstagsv0.20.12.tar.gz"
  sha256 "c40edf02e662f6bba4997a3d497a30561c3d2de9a329f9869761acf8b7f69562"
  license "EUPL-1.2"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f0a2a8c04008b57a1d5405c4cc08af46d759f2f353f8a54c33e92e48fd260f0b"
    sha256 cellar: :any,                 arm64_sonoma:  "9418d3ae9b67f518a8f02903f83186e6a4292fac1e47a81cfb1e51240d1b0852"
    sha256 cellar: :any,                 arm64_ventura: "b3d31100f87ed068c5db0c49938b34360beaba913adbb89108fbcfaf274567ab"
    sha256 cellar: :any,                 sonoma:        "371ff459d8dc2919500f5b2dbbafeab9148594d5c81e8b6d800ecd1ff4f1db22"
    sha256 cellar: :any,                 ventura:       "9b4b6122229932ded8fe55d1df18c474e19497f37b23c87211d991a4f13cf504"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1d99ed85c6a6874f75e747c61243a78b91686ff924e1855b3cac9c2dc1f0420"
  end

  depends_on "pandoc" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args

    bash_completion.install "completionsbasheza"
    fish_completion.install "completionsfisheza.fish"
    zsh_completion.install  "completionszsh_eza"

    args = %w[
      --standalone
      --from=markdown
      --to=man
    ]
    system "pandoc", *args, "maneza.1.md", "-o", "eza.1"
    system "pandoc", *args, "maneza_colors.5.md", "-o", "eza_colors.5"
    system "pandoc", *args, "maneza_colors-explanation.5.md", "-o", "eza_colors-explanation.5"

    man1.install buildpath.glob("*.1")
    man5.install buildpath.glob("*.5")
  end

  test do
    testfile = "test.txt"
    touch testfile
    assert_match testfile, shell_output(bin"eza")

    # Test git integration
    flags = "--long --git --no-permissions --no-filesize --no-user --no-time --color=never"
    eza_output = proc { shell_output("#{bin}eza #{flags}").lines.grep(#{testfile}).first.split.first }
    system "git", "init"
    assert_equal "-N", eza_output.call
    system "git", "add", testfile
    assert_equal "N-", eza_output.call
    system "git", "commit", "-m", "Initial commit"
    assert_equal "--", eza_output.call

    linkage_with_libgit2 = (bin"eza").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2"].opt_libshared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end