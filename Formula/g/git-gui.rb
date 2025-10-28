class GitGui < Formula
  desc "Tcl/Tk UI for the git revision control system"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.51.2.tar.xz"
  sha256 "233d7143a2d58e60755eee9b76f559ec73ea2b3c297f5b503162ace95966b4e3"
  license "GPL-2.0-only"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "96063bb35e59050b4e0415e607725143c703f8b0d393b3dad1e8a79fd1172fa9"
  end

  depends_on "tcl-tk"

  # Fix gitk's right click and scrolling behavior with Tcl/Tk 9.
  # Remove both when included in https://github.com/git/git/tree/#{tag}/gitk-git
  patch do
    url "https://github.com/j6t/gitk/commit/7c06c19e66e7654031eb50b72fd79c380fa54158.patch?full_index=1"
    sha256 "5ffaf1f1377a593079a6e1f4d55babfec5ef000552027f65bae157cc42ca4b75"
    directory "gitk-git"
  end
  patch do
    url "https://github.com/j6t/gitk/commit/432669914b2fb812bc62e3b52176a8bfc8e4d667.patch?full_index=1"
    sha256 "3b750defc0406f5799645d25f01f56dc5750b0dd534e4073a1e1b01f53e2061f"
    directory "gitk-git"
  end

  def install
    # build verbosely
    ENV["V"] = "1"

    # By setting TKFRAMEWORK to a non-existent directory we ensure that
    # the git makefiles don't install a .app for git-gui
    # We also tell git to use the homebrew-installed wish binary from tcl-tk.
    # See https://github.com/Homebrew/homebrew-core/issues/36390
    tcl_bin = Formula["tcl-tk"].opt_bin
    args = %W[
      TKFRAMEWORK=/dev/null
      prefix=#{prefix}
      gitexecdir=#{bin}
      sysconfdir=#{etc}
      CC=#{ENV.cc}
      CFLAGS=#{ENV.cflags}
      LDFLAGS=#{ENV.ldflags}
      TCL_PATH=#{tcl_bin}/tclsh
      TCLTK_PATH=#{tcl_bin}/wish
    ]
    system "make", "-C", "git-gui", "install", *args
    system "make", "-C", "gitk-git", "install", *args
  end

  test do
    system bin/"git-gui", "--version"
  end
end