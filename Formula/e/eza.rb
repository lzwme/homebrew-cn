class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https:github.comeza-communityeza"
  url "https:github.comeza-communityezaarchiverefstagsv0.20.21.tar.gz"
  sha256 "bb0e33c280f49f8be226eff4ff3773bbbe595ac716b74817b9901248df6bcfd3"
  license "EUPL-1.2"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d3efb9ae8f602fac2fbc04dd7c9fc0db67bedf777752565e8fbb484851f00383"
    sha256 cellar: :any,                 arm64_sonoma:  "a8df9b9f360d4518452a404c42fca3f23bea65bad70cb6270829a270fb481477"
    sha256 cellar: :any,                 arm64_ventura: "9a51d6ba7f403665b579d5061a27a975ee778282aa742707da828b3baaf10ad3"
    sha256 cellar: :any,                 sonoma:        "20590f72e516ce21ee3164a3966b4615e6547e2f5feb440589d60a7c9f5064d3"
    sha256 cellar: :any,                 ventura:       "d2d73a16c0c2db2ac0597b3743516b0016151ea6b0e197508876d89cf1d20ef5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c0221889eebf7200e710a7d80167638fba3759d65f29879e7d4b451b07f94cd"
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