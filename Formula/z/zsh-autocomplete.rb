class ZshAutocomplete < Formula
  desc "Real-time type-ahead completion for Zsh"
  homepage "https://github.com/marlonrichert/zsh-autocomplete"
  url "https://ghfast.top/https://github.com/marlonrichert/zsh-autocomplete/archive/refs/tags/26.08.03.tar.gz"
  sha256 "c550d1b195bc343e9fe32bfb4a6d0ccbfec24ebb9efd8efe95be35755bd3bbdb"
  license "MIT"
  head "https://github.com/marlonrichert/zsh-autocomplete.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c625537a82993e6adc6cb7cd264b5a9426711dfa690214929e393ae571c3bb9b"
  end

  depends_on "clitest" => :test
  uses_from_macos "zsh" => :test

  def install
    pkgshare.install Dir["*"]
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
    (testpath/"run-tests.zsh").write <<~SHELL
      #!/bin/zsh -f

      env -i HOME=$HOME PATH=$PATH FPATH=$FPATH zsh -f -- \
          =clitest --progress dot --prompt '%' -- $PWD/Tests/*.md
    SHELL

    cd pkgshare do
      system "zsh", testpath/"run-tests.zsh"
    end
  end
end