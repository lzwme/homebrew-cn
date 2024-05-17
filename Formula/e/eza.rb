class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https:github.comeza-communityeza"
  url "https:github.comeza-communityezaarchiverefstagsv0.18.16.tar.gz"
  sha256 "dd713474b902568cb2c7c8ea7db8e08db5818617e34908ae7142e9da9cefd17b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "20ed82961583c19e02657e71eeaaac70ab2893fd9d65373da81e7471e1e11873"
    sha256 cellar: :any,                 arm64_ventura:  "49d1f7cd6007644e51fb88c8c8370556f214073cace88d955c0656a1db032e9c"
    sha256 cellar: :any,                 arm64_monterey: "dafae673db953ebd8583c261ad530ad46ac868c715a91fcc2862788ff57ac7fb"
    sha256 cellar: :any,                 sonoma:         "1e8c2ce755a94b70018181579b4b582c6b621f1c810d3a7b54916ffb1672eeee"
    sha256 cellar: :any,                 ventura:        "8ad9f8f98b29c71cb9b31d4ffd0e81daa0bbdaa09765a03dca9bfd1f7d32c0bb"
    sha256 cellar: :any,                 monterey:       "f31b5f9955ba4f0ddc85deff18b54b1acf79f05879e2e2a09e1125155be8f940"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "132fe2da24d17ace516f40f3fbe77dafe4e84608b74cd66c7baa7b774325bc8c"
  end

  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  def install
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