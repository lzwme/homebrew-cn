class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https:github.comeza-communityeza"
  url "https:github.comeza-communityezaarchiverefstagsv0.20.13.tar.gz"
  sha256 "aea362ca4330ddfdd72f725a26265a195da6709dc8c7a651b189128ed8dd836f"
  license "EUPL-1.2"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "77e1c150ffa9c34f1d9d595b58a8c83d1b391d70ebf1f7fd2ec15808bf592b78"
    sha256 cellar: :any,                 arm64_sonoma:  "fb7f3696f1f168f3033cf294a81747b4d956887abfb4c60f63432c012f3256bf"
    sha256 cellar: :any,                 arm64_ventura: "274ef54760cd0afeb7b949805f12aeae5797670675723e772b49cac7a0f612de"
    sha256 cellar: :any,                 sonoma:        "228d695045b3fa07fe992f9c5bf6930005d715856a56e515f5d21b7575afb7e7"
    sha256 cellar: :any,                 ventura:       "49a471008dc6b00a227ae49ae36a3a6e09cdddfe9e2c28cc9a461bc4451c4669"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60e2bd71d8c1b65e73c5d0435d78acd4489e60c71721138fe6688125d3001c00"
  end

  depends_on "pandoc" => :build
  depends_on "pkgconf" => :build
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