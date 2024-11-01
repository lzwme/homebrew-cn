class GitAnnex < Formula
  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-10.20241031/git-annex-10.20241031.tar.gz"
  sha256 "0c8eafec05e8203e3125530fb8d7435f6867e5bebea96db9f9d3a6177c929293"
  license all_of: ["AGPL-3.0-or-later", "BSD-2-Clause", "BSD-3-Clause",
                   "GPL-2.0-only", "GPL-3.0-or-later", "MIT"]
  head "git://git-annex.branchable.com/", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "241a9c71c2edc6da62015b274b8a781576afdf2be56afa9ff6c386cf907a30a1"
    sha256 cellar: :any,                 arm64_sonoma:  "cd350703654df0c663f6464e69fa13109bffac23a52715586bd4dc5fd80404bb"
    sha256 cellar: :any,                 arm64_ventura: "5fee27ee7183918c611e396cd43d2f2a1371afe6a1ddb07b9f3d1feac25dab15"
    sha256 cellar: :any,                 sonoma:        "701800c7192fc5a98f6d79080dc234be25a2034a12f49949f5e764c0879ebdff"
    sha256 cellar: :any,                 ventura:       "a14e2be39d6b82676ce895797e8276ec36635c4a4ecaa455ce5e89a8cef052c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63a4be2635e2d76b3e39971418a6c5d52eacbd7ca29b689590d087d9d8a20bae"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.8" => :build
  depends_on "pkg-config" => :build
  depends_on "libmagic"

  uses_from_macos "zlib"

  def install
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
                 "webdav adb tahoe glacier ddar git-lfs httpalso borg rclone hook external"

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