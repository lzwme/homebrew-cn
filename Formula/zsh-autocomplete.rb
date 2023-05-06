class ZshAutocomplete < Formula
  desc "Real-time type-ahead completion for Zsh"
  homepage "https://github.com/marlonrichert/zsh-autocomplete"
  url "https://ghproxy.com/https://github.com/marlonrichert/zsh-autocomplete/archive/refs/tags/23.05.02.tar.gz"
  sha256 "389eeb63352797d25f38ef134228f9d43f11e4c18ae414a2f76f58e0ee570023"
  license "MIT"
  head "https://github.com/marlonrichert/zsh-autocomplete.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "61e45093eb0979a79b48589c0d98d19c59fda98ca6bd821f87a4ddf14d3dcf79"
  end

  depends_on "clitest" => :test
  uses_from_macos "zsh" => :test

  def install
    pkgshare.install Dir["*"] + [".clitest"]
  end

  def caveats
    <<~EOS
      Installation
      1. Add at or near the top of your .zshrc file (before any calls to compdef):
        source #{HOMEBREW_PREFIX}/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
      2. Remove any calls to compinit from your .zshrc file.
      3. If you're using Ubuntu, add to your .zshenv file:
        skip_global_compinit=1
      Then restart your shell.
      For more details, see:
        https://github.com/marlonrichert/zsh-autocomplete
    EOS
  end
  test do
    (testpath/"run-tests.zsh").write <<~EOS
      #!/bin/zsh -f

      env -i HOME=$HOME PATH=$PATH FPATH=$FPATH zsh -f -- \
          =clitest --progress dot --prompt '%' -- $PWD/.clitest/*.md
    EOS
    cd pkgshare do
      system "zsh", testpath/"run-tests.zsh"
    end
  end
end