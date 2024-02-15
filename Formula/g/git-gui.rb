class GitGui < Formula
  desc "TclTk UI for the git revision control system"
  homepage "https:git-scm.com"
  url "https:mirrors.edge.kernel.orgpubsoftwarescmgitgit-2.43.2.tar.xz"
  sha256 "f612c1abc63557d50ad3849863fc9109670139fc9901e574460ec76e0511adb9"
  license "GPL-2.0-only"
  head "https:github.comgitgit.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cf4a49b32f4d8f085c7944fda885483c33000a92b74cbf502ab868bccf6bbf21"
  end

  depends_on "tcl-tk"

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
    tcl_bin = Formula["tcl-tk"].opt_bin
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