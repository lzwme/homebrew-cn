class GitCliff < Formula
  desc "Highly customizable changelog generator"
  homepage "https:github.comorhungit-cliff"
  url "https:github.comorhungit-cliffarchiverefstagsv2.5.0.tar.gz"
  sha256 "87b424657f5843fc08b544e5beb1f97c6b86ef6e90465b570ed41a343e90f135"
  license all_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "b32a5328db6de812ae1a45ad8b32fdfedd66d17138dd0de890a40f2a93830361"
    sha256 cellar: :any,                 arm64_sonoma:   "3d4f051b451ddf6dced4a64a2327aedb068e84f42b775e181ed648a294ce5b88"
    sha256 cellar: :any,                 arm64_ventura:  "d1a92c088bb3424b89199b53ae893317e246f677877d7903bf7d79ea6b96be7d"
    sha256 cellar: :any,                 arm64_monterey: "2db35980e5c9582b6589c26175274ea5733d85e17293f5dd9d5f74d4b1a172e1"
    sha256 cellar: :any,                 sonoma:         "877c4631bbcaddf36fb42648562fd9da56305d15901fcb0bb69b395df7b573d2"
    sha256 cellar: :any,                 ventura:        "3d032e82ea2f97e26d9990ed589e2b3a6fa33e35f9468e63bae19f3e9288dcec"
    sha256 cellar: :any,                 monterey:       "53e989b00dd041a673710dc1aec613dfe6dc014d3256635ec8e02e4e1ea01fd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8312f53514bc6b22e01b131d0f26f8a6fb1cf2c5a76bc690cdaeb29701af9454"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "git-cliff")

    # Setup buildpath for completions and manpage generation
    ENV["OUT_DIR"] = buildpath

    # Generate completions
    system bin"git-cliff-completions"
    bash_completion.install "git-cliff.bash" => "git-cliff"
    fish_completion.install "git-cliff.fish"
    zsh_completion.install "_git-cliff"

    # generate manpage
    system bin"git-cliff-mangen"
    man1.install "git-cliff.1"

    # no need to ship `git-cliff-completions` and `git-cliff-mangen` binaries
    rm [bin"git-cliff-completions", bin"git-cliff-mangen"]
  end

  test do
    system "git", "cliff", "--init"
    assert_predicate testpath"cliff.toml", :exist?

    system "git", "init"
    system "git", "add", "cliff.toml"
    system "git", "commit", "-m", "chore: initial commit"

    assert_match <<~EOS, shell_output("git cliff")
      All notable changes to this project will be documented in this file.

      ## [unreleased]

      ### ⚙️ Miscellaneous Tasks

      - Initial commit
    EOS

    linkage_with_libgit2 = (bin"git-cliff").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2"].opt_libshared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end