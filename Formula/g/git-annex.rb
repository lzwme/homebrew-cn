class GitAnnex < Formula
  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-10.20261006/git-annex-10.20261006.tar.gz"
  sha256 "f2f275f8b1bef3ab482935cde137a59a815886e5edc7545171c2081a9bf64a9c"
  license all_of: ["AGPL-3.0-or-later", "BSD-2-Clause", "BSD-3-Clause",
                   "GPL-2.0-only", "GPL-3.0-or-later", "MIT"]
  head "git://git-annex.branchable.com/", branch: "master"

  livecheck do
    url "https://hackage.haskell.org/package/git-annex"
    regex(/href=.*?git-annex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "04006a4c0196c7505624b3531861d2a018e4803703d86bd21e82d077fd49494d"
    sha256 cellar: :any, arm64_tahoe:       "121f0299b54bc071e42aedc4b2e8a0b8174913893c91f2561e49407b50d96fc2"
    sha256 cellar: :any, arm64_sequoia:     "134875628893519f548f37aa525470542e407de90a43fb366db4ac7011d5dc89"
    sha256 cellar: :any, arm64_linux:       "505d160fd064bf4b2023efd233f9de17f1e63e017556f3779a02998c27c81ae0"
    sha256 cellar: :any, x86_64_linux:      "70ba9888a681ca4426697c435e121c7a4f9a4a9c498415a4ea6c9dfeeb75233a"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pkgconf" => :build
  depends_on "gmp"
  depends_on "libmagic"

  uses_from_macos "libffi"
  uses_from_macos "sqlite"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # TODO: Remove when the ram compatibility fix is released:
  # https://github.com/yesodweb/yesod/pull/1916
  resource "yesod-static" do
    url "https://ghfast.top/https://github.com/yesodweb/yesod/archive/23f8d636842023c7cde36109ea24258df0d5ecd6.tar.gz"
    version "1.6.1.4"
    sha256 "0b523bd616673dad5e70da42149b426cfd19a7e5666e0550dad06bb9d989b82b"
  end

  allow_network_access! :build

  def install
    resource("yesod-static").stage do
      (buildpath/"vendor").install "yesod-static"
    end
    (buildpath/"cabal.project.local").write "packages: . vendor/*/*.cabal\n"

    args = [
      # Workaround to build with GHC 9.14
      "--allow-newer=base,template-haskell",
      # TODO: Remove when crypton-conduit supports the checked-key API:
      # https://github.com/psibi/crypton-conduit/issues/5
      "--constraint=crypton<2.0.1",
      # Workaround for API breaking release of magic
      "--constraint=magic<2",
      # Workaround for QuickCheck 2.17+ providing its own `Arbitrary (NonEmpty a)`
      # Upstream fix in commit 16cd931e9383ef295e4faf97f51c6fdfd2b9c61c, unreleased as of 10.20260901
      "--constraint=QuickCheck<2.17",
      # Unbundle sqlite
      "--constraint=persistent-sqlite +systemlib +use-pkgconfig",
    ]

    system "cabal", "v2-update"
    system "cabal", "v2-install", *args, *std_cabal_v2_args
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