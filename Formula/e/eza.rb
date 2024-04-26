class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https:github.comeza-communityeza"
  url "https:github.comeza-communityezaarchiverefstagsv0.18.13.tar.gz"
  sha256 "679fd3b5b389553aa77a2bce496e8658848ef0f4624968fd1a330dbe92032438"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b858b99fcdcd9df4b39e2e5ce419e149325a981fc27556d29195d449f3b84543"
    sha256 cellar: :any,                 arm64_ventura:  "d22223b7bf2d9a5dbaec3c3a773e7448667c2aa85f3749794ff179d2df3fb0e4"
    sha256 cellar: :any,                 arm64_monterey: "12a95474e90f025ff9e0b16a8dba1592b3aae34d0f27aa741874bd5de8787afe"
    sha256 cellar: :any,                 sonoma:         "6faf904c890dfd3c9a1e1879309b328a0bee54f9f8ed3aa2cedb375d8609aaf8"
    sha256 cellar: :any,                 ventura:        "7a65dd9953f5172ef6b6a938f4da13a848a26a96c5dda166d5003c6e424971c4"
    sha256 cellar: :any,                 monterey:       "d2541131fdef6333357a65d55f460b01e5f11095ced7b9c563b105df72816513"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a577161eda4c7a1d870b21da914a29d7029991628428265d0cf1fbb556213b3"
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