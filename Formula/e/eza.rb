class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https:github.comeza-communityeza"
  url "https:github.comeza-communityezaarchiverefstagsv0.20.1.tar.gz"
  sha256 "e78a84cc5324ebb6481293d32edfdbc7de78511d5190b4808a0896f8ce4d652e"
  license "EUPL-1.2"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8e3ff7111182bd6ae27622a052bdd9d14d6db7e100cabf08b68474c2e61853b0"
    sha256 cellar: :any,                 arm64_sonoma:  "d796b73c42a42d2e6cefa8a7afbcf0b4a8a70741df5826570a15de17c25e4c1c"
    sha256 cellar: :any,                 arm64_ventura: "8e4b46c7fa316b27047d869973c8e581d4450d7b7a6974cebff50c0bd0092eed"
    sha256 cellar: :any,                 sonoma:        "3f72f60ed9c8ef4faf2ef55e1d51f6fef9d4ee1b4fdedccd7d4c870804889e11"
    sha256 cellar: :any,                 ventura:       "417335e6b116fb2cb4a4080f3887a6e32a10f822678d8055b041af375ec58721"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "831abfd8be76d2969381daf6e664d54ee758b380b90085ba7c5046299fc4589b"
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