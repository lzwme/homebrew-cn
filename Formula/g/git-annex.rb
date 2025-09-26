class GitAnnex < Formula
  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-10.20250925/git-annex-10.20250925.tar.gz"
  sha256 "87c5fc8d08d54129539b0addf5be9787e443439368d39a186ef020b70e750e34"
  license all_of: ["AGPL-3.0-or-later", "BSD-2-Clause", "BSD-3-Clause",
                   "GPL-2.0-only", "GPL-3.0-or-later", "MIT"]
  head "git://git-annex.branchable.com/", branch: "master"

  livecheck do
    url "https://hackage.haskell.org/package/git-annex"
    regex(/href=.*?git-annex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bb37b714c261659576f4f115e66dd619a759781f724f2c2ba571bdcaf25abad7"
    sha256 cellar: :any,                 arm64_sequoia: "d052ab922a3d2e9ccb4f6f5ac93543adfddae734c967f2005d153dfc2048cb45"
    sha256 cellar: :any,                 arm64_sonoma:  "0ce11608d3c6ab2e1394504e6a2b2c328af051007b6f7987ff331e163c709ef3"
    sha256 cellar: :any,                 sonoma:        "cab899c97ca36e28e5ebf03c9bc41a3114255cc84a5786adcf113ae536340db4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ccfe6ddd761f48134b89ef012e7517a7efe4a045605353dca26ec5bfc7fef78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0cd32bb3563d0f02f7abfd066d4876d313ed8b855800cda967df85a52b16d9cc"
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