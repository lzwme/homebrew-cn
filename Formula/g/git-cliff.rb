class GitCliff < Formula
  desc "Highly customizable changelog generator"
  homepage "https://git-cliff.org/"
  url "https://ghfast.top/https://github.com/orhun/git-cliff/archive/refs/tags/v2.14.1.tar.gz"
  sha256 "22f01e016a02d674eb23afee3f0169a725352cc42d54549ecdb031e8f59e87e6"
  license all_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f1469b965d447eab2f22ff600e5a6de3e29d19eed29c45a1dc4c1a72b7be7cb5"
    sha256 cellar: :any, arm64_tahoe:       "072b4479c491735a3b9a9fc14e9e89185544a05ecfb7c2e952ae279ca4fc4916"
    sha256 cellar: :any, arm64_sequoia:     "3dc1436aa45d691ad40be4e43def42d9881c0e97b014fafd86708c2a416fdd73"
    sha256 cellar: :any, arm64_sonoma:      "42646c0692caca88ab31ec5a83f8d8a2f5ad6ab9851924b3b87c2ecb7d337232"
    sha256 cellar: :any, arm64_linux:       "46a3c55d055289346f60002db8f084003bfc7d418c7e3802c73a12e720635631"
    sha256 cellar: :any, x86_64_linux:      "eef4c5cd83097093c04bd6f8ad39ab0a8a86172c24a722f7d42796f0d18703e5"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "git-cliff")

    # Setup buildpath for completions and manpage generation
    ENV["OUT_DIR"] = buildpath

    # Generate completions
    system bin/"git-cliff-completions"
    bash_completion.install "git-cliff.bash" => "git-cliff"
    fish_completion.install "git-cliff.fish"
    zsh_completion.install "_git-cliff"

    # generate manpage
    system bin/"git-cliff-mangen"
    man1.install "git-cliff.1"

    # no need to ship `git-cliff-completions` and `git-cliff-mangen` binaries
    rm [bin/"git-cliff-completions", bin/"git-cliff-mangen"]
  end

  test do
    system "git", "cliff", "--init"
    assert_path_exists testpath/"cliff.toml"

    system "git", "init"
    system "git", "add", "cliff.toml"
    system "git", "commit", "-m", "chore: initial commit"

    assert_equal <<~MARKDOWN, shell_output("git cliff")
      ## [unreleased]

      ### ⚙️ Miscellaneous Tasks

      - Initial commit
    MARKDOWN

    require "utils/linkage"
    library = formula_opt_lib("libgit2")/shared_library("libgit2")
    assert Utils.binary_linked_to_library?(bin/"git-cliff", library),
           "No linkage with #{library.basename}! Cargo is likely using a vendored version."
  end
end