class GitGui < Formula
  desc "TclTk UI for the git revision control system"
  homepage "https:git-scm.com"
  url "https:mirrors.edge.kernel.orgpubsoftwarescmgitgit-2.50.0.tar.xz"
  sha256 "dff3c000e400ace3a63b8a6f8b3b76b88ecfdffd4504a04aba4248372cdec045"
  license "GPL-2.0-only"
  head "https:github.comgitgit.git", branch: "master"

  livecheck do
    formula "git"
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8987dadc8d08a9b6e66afeffad3e8cd704c7b9f03017480c79ec92fabfb9d686"
  end

  depends_on "tcl-tk@8"

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