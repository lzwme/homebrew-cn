class GitAnnex < Formula
  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-10.20230626/git-annex-10.20230626.tar.gz"
  sha256 "29fdc05dc072794ccbb6ed45ae1fb5d4d81c7a670be00c4e257ea450165526fc"
  license all_of: ["AGPL-3.0-or-later", "BSD-2-Clause", "BSD-3-Clause",
                   "GPL-2.0-only", "GPL-3.0-or-later", "MIT"]
  head "git://git-annex.branchable.com/", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "abad0a4b95e28735eb1806914513253753ab49b746fde0014b43300f7ab7584c"
    sha256 cellar: :any,                 arm64_monterey: "8a1fbd87fe8374586567b861352117f0c8f11decf1000ece6329449e8bbb572e"
    sha256 cellar: :any,                 arm64_big_sur:  "253c3f5f40ff6612ffb5d3f983933b11b1334c2dda777c4e5ba97703e881a3e6"
    sha256 cellar: :any,                 ventura:        "3a0daa08181377bb8eda7ae13c950d11bf3dd226134edf1500a787b9ea9db146"
    sha256 cellar: :any,                 monterey:       "ac1d41eab96ffbf749295467013fc7deae1580ab6055486185d9639a6d01c58c"
    sha256 cellar: :any,                 big_sur:        "7e24cbf91c185e806051edbaea2d901cabba0a0f277b12a887534ca3d0768989"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5cb736ce99eef312298bf0f70e70a6f948e9aa23997e09b02514bdc9e62fbd1"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pkg-config" => :build
  depends_on "libmagic"

  resource "bloomfilter" do
    url "https://hackage.haskell.org/package/bloomfilter-2.0.1.0/bloomfilter-2.0.1.0.tar.gz"
    sha256 "6c5e0d357d5d39efe97ae2776e8fb533fa50c1c05397c7b85020b0f098ad790f"

    # Fix build with GHC >= 9.2
    # PR ref: https://github.com/bos/bloomfilter/pull/20
    patch do
      url "https://github.com/bos/bloomfilter/commit/fb79b39c44404fd791a3bed973e9d844fb084f1e.patch?full_index=1"
      sha256 "c91c45fbdeb92f9dcb9b55412d14603b4e480139f6638e8b6ed651acd92409f3"
    end
  end

  def install
    # Add workarounds to build with GHC >= 9.2
    (buildpath/"homebrew/bloomfilter").install resource("bloomfilter")
    (buildpath/"cabal.project.local").write <<~EOS
      packages: ./*.cabal
                homebrew/bloomfilter/
    EOS

    system "cabal", "v2-update"
    # `warp` 3.3.26 switched `cryptonite` dependency to `cryton` which caused
    # build issues. `git-annex` dependency tree also has `cryptonite` which may
    # be mixing APIs. We add a temporary workaround to avoid newer `warp` versions.
    # TODO: Remove constraint when handled in Cabal file or fixed in new release
    system "cabal", "v2-install", *std_cabal_v2_args, "--flags=+S3", "--constraint=warp<3.3.26"
    bin.install_symlink "git-annex" => "git-annex-shell"
  end

  service do
    run [opt_bin/"git-annex", "assistant", "--autostart"]
  end

  test do
    # make sure git can find git-annex
    ENV.prepend_path "PATH", bin
    # We don't want this here or it gets "caught" by git-annex.
    rm_r "Library/Python/2.7/lib/python/site-packages/homebrew.pth"

    system "git", "init"
    system "git", "annex", "init"
    (testpath/"Hello.txt").write "Hello!"
    assert !File.symlink?("Hello.txt")
    assert_match(/^add Hello.txt.*ok.*\(recording state in git\.\.\.\)/m, shell_output("git annex add ."))
    system "git", "commit", "-a", "-m", "Initial Commit"
    assert File.symlink?("Hello.txt")

    # make sure the various remotes were built
    assert_match shell_output("git annex version | grep 'remote types:'").chomp,
                 "remote types: git gcrypt p2p S3 bup directory rsync web bittorrent " \
                 "webdav adb tahoe glacier ddar git-lfs httpalso borg hook external"

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