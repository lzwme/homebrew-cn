class GitAnnex < Formula
  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-10.20230329/git-annex-10.20230329.tar.gz"
  sha256 "a19f7dec686f016772f115c74d5981e8a6f0bab0a9a534fea36299f499f002e6"
  license all_of: ["AGPL-3.0-or-later", "BSD-2-Clause", "BSD-3-Clause",
                   "GPL-2.0-only", "GPL-3.0-or-later", "MIT"]
  head "git://git-annex.branchable.com/", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d3f448ee5adc2252fd0bbc38e16df2b52ef86c9af4dcd03d61d0848093ce388b"
    sha256 cellar: :any,                 arm64_monterey: "6bf7efbad707fcd1c773944c5575ea08ee73717a99883ae11e4ec00fc5d04c08"
    sha256 cellar: :any,                 arm64_big_sur:  "c10cca3db35270b2233773ed9895f0f43136c25130ee1451970b5149a8a07fb1"
    sha256 cellar: :any,                 ventura:        "debd7c91fb7b63edf2f3d2fbf188814b71fba2e67460bbf48b6b89b7c00fce4c"
    sha256 cellar: :any,                 monterey:       "eec8f0221d9351fb8c546df8e19c859b81c6b7dfa66c1fb2368c69516c5c893d"
    sha256 cellar: :any,                 big_sur:        "5e3812cb1f065e7ac6ca3c9705b00387ea1e28004f41c946f9bcb99466ef032f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f043d8f6fc85b6b07dacb3e6a955623971814a61632699cb0f486d61b7e4d481"
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

    # Fix "Could not find module ‘System.PosixCompat.User’".
    # The module was removed in unix-compat-0.7; see:
    #   https://hackage.haskell.org/package/unix-compat-0.7/changelog
    # Reported upstream at
    #   https://git-annex.branchable.com/bugs/System.PosixCompat.User_removed_in_unix-compat-0.7/
    inreplace "git-annex.cabal", "unix-compat (>= 0.5)", "unix-compat (>= 0.5 && < 0.7)"

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