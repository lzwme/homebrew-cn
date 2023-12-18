class Jnethack < Formula
  desc "Japanese localization of NetHack"
  homepage "https:jnethack.osdn.jp"
  # We use a git checkout to avoid patching the upstream NetHack tarball.
  url "https:github.comjnethackjnethack-release.git",
      tag:      "v3.6.7-0.1",
      revision: "3b3a9c4e25df60f9bce2ad09ce368410b4360e85"
  license "NGPL"
  head "https:github.comjnethackjnethack-release.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "bae280dd42e8d357d686b2482676de03a1acd4b65b5eefcae753bba91fc42951"
    sha256 arm64_ventura:  "44ca7f443ece59eef081c6d4a270d6aa63f6bd4d6bc173c7cfbd991dd2fb743b"
    sha256 arm64_monterey: "3f4432dcdbf52b38e53446c0f35ec23d6d7438cc019b3b7587aaf5a28187e799"
    sha256 sonoma:         "3b46b1e5f270af3786dcebde6c0fc008dd22ffdf0a51a3aaa6daa08fd96a0696"
    sha256 ventura:        "84ac8940603749b3f1e3dbf11f8bdef227307c0e34bb9f0d2b227dd138223ac4"
    sha256 monterey:       "82edd9a68cc86d599b8eb70f23b6e813c3b587af96b9986eb51679d82f6b1f83"
    sha256 x86_64_linux:   "b9d9a667b5f140032db12e1384be61894be2bc94340bba0fd08dfcfd5ec16031"
  end

  depends_on "nkf" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "ncurses"

  # Don't remove save folder
  skip_clean "libexecsave"

  def install
    # Build everything in-order; no multi builds.
    ENV.deparallelize
    ENV.O0

    # Enable wizard mode for all users
    inreplace "sysunixsysconf", ^WIZARDS=.*, "WIZARDS=*"

    platform = OS.mac? ? "macosx10.10" : OS.kernel_name.downcase

    # Only this file is touched by jNetHack, so don't switch on macOS versions
    inreplace "sysunixhints#{platform}" do |s|
      # macOS clang doesn't support code page 932
      s.gsub! "-fexec-charset=cp932", "" if OS.mac?
      s.change_make_var! "HACKDIR", libexec
      s.change_make_var! "CHOWN", "true"
      s.change_make_var! "CHGRP", "true"
      # Setting VAR_PLAYGROUND preserves saves across upgrades. With a bit of
      # work this could share leaderboards with English NetHack, however bones
      # and save files are much tricker. We could set those separately but
      # it's probably not worth the extra trouble. New curses backend is not
      # supported by jNetHack.
      replace_string = OS.mac? ? "#WANT_WIN_CURSES=1" : "#CFLAGS+=-DEXTRA_SANITY_CHECKS"
      s.gsub! replace_string, "CFLAGS+=-DVAR_PLAYGROUND='\"#{HOMEBREW_PREFIX}sharejnethack\"'"
    end

    # We use the Linux version due to code page 932 issues, but point the
    # hints file to macOS
    inreplace "japaneseset_lnx.sh", "linux", "macosx10.10" if OS.mac?
    system "sh", "japaneseset_lnx.sh"
    system "make", "install"
    bin.install_symlink libexec"jnethack"
  end

  def post_install
    # These need to exist (even if empty) otherwise NetHack won't start
    savedir = HOMEBREW_PREFIX"sharejnethack"
    mkdir_p savedir
    cd savedir do
      %w[xlogfile logfile perm record].each do |f|
        touch f
      end
      mkdir_p "save"
      touch "save.keepme" # preserve on `brew cleanup`
    end
    # Set group-writeable for multiuser installs
    chmod "g+w", savedir
    chmod "g+w", savedir"save"
  end

  test do
    system "#{bin}jnethack", "-s"
    assert_match (HOMEBREW_PREFIX"sharejnethack").to_s,
      shell_output("#{bin}jnethack --showpaths")
  end
end