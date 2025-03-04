class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https:github.comjunegunnfzf"
  url "https:github.comjunegunnfzfarchiverefstagsv0.60.3.tar.gz"
  sha256 "bdef337774050c26c6c4a6f38bc4ccb0901450854cd7f667cb3a330166a9ada5"
  license "MIT"
  head "https:github.comjunegunnfzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1124d444049ea2dc9d923143d5f2c782b6feb1363d982eaaa184189093d96545"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1124d444049ea2dc9d923143d5f2c782b6feb1363d982eaaa184189093d96545"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1124d444049ea2dc9d923143d5f2c782b6feb1363d982eaaa184189093d96545"
    sha256 cellar: :any_skip_relocation, sonoma:        "297501a786733ce02b17f0556639b119db14eb44b2dc1e8b138c265ce4c265a1"
    sha256 cellar: :any_skip_relocation, ventura:       "297501a786733ce02b17f0556639b119db14eb44b2dc1e8b138c265ce4c265a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2862b0887563608e244f1276ab13a6b6bf569e10f90dc12fcd65de53545f378"
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