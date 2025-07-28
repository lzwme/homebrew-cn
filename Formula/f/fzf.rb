class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://ghfast.top/https://github.com/junegunn/fzf/archive/refs/tags/v0.65.0.tar.gz"
  sha256 "766e989220453f4b7753a4e99732da5e8550ae3184b3580ffd0c957cabd557b0"
  license "MIT"
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ccb9f330646341917b9f7a9d6f94c3e197a658cf34d8058238e1f9da3600171"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ccb9f330646341917b9f7a9d6f94c3e197a658cf34d8058238e1f9da3600171"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6ccb9f330646341917b9f7a9d6f94c3e197a658cf34d8058238e1f9da3600171"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a61024e92bb39b8f4f3fefd070462095478479cf0b28ef75bbe3bd1cebdfd4d"
    sha256 cellar: :any_skip_relocation, ventura:       "1a61024e92bb39b8f4f3fefd070462095478479cf0b28ef75bbe3bd1cebdfd4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b031e02b82952420acde5909eebcd1c133cf404560c116ca3187775d3b619aa"
  end

  depends_on "go" => :build

  uses_from_macos "ncurses"

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.revision=brew
    ]

    # FIXME: we shouldn't need this, but patchelf.rb does not seem to work well with the layout of Aarch64 ELF files
    ldflags += ["-extld", ENV.cc] if OS.linux? && Hardware::CPU.arm?

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