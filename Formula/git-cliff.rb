class GitCliff < Formula
  desc "Highly customizable changelog generator"
  homepage "https://github.com/orhun/git-cliff"
  url "https://ghproxy.com/https://github.com/orhun/git-cliff/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "26f05e4cfea07768d06ae92cd4b34bae786ed354089d9b5b1659d6408bf583c6"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "140c4efcb8b45ef6e10c03149cbe389902d5760975946735b2332bd4ab0ab1d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86a236c3ee1bcc79834b2577f2390294e35cab2dec7d071dff068c2e7f113a94"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b691a7e991fb2ae72769ad154554950b5146814f7770ddd929418ad2585f6e04"
    sha256 cellar: :any_skip_relocation, ventura:        "ff442e44188be57039d40a8f699a5ea1a435afb48b369f7ebf619cc8fc2717bd"
    sha256 cellar: :any_skip_relocation, monterey:       "c6005bd7415db2a68e38c465a086b8ba4b728f31d108b00d27b65ddfad8a1115"
    sha256 cellar: :any_skip_relocation, big_sur:        "cd37cb16494736347f879cdc3b6caae77fa5d831e6c129525f56e51197d9e554"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5f6579d52cdb2eb44b30928ce0d892d4e5b8d774f3f2722f0b9100772d79f23"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args(path: "git-cliff")

    ENV["OUT_DIR"] = buildpath
    system bin/"git-cliff-completions"
    bash_completion.install "git-cliff.bash"
    fish_completion.install "git-cliff.fish"
    zsh_completion.install "_git-cliff"
  end

  test do
    system "git", "cliff", "--init"
    assert_predicate testpath/"cliff.toml", :exist?

    system "git", "init"
    system "git", "add", "cliff.toml"
    system "git", "commit", "-m", "chore: initial commit"
    changelog = "### Miscellaneous Tasks\n\n- Initial commit"
    assert_match changelog, shell_output("git cliff")
  end
end