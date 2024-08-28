class ZshNavigationTools < Formula
  desc "Zsh curses-based tools, e.g. multi-word history searcher"
  homepage "https:github.comz-shellzsh-navigation-tools"
  url "https:github.comz-shellzsh-navigation-toolsarchiverefstagsv2.2.7.tar.gz"
  sha256 "ee832b81ce678a247b998675111c66aa1873d72aa33c2593a65626296ca685fc"
  license any_of: ["GPL-3.0-only", "MIT"]

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "7f766c2aecf317bed6dcbbe7e5c2f93dd96789e59831fc19195993fa68258978"
  end

  uses_from_macos "zsh"

  def install
    # Make the bottles uniform
    inreplace [".configzntn-cd.conf", "n-panelize"], "usrlocal", HOMEBREW_PREFIX

    system "make", "install", "PREFIX=#{prefix}"
  end

  def caveats
    <<~EOS
      To run zsh-navigation-tools, add the following at the end of your .zshrc:
        source #{HOMEBREW_PREFIX}sharezsh-navigation-toolszsh-navigation-tools.plugin.zsh

      You will also need to restart your terminal for this change to take effect.
    EOS
  end

  test do
    # This compiles package's main file
    # Zcompile is very capable of detecting syntax errors
    cp pkgshare"n-list", testpath
    system "zsh", "-c", "zcompile n-list"
  end
end