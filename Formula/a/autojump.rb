class Autojump < Formula
  desc "Shell extension to jump to frequently used directories"
  homepage "https:github.comwtingautojump"
  url "https:github.comwtingautojumparchiverefstagsrelease-v22.5.3.tar.gz"
  sha256 "00daf3698e17ac3ac788d529877c03ee80c3790472a85d0ed063ac3a354c37b1"
  license "GPL-3.0-or-later"
  revision 3
  head "https:github.comwtingautojump.git", branch: "master"

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "99ba23c9e74320381af33cef477c4258185ff0cc5ef5d54165a07ca3385a9237"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "99ba23c9e74320381af33cef477c4258185ff0cc5ef5d54165a07ca3385a9237"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99ba23c9e74320381af33cef477c4258185ff0cc5ef5d54165a07ca3385a9237"
    sha256 cellar: :any_skip_relocation, sonoma:         "99ba23c9e74320381af33cef477c4258185ff0cc5ef5d54165a07ca3385a9237"
    sha256 cellar: :any_skip_relocation, ventura:        "99ba23c9e74320381af33cef477c4258185ff0cc5ef5d54165a07ca3385a9237"
    sha256 cellar: :any_skip_relocation, monterey:       "99ba23c9e74320381af33cef477c4258185ff0cc5ef5d54165a07ca3385a9237"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbdc660e87f1a4e80757a36c7ce9cda4235e79e490007b80b8c2d894206b1f8b"
  end

  depends_on "python@3.12"

  def install
    python_bin = Formula["python@3.12"].opt_libexec"bin"
    system python_bin"python", "install.py", "-d", prefix, "-z", zsh_completion

    # ensure uniform bottles
    inreplace prefix"etcprofile.dautojump.sh", "usrlocal", HOMEBREW_PREFIX

    # Backwards compatibility for users that have the old path in .bash_profile
    # or .zshrc
    (prefix"etc").install_symlink prefix"etcprofile.dautojump.sh"

    libexec.install bin
    (bin"autojump").write_env_script libexec"binautojump", PATH: "#{python_bin}:$PATH"
  end

  def caveats
    <<~EOS
      Add the following line to your ~.bash_profile or ~.zshrc file:
        [ -f #{etc}profile.dautojump.sh ] && . #{etc}profile.dautojump.sh

      If you use the Fish shell then add the following line to your ~.configfishconfig.fish:
        [ -f #{HOMEBREW_PREFIX}shareautojumpautojump.fish ]; and source #{HOMEBREW_PREFIX}shareautojumpautojump.fish

      Restart your terminal for the settings to take effect.
    EOS
  end

  test do
    path = testpath"foobar"
    path.mkpath
    cmds = [
      ". #{etc}profile.dautojump.sh",
      "j -a \"#{path.relative_path_from(testpath)}\"",
      "j foo >devnull",
      "pwd",
    ]
    assert_equal path.realpath.to_s, shell_output("bash -c '#{cmds.join("; ")}'").strip
  end
end