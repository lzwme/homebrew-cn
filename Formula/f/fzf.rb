class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https:github.comjunegunnfzf"
  url "https:github.comjunegunnfzfarchiverefstagsv0.60.2.tar.gz"
  sha256 "0df4bcba5519762ec2a51296d9b44f15543ec1f67946b027e0339a02b19a055c"
  license "MIT"
  head "https:github.comjunegunnfzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "659ef1f6197f2f1f584f524218e90f4bdecd7f8b38d67a3425e992f180ea8a47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "659ef1f6197f2f1f584f524218e90f4bdecd7f8b38d67a3425e992f180ea8a47"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "659ef1f6197f2f1f584f524218e90f4bdecd7f8b38d67a3425e992f180ea8a47"
    sha256 cellar: :any_skip_relocation, sonoma:        "645f3c9fe30aad8beeb660148fe38d59a3f365d57cce4871af4132b23f48623a"
    sha256 cellar: :any_skip_relocation, ventura:       "645f3c9fe30aad8beeb660148fe38d59a3f365d57cce4871af4132b23f48623a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3b618b50e87754841ab73c65bde6c804ecd6c0daa9f9582418edfc24ed083ee"
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