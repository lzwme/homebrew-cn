class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https:github.comeza-communityeza"
  url "https:github.comeza-communityezaarchiverefstagsv0.18.2.tar.gz"
  sha256 "d2fcde456b04c8aebe72fcd9a3f73feca58dc5de1f1edf40de9387c211dbba8a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "69b5d1e9532e868c54806cea3fa9cae8fc63d672d65e178c338bb66b34faa91b"
    sha256 cellar: :any,                 arm64_ventura:  "be7f1a846e58f5541e2bbaa11e8d6354fc8a66bb817a09e5419e52ba375c525e"
    sha256 cellar: :any,                 arm64_monterey: "895af246727f098f36091772bdfb988269329c6a2c387b400379e6642a2f0fdf"
    sha256 cellar: :any,                 sonoma:         "e125a8a42246d8b11922a6af307d14b43de35b1d665fcca10350ab41a15b6861"
    sha256 cellar: :any,                 ventura:        "90cdd21184212b23d302a196ca5b9b06b104e94cf305165ff73b78e481d5ac3a"
    sha256 cellar: :any,                 monterey:       "d0bf33ab79c166b824cb6308ea990507c614aa7d43284d5243310f69a4b394d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69ae9222f8c6ca7e6b6d34d2be60f6e6ddeb306d18d4eca3ba326299c4af6bca"
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