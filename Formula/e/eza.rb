class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https:github.comeza-communityeza"
  url "https:github.comeza-communityezaarchiverefstagsv0.18.11.tar.gz"
  sha256 "92d810c36ac67038e2ed3c421087de8793eb0b9de332c9239096df9d52eb30e3"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0d8dccb8950aaecd32935179f6b6294f0b1c0a9de5d0d54bc6e158d6ab69249d"
    sha256 cellar: :any,                 arm64_ventura:  "fb3da62bf109f321f8f5076c78cc770feea428d468cef23024337d7ffb596bf3"
    sha256 cellar: :any,                 arm64_monterey: "ba544525895e48ed0e823adf7211372ba9be8979defcda9b98e1fe8c066a3328"
    sha256 cellar: :any,                 sonoma:         "236c3772567a64a00801ded7ff0fc032606b1d57ec8b87339831e2db55e091ce"
    sha256 cellar: :any,                 ventura:        "ebe0d0bef0f94605b3cfcd90a6473eea9764c64a663538adc12b8d21e8caf44a"
    sha256 cellar: :any,                 monterey:       "54903369a162c249bbc496e3cd4ca6af8812fe3f5cd09cb0d71d26c65cc15873"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6af0883b1347735de92639d18332aa9d2edb580f59d7a50fb2a1a8e05195cec"
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