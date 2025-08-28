class GitAnnex < Formula
  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-10.20250721/git-annex-10.20250721.tar.gz"
  sha256 "217fd675dba96fc82734d08b7951ad596f2ba4f99bb01fa848528d9874828aac"
  license all_of: ["AGPL-3.0-or-later", "BSD-2-Clause", "BSD-3-Clause",
                   "GPL-2.0-only", "GPL-3.0-or-later", "MIT"]
  head "git://git-annex.branchable.com/", branch: "master"

  livecheck do
    url "https://hackage.haskell.org/package/git-annex"
    regex(/href=.*?git-annex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "7ef911cb676b4a42ff067f06c6f26b147a08fba017420ff10b1e4ba711719d13"
    sha256 cellar: :any,                 arm64_sonoma:  "df9ee50e7324ab88e482bef5461f8b36301f37b6b2b4d29a5de06c88cfe42c34"
    sha256 cellar: :any,                 arm64_ventura: "8bad9fa159b8788f13f3705e57b9ab62c5316715c49327a784834c9f83bc0b9d"
    sha256 cellar: :any,                 sonoma:        "429a5d2d07bc4cdeb7b0d6fe7a2982f9001e4d74de6d62d54d051bc5494dfa53"
    sha256 cellar: :any,                 ventura:       "abf13dcd09ed276e287b6785e3075ad55c9ab231e04dcadb6c136f21e8fe2de9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9354e7c9c1c57cfd5183fadc3649bc8af7a3db2574e8dce3787b66c7e8ad3372"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0e9ba9e302ca6f0e3583ab4d37e69b5ae2e70ffa98016c5269649c2e1d02f89"
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