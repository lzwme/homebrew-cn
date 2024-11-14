class Modules < Formula
  desc "Dynamic modification of a user's environment via modulefiles"
  homepage "https://modules.sourceforge.net/"
  # TODO: Try switching to `tcl-tk` on the next release
  url "https://downloads.sourceforge.net/project/modules/Modules/modules-5.5.0/modules-5.5.0.tar.bz2"
  sha256 "cb6355b0c81566a4d3ecd06fb4ae6afc9665a087b1e9039c5b5ffbc46fa282e2"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/modules[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ab788ca1c38f5e761b9bd4c04323f1a02f6464e44f5fc3e8add061df5ae073cb"
    sha256 cellar: :any,                 arm64_sonoma:  "eba6aae5dbd6c785a2d833f3735c89fc56238b2ab022e53ef2f5456c14a91283"
    sha256 cellar: :any,                 arm64_ventura: "86a7637cb2549b3992f43628a25dd6afbb4cb1dfa01e1f6c6e24fcc4bc8f2be0"
    sha256 cellar: :any,                 sonoma:        "3f23e331ffb9ce06b6ab2aec59a36b99d1eada125cda2dedefc694d7e97b261d"
    sha256 cellar: :any,                 ventura:       "0aea126ca2020ecc6aa0e51dff75cb09895b2616ece33d6e461a8e6d6d3cf5d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f73af6b00b7f3bd73bbd6d0ff30d3944445ec7470d24f594b7d0fbe24edde016"
  end

  depends_on "tcl-tk@8"

  uses_from_macos "less"

  def install
    tcltk = Formula["tcl-tk@8"]
    args = %W[
      --prefix=#{prefix}
      --datarootdir=#{share}
      --with-tcl=#{tcltk.opt_lib}
      --without-x
    ]

    if OS.linux?
      args << "--with-pager=#{Formula["less"].opt_bin}/less"
      args << "--with-tclsh=#{tcltk.opt_bin}/tclsh"
    end

    system "./configure", *args
    system "make", "install"
  end

  def caveats
    <<~EOS
      To activate modules, add the following at the end of your .zshrc:

        source #{opt_prefix}/init/zsh

      You will also need to restart your terminal for this change to take effect.
    EOS
  end

  test do
    assert_match "restore", shell_output("#{bin}/envml --help")
    shell, cmd = if OS.mac?
      ["zsh", "source"]
    else
      ["sh", "."]
    end
    output = shell_output("#{shell} -c '#{cmd} #{prefix}/init/#{shell}; module' 2>&1")
    assert_match version.to_s, output
  end
end