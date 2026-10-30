class Zimfw < Formula
  desc "Zsh plugin manager"
  homepage "https://zimfw.sh"
  url "https://ghfast.top/https://github.com/zimfw/zimfw/releases/download/v1.20.2/zimfw.zsh.gz"
  sha256 "61f65ca3d69f5ba6a1349be161e8e18be61366e869056352f8ba0d7065c263ff"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "553a5ccd48dd8ebfad9d53f849fdc1acace18d6317e731390f50fc18d0c4d1e3"
  end

  uses_from_macos "zsh" => :test

  deny_network_access!

  def install
    share.install "zimfw.zsh"
  end

  def caveats
    <<~EOS
      zimfw.zsh lives in #{opt_share}/zimfw.zsh to source in your .zshrc.
    EOS
  end

  test do
    assert_match version.to_s,
      shell_output("zsh -c 'ZIM_HOME=#{testpath}/.zim source #{share}/zimfw.zsh version'")

    (testpath/".zimrc").write("zmodule test --use mkdir --on-pull '>init.zsh <<<\"print test\"'")
    system "zsh -c 'ZIM_HOME=#{testpath}/.zim source #{share}/zimfw.zsh init -q'"
    assert_path_exists testpath/".zim/modules/test/init.zsh"
    assert_path_exists testpath/".zim/init.zsh"
  end
end