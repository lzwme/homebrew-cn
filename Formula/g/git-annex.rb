class GitAnnex < Formula
  desc "Manage files with git without checking in file contents"
  homepage "https:git-annex.branchable.com"
  url "https:hackage.haskell.orgpackagegit-annex-10.20250102git-annex-10.20250102.tar.gz"
  sha256 "3c7ba460dc3de5c2221299ab099f6b4983d0048b9ebc4d5397c422f2b2015d91"
  license all_of: ["AGPL-3.0-or-later", "BSD-2-Clause", "BSD-3-Clause",
                   "GPL-2.0-only", "GPL-3.0-or-later", "MIT"]
  head "git:git-annex.branchable.com", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b282b79aad495c34dbf66da87eba9e875636e52c2f815fe291829ea0f21547af"
    sha256 cellar: :any,                 arm64_sonoma:  "d6bbb47f31da3dfc0e825ecb0b5cf510f89cb31cb9789558338bc211161db533"
    sha256 cellar: :any,                 arm64_ventura: "6d03f1a80cbe400a665cfd1f7d841e307340b380d9ba679b774e1a8ddea2d533"
    sha256 cellar: :any,                 sonoma:        "36a91008d2ea46267083726baf4af23ba2d709963f74d438a6e577cc5453eae2"
    sha256 cellar: :any,                 ventura:       "26ea56c46c2a32e26f5ddea934e9682638ffc052ed176bf4967f758934ca3cb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa3ffe5dd3aeaebf96a77d6e05b55950dfcd0af173e44bc65d9bbff34f161ccc"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.8" => :build
  depends_on "pkgconf" => :build
  depends_on "libmagic"

  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    # Work around https:github.comyesodwebyesodissues1854 with constraint
    # TODO: Remove once fixed upstream
    system "cabal", "v2-install", *std_cabal_v2_args, "--flags=+S3", "--constraint=wai-extra<3.1.17"
    bin.install_symlink "git-annex" => "git-annex-shell"
  end

  service do
    run [opt_bin"git-annex", "assistant", "--autostart"]
  end

  test do
    # make sure git can find git-annex
    ENV.prepend_path "PATH", bin

    system "git", "init"
    system "git", "annex", "init"
    (testpath"Hello.txt").write "Hello!"
    refute_predicate (testpath"Hello.txt"), :symlink?
    assert_match(^add Hello.txt.*ok.*\(recording state in git\.\.\.\)m, shell_output("git annex add ."))
    system "git", "commit", "-a", "-m", "Initial Commit"
    assert_predicate (testpath"Hello.txt"), :symlink?

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