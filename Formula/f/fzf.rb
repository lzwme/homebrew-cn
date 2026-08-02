class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://junegunn.github.io/fzf/"
  url "https://ghfast.top/https://github.com/junegunn/fzf/archive/refs/tags/v0.74.2.tar.gz"
  sha256 "3ce36bd4fb0cde458a7f93c11ef534408d92c3bf19e6acc90e112f3e9e2acc60"
  license "MIT"
  compatibility_version 1
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6137546bd641e541b2e37588880305e625d9b582f5fc70393109ed60f448d77f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6137546bd641e541b2e37588880305e625d9b582f5fc70393109ed60f448d77f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6137546bd641e541b2e37588880305e625d9b582f5fc70393109ed60f448d77f"
    sha256 cellar: :any_skip_relocation, sonoma:        "6427c0878c00d8bd79cba368de2146133e8a7caea289671378ecfbe7532de587"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd1efa897197c64c7279167b14550ff2ddfaefb61ceee75e8426b6ada2f777b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f047e92d46790a241f0b1fd860341b5c14978c2264fd04bf8cf1afb34d5fe0bd"
  end

  depends_on "go" => :build

  uses_from_macos "ncurses"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[
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