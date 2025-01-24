class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https:github.comeza-communityeza"
  url "https:github.comeza-communityezaarchiverefstagsv0.20.18.tar.gz"
  sha256 "b123a29747fe164d8f9851dae42155111bf38c8820b6bb51cd2453bd7f9be6bc"
  license "EUPL-1.2"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "02387d0536d4b60a4152dc715f89b4b37274170948073c0856e855545206500a"
    sha256 cellar: :any,                 arm64_sonoma:  "d339f9ab69eaca3066c2ed7e00b263671112c9062219c8a58f9a1fb6b08c179d"
    sha256 cellar: :any,                 arm64_ventura: "a017d9cfc60f038e4a84443ee2af0ba3aae432273d746175ef00cca79cebec6b"
    sha256 cellar: :any,                 sonoma:        "45c31669d17e6b0af9e51eb35902ba6b8111b061e639d73c55f2cec6433465ba"
    sha256 cellar: :any,                 ventura:       "521483ac6a9ece9ff04a079f72d2f96ab87225bbab9ef8330a8279fdc3b6ad48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac2aa5776e14e7a00fff10a38dc26461aac2330fb4bbe0c62a5b134e0de6a0d5"
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