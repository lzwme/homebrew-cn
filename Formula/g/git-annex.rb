class GitAnnex < Formula
  desc "Manage files with git without checking in file contents"
  homepage "https:git-annex.branchable.com"
  url "https:hackage.haskell.orgpackagegit-annex-10.20241202git-annex-10.20241202.tar.gz"
  sha256 "e27518faeda9c4740102d93df2bc788161e408df387072bc3d73c9eec3ade283"
  license all_of: ["AGPL-3.0-or-later", "BSD-2-Clause", "BSD-3-Clause",
                   "GPL-2.0-only", "GPL-3.0-or-later", "MIT"]
  head "git:git-annex.branchable.com", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a7a69de8dbbbdeb01497ffe9d377211c0115250dca439f454c1c13b6643af768"
    sha256 cellar: :any,                 arm64_sonoma:  "e6e9e79d3a5d2c80786afe42989b24dfaa72fa13e5b08a2a416b0cdcb65dc169"
    sha256 cellar: :any,                 arm64_ventura: "d18d1c704e0ef61a80e0d82eaac0ec20994a921034942634c234aa7dfed9bd66"
    sha256 cellar: :any,                 sonoma:        "8a8164635fb9b09197a78fd455997e8d982e129c4e123830cee4267d9393c22c"
    sha256 cellar: :any,                 ventura:       "009b6c983e4a2088f2749f1f7ea0978a950931de45e01e05aa6b750a2443c726"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4323eac81cb07ab721296a3230f2d072b563a17dc2168e8853cf1406511c6bf4"
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