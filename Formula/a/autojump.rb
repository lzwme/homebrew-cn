class Autojump < Formula
  desc "Shell extension to jump to frequently used directories"
  homepage "https://github.com/wting/autojump"
  url "https://ghfast.top/https://github.com/wting/autojump/archive/refs/tags/release-v22.5.3.tar.gz"
  sha256 "00daf3698e17ac3ac788d529877c03ee80c3790472a85d0ed063ac3a354c37b1"
  license "GPL-3.0-or-later"
  revision 3
  head "https://github.com/wting/autojump.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 6
    sha256 cellar: :any_skip_relocation, all: "b172a04f1d109b558ed126cc14250e41e804adecbdcf9f1ef68941825613b283"
  end

  depends_on "python@3.13"

  def install
    python_bin = Formula["python@3.13"].opt_libexec/"bin"
    system python_bin/"python", "install.py", "-d", prefix, "-z", zsh_completion

    # ensure uniform bottles
    inreplace prefix/"etc/profile.d/autojump.sh", "/usr/local", HOMEBREW_PREFIX

    # Backwards compatibility for users that have the old path in .bash_profile
    # or .zshrc
    (prefix/"etc").install_symlink prefix/"etc/profile.d/autojump.sh"

    libexec.install bin
    (bin/"autojump").write_env_script libexec/"bin/autojump", PATH: "#{python_bin}:$PATH"
  end

  def caveats
    <<~EOS
      Add the following line to your ~/.bash_profile or ~/.zshrc file:
        [ -f #{etc}/profile.d/autojump.sh ] && . #{etc}/profile.d/autojump.sh

      If you use the Fish shell then add the following line to your ~/.config/fish/config.fish:
        [ -f #{HOMEBREW_PREFIX}/share/autojump/autojump.fish ]; and source #{HOMEBREW_PREFIX}/share/autojump/autojump.fish

      Restart your terminal for the settings to take effect.
    EOS
  end

  test do
    path = testpath/"foo/bar"
    path.mkpath
    cmds = [
      ". #{etc}/profile.d/autojump.sh",
      "j -a \"#{path.relative_path_from(testpath)}\"",
      "j foo >/dev/null",
      "pwd",
    ]
    assert_equal path.realpath.to_s, shell_output("bash -c '#{cmds.join("; ")}'").strip
  end
end