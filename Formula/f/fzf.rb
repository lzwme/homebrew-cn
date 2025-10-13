class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://ghfast.top/https://github.com/junegunn/fzf/archive/refs/tags/v0.66.0.tar.gz"
  sha256 "576659beee244b4ecccf45f1c576340143d8ce6d97fa053e6cbdd3f75c66b351"
  license "MIT"
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "34eeee4580632d265e83e01d453eb35534d6a6b7d849f95c1a8e91eedc4e4d34"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34eeee4580632d265e83e01d453eb35534d6a6b7d849f95c1a8e91eedc4e4d34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34eeee4580632d265e83e01d453eb35534d6a6b7d849f95c1a8e91eedc4e4d34"
    sha256 cellar: :any_skip_relocation, sonoma:        "71087c8d8d010ad5d806223497bf9aa9aec932a1ac550f9d131ffa775c16207b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "492255314aa7a150c17ef17da99f8bb843b55b93ab93a631661f565bb4838bcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a2166c6341bc7d9c92324a4e17d376a21f8bf9653e8109d3ecae3c72701d3eb"
  end

  depends_on "go" => :build

  uses_from_macos "ncurses"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.revision=brew
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
    (testpath/"list").write %w[hello world].join($INPUT_RECORD_SEPARATOR)
    assert_equal "world", pipe_output("#{bin}/fzf -f wld", (testpath/"list").read).chomp
  end
end