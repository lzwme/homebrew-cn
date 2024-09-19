class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https:github.comeza-communityeza"
  url "https:github.comeza-communityezaarchiverefstagsv0.19.4.tar.gz"
  sha256 "c0094b3ee230702d4dd983045e38ea2bd96375c16381c0206c88fae82fb551a4"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4e3bc60184bee89a387b1e717ab976ed944beb85cd73f808690a603c133eaff0"
    sha256 cellar: :any,                 arm64_sonoma:  "466fdab661c55fb4295a77a107a364ffe086145feae8702f809cc8fa929bcf27"
    sha256 cellar: :any,                 arm64_ventura: "b7829b78bcdceddf5d87211582ca0cb1e98f6662d09733f873958a93e6d597c3"
    sha256 cellar: :any,                 sonoma:        "9d9f0274c05324692217796ed6767ddf8b4a9702b807f5b9a6a230a4f78b165e"
    sha256 cellar: :any,                 ventura:       "bf078efbe1ea26b5e9328105e280cbd5673a829e4013a07023d01ba70980652f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "532eb1023c624dd5ae0844d0a9e5bd5b5ed06584e02c7a8a9c6298269c706c21"
  end

  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
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