class Homeshick < Formula
  desc "Git dotfiles synchronizer written in bash"
  homepage "https:github.comandsenshomeshick"
  url "https:github.comandsenshomeshickarchiverefstagsv2.0.1.tar.gz"
  sha256 "949f5de3c7f235ceb37c08e0cc8f3f7ad166f741a8fd01bf4b935a2031e37557"
  license "MIT"
  head "https:github.comandsenshomeshick.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "9a93b6514577c36a3de2d9c6a8c3cf9474a6534cc9547407f49ebc0325b20a8d"
  end

  def install
    inreplace "binhomeshick", ^homeshick=.*, "homeshick=#{opt_prefix}"

    prefix.install "lib", "homeshick.sh"
    fish_function.install "homeshick.fish"
    bin.install "binhomeshick"
    zsh_completion.install "completions_homeshick"
    bash_completion.install "completionshomeshick-completion.bash" => "homeshick"
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
    (testpath"test.sh").write <<~SHELL
      #!binsh
      export HOMESHICK_DIR="#{opt_prefix}"
      source "#{opt_prefix}homeshick.sh"
      homeshick generate test
      homeshick list
    SHELL

    assert_match "test", shell_output("bash #{testpath}test.sh")
  end
end