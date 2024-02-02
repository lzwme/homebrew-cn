class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https:github.comeza-communityeza"
  url "https:github.comeza-communityezaarchiverefstagsv0.18.0.tar.gz"
  sha256 "50f6187fa10eb7d2405477ed2b4dfbda7e51d3746b3660664f39b50d74c856a1"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fe6d7cb0ae6e79fecd20587aba5d626a86f3b636a424168cd03de50afd87efcd"
    sha256 cellar: :any,                 arm64_ventura:  "34f54d7ce4971242695d524f34b0b35de698fe73b2c030372a245449adf789f4"
    sha256 cellar: :any,                 arm64_monterey: "ada0f4d26f011ed37a731c5e3fcbb8f6c9f85d8afa7196dedfc57b58083161da"
    sha256 cellar: :any,                 sonoma:         "27b6f1e05a776eb54b01e3b8510a11470899a21d4a1098913d948553ad8f1751"
    sha256 cellar: :any,                 ventura:        "c7d0a20ba5065bf892fa51457d35be57e43925bd3f647eeb81d46a68192d4fd1"
    sha256 cellar: :any,                 monterey:       "4b7b3a22dbac5bf30254ff589fc2c0a6f05137f6d89b9d1e95f1ededd93e599b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f141d78799a3a0a2b4a51e4b09b5cbbb4a4714e83f3e59c0c499cdd060a09574"
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