class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https:github.comjunegunnfzf"
  url "https:github.comjunegunnfzfarchiverefstags0.46.0.tar.gz"
  sha256 "56d0ecaaff90dd33c371f7d23d1fd1cb36eb42554e88284c2781a067fba2a645"
  license "MIT"
  head "https:github.comjunegunnfzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f2da6382578bab8e641a7fd95f09de02f0f9dacd5e0dea182bc698f3c54d1adb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f79e9c1fb012c953bcb107ba1ab82657954e3d3b4e3959f91cdb34356800cf29"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e720d6a80641dc17fce4d31932ca553f428337c5e422994a1b8d7d9d98f666a"
    sha256 cellar: :any_skip_relocation, sonoma:         "89f079a8d8810a171e43c245ebdab52df3680996269bb86a07aafc50513a52a6"
    sha256 cellar: :any_skip_relocation, ventura:        "2ca90055c2dbf6e4a1bb00ac78bf73095344114be1b0e90c4a26c86a90a51437"
    sha256 cellar: :any_skip_relocation, monterey:       "479dc852a2ec4052124d0509fdbf2982c7321f05785200143845cb3983dd8cf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d90cb3746a431123646ad8adfb0120985e7e81898d1d7c290d533f28a2d1f48"
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