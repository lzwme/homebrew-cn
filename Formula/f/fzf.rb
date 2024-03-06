class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https:github.comjunegunnfzf"
  url "https:github.comjunegunnfzfarchiverefstags0.46.1.tar.gz"
  sha256 "b0d640be3ae79980fdf461096f7d9d36d38ec752e25f8c4d2ca3ca6c041c2491"
  license "MIT"
  head "https:github.comjunegunnfzf.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "69ef5575b142713f6227437765952201b1822980f930a55c21255e2e98bda92b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a7b531802ccb80f14aa7dfe43b1ff3b8730b828439c219f45c45f85dc83afae6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9926e057dbbf11e9ab026737d62e19f2da742cf59b7026927efb5ce89a218d7e"
    sha256 cellar: :any_skip_relocation, sonoma:         "e0f0ab09c4c503702acb75f0e484fb0c5b1c9d1de4134ae5318d75a7e2fafb16"
    sha256 cellar: :any_skip_relocation, ventura:        "8d618a54fbd7a2450f234348888b2042b68e97b6ca3289fc5b54be52f862d3c8"
    sha256 cellar: :any_skip_relocation, monterey:       "11df26d2709d5ec2a08c496b69c92213adbf81cdc3efd64fafc8963a70530e73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75da72028d3f94c4882dc9d264c74515491673eacb6ffa390cf8dee5bcc467bb"
  end

  depends_on "go" => :build

  uses_from_macos "ncurses"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.revision=brew")
    man1.install "manman1fzf.1", "manman1fzf-tmux.1"
    bin.install "binfzf-tmux"

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
      To install useful keybindings and fuzzy completion:
        #{opt_prefix}install

      To use fzf in Vim, add the following line to your .vimrc:
        set rtp+=#{opt_prefix}
    EOS
  end

  test do
    (testpath"list").write %w[hello world].join($INPUT_RECORD_SEPARATOR)
    assert_equal "world", pipe_output("#{bin}fzf -f wld", (testpath"list").read).chomp
  end
end