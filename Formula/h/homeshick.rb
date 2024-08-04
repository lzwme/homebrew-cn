class Homeshick < Formula
  desc "Git dotfiles synchronizer written in bash"
  homepage "https:github.comandsenshomeshick"
  url "https:github.comandsenshomeshickarchiverefstagsv2.0.1.tar.gz"
  sha256 "949f5de3c7f235ceb37c08e0cc8f3f7ad166f741a8fd01bf4b935a2031e37557"
  license "MIT"
  head "https:github.comandsenshomeshick.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "619e2b433b3d43170b65dff75fa3f204a021a166a54d96c0e07e3ee3523c0efd"
  end

  def install
    inreplace "binhomeshick", ^homeshick=.*, "homeshick=#{opt_prefix}"

    prefix.install "lib", "homeshick.sh"
    fish_function.install "homeshick.fish"
    bin.install "binhomeshick"
    zsh_completion.install "completions_homeshick"
    bash_completion.install "completionshomeshick-completion.bash"
    fish_completion.install "completionshomeshick.fish"
  end

  def caveats
    <<~EOS
      To enable the `homeshick cd <CASTLE>` command, you need to
        `export HOMESHICK_DIR=#{opt_prefix}`
      and
        `source "#{opt_prefix}homeshick.sh"`
      in your $HOME.bashrc
    EOS
  end

  test do
    (testpath"test.sh").write <<~EOS
      #!binsh
      export HOMESHICK_DIR="#{opt_prefix}"
      source "#{opt_prefix}homeshick.sh"
      homeshick generate test
      homeshick list
    EOS
    assert_match "test", shell_output("bash #{testpath}test.sh")
  end
end