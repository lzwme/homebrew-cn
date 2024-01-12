class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https:github.comeza-communityeza"
  url "https:github.comeza-communityezaarchiverefstagsv0.17.1.tar.gz"
  sha256 "78f56a35fc6707297f422647988b963f39bcef023bf55f6f2f5e7cd4be659a2a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "de1182166b43ee7676c07c755e9c81ae3eba19924f14ff79de2e0212bdbfa09f"
    sha256 cellar: :any,                 arm64_ventura:  "18b98db05f8bdc2e189dd0e476e64add07dd08542cc51d5fff68acc1de0b5fc2"
    sha256 cellar: :any,                 arm64_monterey: "027ec2051aff2cc8b2893c488718fe1aef52121eacbc4558f19773e148b9e554"
    sha256 cellar: :any,                 sonoma:         "773841cde0df3fe2b360315267451586c16df081bc4272d2847a256d2e2a5227"
    sha256 cellar: :any,                 ventura:        "03cbe783a2e02d74c8560f7c874d0f3f1563c34e7a9ae5262bdbc491dc9639ce"
    sha256 cellar: :any,                 monterey:       "159cee9c1da9f0e31f6b4c6c97e4dd327eceec1d66c86d783869623f5a027cda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0717c4065749b9eab62217444e475f1c282b25ebb200ffe57fcd1844a96ffd79"
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