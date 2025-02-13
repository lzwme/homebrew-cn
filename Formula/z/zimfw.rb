class Zimfw < Formula
  desc "Zsh plugin manager"
  homepage "https:zimfw.sh"
  url "https:github.comzimfwzimfwreleasesdownloadv1.17.1zimfw.zsh.gz"
  sha256 "c9ff0392a6b6a7edaf65a21e8f9fed6fcd40bb7f9374e52942a35cdd40bb9c0a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a4addd17b99cf3280e6431695d579fd363e6b6873f6c3de7689f429bd1b20455"
  end

  uses_from_macos "zsh" => :test

  def install
    share.install "zimfw.zsh"
  end

  def caveats
    <<~EOS
      zimfw.zsh lives in #{opt_share}zimfw.zsh to source in your .zshrc.
    EOS
  end

  test do
    assert_match version.to_s,
      shell_output("zsh -c 'ZIM_HOME=#{testpath}.zim source #{share}zimfw.zsh version'")

    (testpath".zimrc").write("zmodule test --use mkdir --on-pull '>init.zsh <<<\"print test\"'")
    system "zsh -c 'ZIM_HOME=#{testpath}.zim source #{share}zimfw.zsh init -q'"
    assert_path_exists testpath".zimmodulestestinit.zsh"
    assert_path_exists testpath".ziminit.zsh"
  end
end