class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://ghproxy.com/https://github.com/junegunn/fzf/archive/refs/tags/0.44.1.tar.gz"
  sha256 "295f3aec9519f0cf2dce67a14e94d8a743d82c19520e5671f39c71c9ea04f90c"
  license "MIT"
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "91b30c40eeb135cc8d7fc43883db66b888e96a9c993f1d9f97b70715017c33e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ddc4a849f777e7da251c665c1ff888bf96742f3b331179b2c87990cbac48fd51"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "709eae88f69641ec620c7837dd55f74601956e7127cc7bbb185df22235af76c0"
    sha256 cellar: :any_skip_relocation, sonoma:         "f42c837ffe0a6baea94c448807bd7322502719cdfeb2059ac39ccbd7d6c08471"
    sha256 cellar: :any_skip_relocation, ventura:        "a03539e95924bec724c781214acbb75b7c3aaf90b46a2fa4636c68ce8f31a63e"
    sha256 cellar: :any_skip_relocation, monterey:       "50d3932e2a006b801400962d0c9be1e5b728d483aa6a8cd8d50b5cf9442e8278"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39ebf3482ffaa9201dbec9bc781803f5926872982bb382a5e1be8d8dcc849525"
  end

  depends_on "go" => :build

  uses_from_macos "ncurses"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.revision=brew")
    man1.install "man/man1/fzf.1", "man/man1/fzf-tmux.1"
    bin.install "bin/fzf-tmux"

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
      To install useful keybindings and fuzzy completion:
        #{opt_prefix}/install

      To use fzf in Vim, add the following line to your .vimrc:
        set rtp+=#{opt_prefix}
    EOS
  end

  test do
    (testpath/"list").write %w[hello world].join($INPUT_RECORD_SEPARATOR)
    assert_equal "world", pipe_output("#{bin}/fzf -f wld", (testpath/"list").read).chomp
  end
end