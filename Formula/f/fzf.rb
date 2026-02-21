class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://ghfast.top/https://github.com/junegunn/fzf/archive/refs/tags/v0.68.0.tar.gz"
  sha256 "ed878dcb57e083129db5d8a28c656fd981ce90f12b67d32024888d33790ca3a6"
  license "MIT"
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b0f1a67861b1c0a7d5837d3e373c156f40fdcd58f0853425075066726f4097bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0f1a67861b1c0a7d5837d3e373c156f40fdcd58f0853425075066726f4097bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0f1a67861b1c0a7d5837d3e373c156f40fdcd58f0853425075066726f4097bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a262e9244952d2d856099770c8d482c9372aec99b41f1541e15e96d2ac84a21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6868118fd936c0965bba37dc0e9124802dba2160e61e46c19cdb37c1eb161c2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a9596490edf975970a13aa9423d264adba43b94a0e7b0e9d4a08c8bd98c5178"
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