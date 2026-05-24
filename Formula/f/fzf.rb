class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://ghfast.top/https://github.com/junegunn/fzf/archive/refs/tags/v0.73.0.tar.gz"
  sha256 "393a79e3d504af3c5032508d2f33f1517a472bcad5c5081babf2b930f4fce74f"
  license "MIT"
  compatibility_version 1
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df93caf9e29a58ec1d2aac20a023b38c4320ba688da77769e909b56a4f5ed802"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df93caf9e29a58ec1d2aac20a023b38c4320ba688da77769e909b56a4f5ed802"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df93caf9e29a58ec1d2aac20a023b38c4320ba688da77769e909b56a4f5ed802"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f5944fac5b47c6a24e9e10af525798d60422ca89bf7976edefbce5c3c69a68a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98c1ca1dcecf4f6583f3cae532fd995c64d0f19f9dcb79b89079008d2fa3277f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45f2c7bc976921b4bf3a70330397c0c58e40bf4c2101a319aa28b3b41c08b888"
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