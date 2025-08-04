class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://ghfast.top/https://github.com/junegunn/fzf/archive/refs/tags/v0.65.1.tar.gz"
  sha256 "82fa35dc3ba5d716db26a507f90bb0e724f586123c28ad3fb376bd8384669abf"
  license "MIT"
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80dcf7961c82fa1b9bc4d7ea57e9983f97c989286f146c5e91ae5b992d0d5414"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80dcf7961c82fa1b9bc4d7ea57e9983f97c989286f146c5e91ae5b992d0d5414"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "80dcf7961c82fa1b9bc4d7ea57e9983f97c989286f146c5e91ae5b992d0d5414"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8e6dca557316f3f921c2fe0e9a4e072ee00b37053778394f4449cec8658556e"
    sha256 cellar: :any_skip_relocation, ventura:       "c8e6dca557316f3f921c2fe0e9a4e072ee00b37053778394f4449cec8658556e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f192b6b740b48c835ac6f0647bc95409cfb0da3b0d3fd2248d3bd761b971bcc"
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