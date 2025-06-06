class GitAnnex < Formula
  desc "Manage files with git without checking in file contents"
  homepage "https:git-annex.branchable.com"
  url "https:hackage.haskell.orgpackagegit-annex-10.20250605git-annex-10.20250605.tar.gz"
  sha256 "72782fde9a2ddadc6f09f2d90cde2eb7a13248f19f95d7a41ba95ba4bd347e2b"
  license all_of: ["AGPL-3.0-or-later", "BSD-2-Clause", "BSD-3-Clause",
                   "GPL-2.0-only", "GPL-3.0-or-later", "MIT"]
  head "git:git-annex.branchable.com", branch: "master"

  livecheck do
    url "https:hackage.haskell.orgpackagegit-annex"
    regex(href=.*?git-annex[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "eec8fe2f64fd374bf043b03caf20776bac3cf278a49899434d253796fef08e89"
    sha256 cellar: :any,                 arm64_sonoma:  "2809c99c783d66cb38207843107f3b8f1bb39887b12f46614221a2122100d95a"
    sha256 cellar: :any,                 arm64_ventura: "1decc5c08973b4519e14615ad6196513ca3994e66dd5570b85569097b484fe09"
    sha256 cellar: :any,                 sonoma:        "2ff748c3b77a5a74c7d9181351e8cde20015c007f44bb927da0384553e601385"
    sha256 cellar: :any,                 ventura:       "8131728a89a1db27fd617d2bc86c2198b61f94e84b868c8c5dfbd3c84264e9ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41187f4390153263d5884c24d423d6a9f80facf6e7ad74c5ff43549d4e6de9d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bd648cad6747c9335fe57c04e864af2e7ac06e596af4d07e8ea70ca3729bb84"
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