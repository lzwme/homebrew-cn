class Modules < Formula
  desc "Dynamic modification of a user's environment via modulefiles"
  homepage "https://modules.sourceforge.net/"
  # TODO: Try switching to `tcl-tk` on the next release
  url "https://downloads.sourceforge.net/project/modules/Modules/modules-5.4.0/modules-5.4.0.tar.bz2"
  sha256 "c494f70cb533b5f24ad69803aa053bb4a509bec4632d6a066e7ac041db461a72"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/modules[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d10ba898de337a2d1f8ecc2b91b2aa907f738cc16e13a681d4c0ce79700a00ed"
    sha256 cellar: :any,                 arm64_sonoma:  "5359894bf6da82a6608184eff6b8814c10e317a347abffa270ebfa6785792260"
    sha256 cellar: :any,                 arm64_ventura: "f96f433698cb5c079d25630a130865b981b4ac985d2cf7da9c1d70b3dc64615d"
    sha256 cellar: :any,                 sonoma:        "026e2e3fd60d422333d2fcd40a2f494342e2e9789a0a1f31fba1b031209d9d64"
    sha256 cellar: :any,                 ventura:       "3f35ae7fb352305a409e825b915447358a1a9f2e793754fe40b085d9a0f075a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd31e617c19b9af7f38fb7df7debeeef532e11c9ecd90430317bd61a1cf04b64"
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