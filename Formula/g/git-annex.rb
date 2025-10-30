class GitAnnex < Formula
  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-10.20251029/git-annex-10.20251029.tar.gz"
  sha256 "fe1a90e289b3bd3c2529f21229727083ec99820738e4522149ae259b81d19e44"
  license all_of: ["AGPL-3.0-or-later", "BSD-2-Clause", "BSD-3-Clause",
                   "GPL-2.0-only", "GPL-3.0-or-later", "MIT"]
  head "git://git-annex.branchable.com/", branch: "master"

  livecheck do
    url "https://hackage.haskell.org/package/git-annex"
    regex(/href=.*?git-annex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "459566515a12df8a443c80cd9ed343aa634bcb508dc383bb4e6fbf04c71f5fe7"
    sha256 cellar: :any,                 arm64_sequoia: "75087ff01ed2016b58e92bed8a238fe50ced8adb47f8244dac03830bb4f6e253"
    sha256 cellar: :any,                 arm64_sonoma:  "7feb37389fec807bd1756e1ebef2195bf6bf70aa70909afe8537057818edf3e6"
    sha256 cellar: :any,                 sonoma:        "4371115cbbd23d0704dabc30f9c14be24964521b2b3851ea18605552030919e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6b0166ec8770a0c7790730821078552a928bd4b0ca89aca84c8ccd958020b1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b462eb4e08f9de00b109de36da785df7a17578d1a1340612d7078da88c5e5f35"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.10" => :build
  depends_on "pkgconf" => :build
  depends_on "libmagic"

  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args, "--flags=+S3 +Servant"
    bin.install_symlink "git-annex" => "git-annex-shell"
    bin.install_symlink "git-annex" => "git-remote-annex"
    bin.install_symlink "git-annex" => "git-remote-tor-annex"
  end

  service do
    run [opt_bin/"git-annex", "assistant", "--autostart"]
  end

  test do
    # make sure git can find git-annex
    ENV.prepend_path "PATH", bin

    system "git", "init"
    system "git", "annex", "init"
    (testpath/"Hello.txt").write "Hello!"
    refute_predicate (testpath/"Hello.txt"), :symlink?
    assert_match(/^add Hello.txt.*ok.*\(recording state in git\.\.\.\)/m, shell_output("git annex add ."))
    system "git", "commit", "-a", "-m", "Initial Commit"
    assert_predicate (testpath/"Hello.txt"), :symlink?

    # make sure the various remotes were built
    assert_match "remote types: git gcrypt p2p S3 bup directory rsync web bittorrent " \
                 "webdav adb tahoe glacier ddar git-lfs httpalso borg rclone hook external",
                 shell_output("git annex version | grep 'remote types:'").chomp

    # The steps below are necessary to ensure the directory cleanly deletes.
    # git-annex guards files in a way that isn't entirely friendly of automatically
    # wiping temporary directories in the way `brew test` does at end of execution.
    system "git", "rm", "Hello.txt", "-f"
    system "git", "commit", "-a", "-m", "Farewell!"
    system "git", "annex", "unused"
    assert_match "dropunused 1 ok", shell_output("git annex dropunused 1 --force")
    system "git", "annex", "uninit"
  end
end