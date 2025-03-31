class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https:github.comjunegunnfzf"
  url "https:github.comjunegunnfzfarchiverefstagsv0.61.0.tar.gz"
  sha256 "5d72cdf708c6adc240b3b43dfecd218cf4703ea609422fb4d62812e9f79f0a12"
  license "MIT"
  head "https:github.comjunegunnfzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18cd8adbcd003cde3aac476bf86a20acd17d5a8e0051a86150d76e6d6cddd66c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18cd8adbcd003cde3aac476bf86a20acd17d5a8e0051a86150d76e6d6cddd66c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "18cd8adbcd003cde3aac476bf86a20acd17d5a8e0051a86150d76e6d6cddd66c"
    sha256 cellar: :any_skip_relocation, sonoma:        "8abadf1e9641303e7866858907808fff899e252a4682e6f41475fc5ef35ced70"
    sha256 cellar: :any_skip_relocation, ventura:       "8abadf1e9641303e7866858907808fff899e252a4682e6f41475fc5ef35ced70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e26dd087b1a3d88f3eb95abd0965ff20535718ba9a39eca0ef359705d7bfbd5"
  end

  depends_on "go" => :build

  uses_from_macos "ncurses"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.revision=brew")
    man1.install "manman1fzf.1", "manman1fzf-tmux.1"
    bin.install "binfzf-tmux"
    bin.install "binfzf-preview.sh"

    # Please don't install these into standard locations (e.g. `zsh_completion`, etc.)
    # See: https:github.comHomebrewhomebrew-corepull137432
    #      https:github.comHomebrewlegacy-homebrewpull27348
    #      https:github.comHomebrewhomebrew-corepull70543
    prefix.install "install", "uninstall"
    (prefix"shell").install %w[bash zsh fish].map { |s| "shellkey-bindings.#{s}" }
    (prefix"shell").install %w[bash zsh].map { |s| "shellcompletion.#{s}" }
    (prefix"plugin").install "pluginfzf.vim"
  end

  def caveats
    <<~EOS
      To set up shell integration, see:
        https:github.comjunegunnfzf#setting-up-shell-integration
      To use fzf in Vim, add the following line to your .vimrc:
        set rtp+=#{opt_prefix}
    EOS
  end

  test do
    (testpath"list").write %w[hello world].join($INPUT_RECORD_SEPARATOR)
    assert_equal "world", pipe_output("#{bin}fzf -f wld", (testpath"list").read).chomp
  end
end