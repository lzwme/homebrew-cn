class GitGui < Formula
  desc "TclTk UI for the git revision control system"
  homepage "https:git-scm.com"
  url "https:mirrors.edge.kernel.orgpubsoftwarescmgitgit-2.45.1.tar.xz"
  sha256 "e64d340a8e627ae22cfb8bcc651cca0b497cf1e9fdf523735544ff4a732f12bf"
  license "GPL-2.0-only"
  head "https:github.comgitgit.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d75e5db0d2021dab91333909c8addb536f8a092d457101ac47b15e7c0b5f1184"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a50ceca5213edd0eb052748c7ce694a0588e676661bfe426000bebc37f31f8ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d5caf9ef9e6df604d42ee15ba837bece41a5c7d6e76b928cfa28d63aa312481"
    sha256 cellar: :any_skip_relocation, sonoma:         "d59e149925ddfab2a42bd1624a12c5d4033aad3e8c6d9525e70b9f5ad159d014"
    sha256 cellar: :any_skip_relocation, ventura:        "bb836002e0452c4ef7318b5c7a24962323dcdeef2ffce94ceb0711acb0bd9ca8"
    sha256 cellar: :any_skip_relocation, monterey:       "f26b58069f27c77a41555e9052b1f94b499b38804783724483700c5fadbf0ebe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1eca99221a90c2772d41dfaed9af78ab693eccaa6cdcfc2791dc64ab942f43df"
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