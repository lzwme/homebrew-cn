class GitAnnex < Formula
  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  license all_of: ["AGPL-3.0-or-later", "BSD-2-Clause", "BSD-3-Clause",
                   "GPL-2.0-only", "GPL-3.0-or-later", "MIT"]
  head "git://git-annex.branchable.com/", branch: "master"

  stable do
    url "https://hackage.haskell.org/package/git-annex-10.20230329/git-annex-10.20230329.tar.gz"
    sha256 "a19f7dec686f016772f115c74d5981e8a6f0bab0a9a534fea36299f499f002e6"

    # git-annex.cabal: Prevent building with unix-compat 0.7
    # Remove with `stable` block on next release.
    # http://source.git-annex.branchable.com/?p=source.git;a=commitdiff;h=2b40fa51d32a1103d3d56e422a60024cf9270b7b
    patch :DATA
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "1f6a79aad0b51380feaf71af121475a65eddab2aa6331ef277eea620502190f2"
    sha256 cellar: :any,                 arm64_monterey: "08adb3c3fb47d97dab03c67c57ab6f28691eae0368d0bd774c5f6704e0eb12d3"
    sha256 cellar: :any,                 arm64_big_sur:  "2e5f3b435a5a1660522d138ba8f33dbdd9ca0018eb34018fdce759c6bfb21755"
    sha256 cellar: :any,                 ventura:        "fff6589f8cd80f3a04fafad8c13ca1092c0bbcac56600f37b3c99d7e04fc6585"
    sha256 cellar: :any,                 monterey:       "f0a39acacc4fe865e7ef4c38acfe3ea37f41839b06a1e3a7dacfcbe331bf885f"
    sha256 cellar: :any,                 big_sur:        "e7b10a2be6866ca559235be4b27454860ca248df8a2c72cca93fb8980680692e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "637acdbd3c040467e6be7c6d92123daf842d3c4eb92964d240750d18f79b08c5"
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
    system "cabal", "v2-install", *std_cabal_v2_args, "--flags=+S3"
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

__END__
--- a/git-annex.cabal
+++ b/git-annex.cabal
@@ -294,7 +294,7 @@ source-repository head
   location: git://git-annex.branchable.com/
 
 custom-setup
-  Setup-Depends: base (>= 4.11.1.0 && < 5.0), split, unix-compat, 
+  Setup-Depends: base (>= 4.11.1.0 && < 5.0), split, unix-compat (< 0.7), 
     filepath, exceptions, bytestring, IfElse, data-default,
     filepath-bytestring (>= 1.4.2.1.4),
     process (>= 1.6.3),
@@ -318,7 +318,7 @@ Executable git-annex
    case-insensitive,
    random,
    dlist,
-   unix-compat (>= 0.5),
+   unix-compat (>= 0.5 && < 0.7),
    SafeSemaphore,
    async,
    directory (>= 1.2.7.0),