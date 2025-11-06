class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://ghfast.top/https://github.com/junegunn/fzf/archive/refs/tags/v0.66.1.tar.gz"
  sha256 "ae70923dba524d794451b806dbbb605684596c1b23e37cc5100daa04b984b706"
  license "MIT"
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5406d31653c7c2989fc799d78499a1710ff36b5bd9da9ebae0b934bc9d89042"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5406d31653c7c2989fc799d78499a1710ff36b5bd9da9ebae0b934bc9d89042"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5406d31653c7c2989fc799d78499a1710ff36b5bd9da9ebae0b934bc9d89042"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa231a2b9d20034eefa6e2523a373ec7cc159e854c1432d9e64d92024d5ac472"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d300c47c985b47b680624b216aa268e3a7f31f05922490b08f91b97bed5426aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7046131db6361144cc501484444ac7362b70a72d7286f9b5c9345c06cb065022"
  end

  depends_on "go" => :build

  uses_from_macos "ncurses"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.revision=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)
    man1.install "man/man1/fzf.1", "man/man1/fzf-tmux.1"
    bin.install "bin/fzf-tmux"
    bin.install "bin/fzf-preview.sh"

    # Please don't install these into standard locations (e.g. `zsh_completion`, etc.)
    # See: https://github.com/Homebrew/homebrew-core/pull/137432
    #      https://github.com/Homebrew/legacy-homebrew/pull/27348
    #      https://github.com/Homebrew/homebrew-core/pull/70543
    prefix.install "install", "uninstall"
    (prefix/"shell").install %w[bash zsh fish].map { |s| "shell/key-bindings.#{s}" }
    (prefix/"shell").install %w[bash zsh].map { |s| "shell/completion.#{s}" }
    (prefix/"plugin").install "plugin/fzf.vim"
  end

  def caveats
    <<~EOS
      To set up shell integration, see:
        https://github.com/junegunn/fzf#setting-up-shell-integration
      To use fzf in Vim, add the following line to your .vimrc:
        set rtp+=#{opt_prefix}
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fzf --version")

    (testpath/"list").write %w[hello world].join($INPUT_RECORD_SEPARATOR)
    assert_equal "world", pipe_output("#{bin}/fzf -f wld", (testpath/"list").read).chomp
  end
end