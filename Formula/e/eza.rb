class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https:github.comeza-communityeza"
  url "https:github.comeza-communityezaarchiverefstagsv0.20.22.tar.gz"
  sha256 "81a8b5c86054042da50a9a7aad38117a051b7e9fd6de3bcece1391e39d2edfd4"
  license "EUPL-1.2"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fc58f637cf088181b52c359947e7488fcf74c1bea2ee72bc02538ba47edcbdcb"
    sha256 cellar: :any,                 arm64_sonoma:  "0827d28fae89d896294030e3ac291d2ea44861a3f7629df2ea6fc392d6dc0420"
    sha256 cellar: :any,                 arm64_ventura: "e204f35adddb6fc773c618d313ffa5261563970d1dd680c2ee20350d07a1a724"
    sha256 cellar: :any,                 sonoma:        "35bc67734566f512e99c10a5637061d8a747ed3190216795483b822768bcab0a"
    sha256 cellar: :any,                 ventura:       "48978e0ae1bae74ab7e83a8c61958a7351cfd3da48f9c20f212de812c8783580"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "611ac3ee15c0b2729074eea723a757f54e065cab64a1daf41b54590f98bc2438"
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