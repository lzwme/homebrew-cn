class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https:github.comeza-communityeza"
  url "https:github.comeza-communityezaarchiverefstagsv0.20.0.tar.gz"
  sha256 "e6c058b13aecbed9f037c0607f0df19bc0a3532fea14dacd0090878ed4bbfadc"
  license "EUPL-1.2"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "788df3ac2e6a0db487ac7743cbc64f662a00be90a570848f351683b82ebde558"
    sha256 cellar: :any,                 arm64_sonoma:  "0dfeea942dbc792bee505af642d39673bde9713b09ad0c537d524be3acd59ae1"
    sha256 cellar: :any,                 arm64_ventura: "1b1c785be787ba5bc1b4836ed6e909d5e883461248af8269148f0452f45f9897"
    sha256 cellar: :any,                 sonoma:        "5b2c564108b95b375e3f4bdf33e4c1248772b4cbe1736d370b00ca33157023c5"
    sha256 cellar: :any,                 ventura:       "02a9bee00b362386e012e9d97cfba00c47ddb1bfed088ee270b58dda89b3854b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c1f776eff84d198d6225fad1326bc6faea25c3e616d58a8e6ff0075166cb065"
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