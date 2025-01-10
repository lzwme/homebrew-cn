class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https:github.comeza-communityeza"
  url "https:github.comeza-communityezaarchiverefstagsv0.20.16.tar.gz"
  sha256 "be5eb8d314f817bbfdcad4d21e66d2a8c4006ba4619735297b5233887ebdbe99"
  license "EUPL-1.2"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "037a3eb1e26c2d23cef52b0a310f37131946c51a830529ab81a94492cf62b58a"
    sha256 cellar: :any,                 arm64_sonoma:  "998c070811129b6a71953fc450b25d0a65663d3b99615f388ac6f28bb22349a8"
    sha256 cellar: :any,                 arm64_ventura: "c43d86e9a96d02864410bc463bd9ff26aae793a5ea609987dce7b4fee481de5b"
    sha256 cellar: :any,                 sonoma:        "cc37088f74be683b70c28a818ff8fb90db9efef27553d8a23962ed38e97563e0"
    sha256 cellar: :any,                 ventura:       "211f311e6e85c635bf275554844a7f5cc8a0236079f797a2eab4292801c6bd44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e809038d80e94dcae6681fb71f90eda3335f5c03a60086e5db3edb4aa9b51b5"
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