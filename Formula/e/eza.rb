class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https:github.comeza-communityeza"
  url "https:github.comeza-communityezaarchiverefstagsv0.18.23.tar.gz"
  sha256 "34b0e8a699ac1a8a308448f417f0c0137a67ea34e261fd6f106e8be9fd5bb54c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d717bce0850b759078064d1310ae01f12412ba73c949d04fd9ac199452466092"
    sha256 cellar: :any,                 arm64_ventura:  "30306350dc1e79cfad0a4732abaa9cbe593b74a567666a3898b29cd10d140436"
    sha256 cellar: :any,                 arm64_monterey: "90b8220d18956541b78cf5da0efe6d797f3a8b6487cc143bcbf2e28b445235b5"
    sha256 cellar: :any,                 sonoma:         "8525a91c2951b33d63c8e51007bb57d49e93332871058d038c906f1c0dfe8181"
    sha256 cellar: :any,                 ventura:        "8bc40e42fa247bb3927f4725649355da393f5f65a6beaab4e8e51fdf76f37b56"
    sha256 cellar: :any,                 monterey:       "6bbca5e3d547ff080b7d81cbcef2c957b83bb600b3dc5c3c65ecc1348fe5f8be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bc97415bdb91433606ed976b0ee502d4d2967e84c5d68ce1901625f330a19a8"
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