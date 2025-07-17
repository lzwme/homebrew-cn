class GitAnnex < Formula
  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-10.20250630/git-annex-10.20250630.tar.gz"
  sha256 "03df602f2f72110d5a782a760399b64a57d37661f84aed6612d9d62d727459ed"
  license all_of: ["AGPL-3.0-or-later", "BSD-2-Clause", "BSD-3-Clause",
                   "GPL-2.0-only", "GPL-3.0-or-later", "MIT"]
  head "git://git-annex.branchable.com/", branch: "master"

  livecheck do
    url "https://hackage.haskell.org/package/git-annex"
    regex(/href=.*?git-annex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "70e6d9fc258bbbd872f729b7ec34c15e4ef019c3c68092198556d6525bdcfe81"
    sha256 cellar: :any,                 arm64_sonoma:  "f76639420917d1b6631b0ac68a665e757ca22ae21b7edcf48d784fb5bff0446a"
    sha256 cellar: :any,                 arm64_ventura: "b0d8bd98559e8a7ffdd07f5d862644ccea2e7cbd2ad158ca6a11b559e2457fc3"
    sha256 cellar: :any,                 sonoma:        "ee4550452b4a839918f6966ed2264e548e6cd3dccae202141ec0ce05b393f74c"
    sha256 cellar: :any,                 ventura:       "c6656a3746c29a3c4547509edb1c52bc3c128ed57097b1436ab74a897d624999"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46d5aed0d9d308e7920ca1eca348a341b6bb67bb61fa1182e9e6f24db7a033a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4043d6a03232beac6d5f33c905644dc118336def3fae6ecb1fdc8398f7645c9"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.8" => :build
  depends_on "pkgconf" => :build
  depends_on "libmagic"

  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args, "--flags=+S3 +Servant"
    bin.install_symlink "git-annex" => "git-annex-shell"
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