class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https:github.comeza-communityeza"
  url "https:github.comeza-communityezaarchiverefstagsv0.17.2.tar.gz"
  sha256 "272b341099d5f7839cf73b619f69c5cd3eb55e9a5ded9a29dd283795220f42f8"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0e7a835dd788c89feb75973ef5ca4eeb5c05e290e106b9ccfe2136d15e7253b6"
    sha256 cellar: :any,                 arm64_ventura:  "b7f129253628ab1647b8d2643299893dc08762909ffd1139c1291f49fadb66c5"
    sha256 cellar: :any,                 arm64_monterey: "45fd6713829c81ed37f5a915b2ccea9ff9761c70ae83c8a9ca519c4495f2f8a0"
    sha256 cellar: :any,                 sonoma:         "509a03bc1c0e66a961ca3c31d11e05745135c93205eb3ef8a62792923aee0f0a"
    sha256 cellar: :any,                 ventura:        "ab9bb15e9c1644f0a1fe978b538dd4437ea188e23d2502189ad3b055177a6fe9"
    sha256 cellar: :any,                 monterey:       "11c9399843fdacc1fbe2e3e507ef0b8cc367c4e8085291250a279b4c9ed871b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "852c6f754b4e8abdbb296e6e89c3b4746d9ba2cd985e513204b543eb3d1b23a2"
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