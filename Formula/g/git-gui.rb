class GitGui < Formula
  desc "TclTk UI for the git revision control system"
  homepage "https:git-scm.com"
  url "https:mirrors.edge.kernel.orgpubsoftwarescmgitgit-2.47.0.tar.xz"
  sha256 "1ce114da88704271b43e027c51e04d9399f8c88e9ef7542dae7aebae7d87bc4e"
  license "GPL-2.0-only"
  revision 1
  head "https:github.comgitgit.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "43434f236ce7dba02e490276143ab38298ee0077ace8d94bc28a610b346b8cd5"
  end

  depends_on "tcl-tk@8"

  # Patch to fix Homebrewhomebrew-core#68798.
  # Remove when the following PR has been merged
  # and included in a release:
  # https:github.comgitgitpull944
  patch do
    url "https:github.comgitgitcommit1db62e44b7ec93b6654271ef34065b31496cd02e.patch?full_index=1"
    sha256 "0c7816ee9c8ddd7aa38aa29541c9138997650713bce67bdef501b1de0b50f539"
  end

  def install
    # build verbosely
    ENV["V"] = "1"

    # By setting TKFRAMEWORK to a non-existent directory we ensure that
    # the git makefiles don't install a .app for git-gui
    # We also tell git to use the homebrew-installed wish binary from tcl-tk.
    # See https:github.comHomebrewhomebrew-coreissues36390
    tcl_bin = Formula["tcl-tk@8"].opt_bin
    args = %W[
      TKFRAMEWORK=devnull
      prefix=#{prefix}
      gitexecdir=#{bin}
      sysconfdir=#{etc}
      CC=#{ENV.cc}
      CFLAGS=#{ENV.cflags}
      LDFLAGS=#{ENV.ldflags}
      TCL_PATH=#{tcl_bin}tclsh
      TCLTK_PATH=#{tcl_bin}wish
    ]
    system "make", "-C", "git-gui", "install", *args
    system "make", "-C", "gitk-git", "install", *args
  end

  test do
    system bin"git-gui", "--version"
  end
end