class GitAnnex < Formula
  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-10.20240701/git-annex-10.20240701.tar.gz"
  sha256 "900144c443eebc83b6c17f7a31158d7e26c5410f33e1d6af518b680dbecfe020"
  license all_of: ["AGPL-3.0-or-later", "BSD-2-Clause", "BSD-3-Clause",
                   "GPL-2.0-only", "GPL-3.0-or-later", "MIT"]
  head "git://git-annex.branchable.com/", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "aa282f45dad6dd903dd5a5c5d21fd518cd8618e4ee8ab2b88dea9b9138d60002"
    sha256 cellar: :any,                 arm64_ventura:  "d012a6804621911623c1a3ac5c814897883774f3518ff11e55beb04709f2ba23"
    sha256 cellar: :any,                 arm64_monterey: "73100f70036d45dd68970c4debd28b93b9efbe4073e898abccc75a9e86ce7e9e"
    sha256 cellar: :any,                 sonoma:         "ffaaae3b38f9041e1a78ca86bfcc2b1bce97a9142437cbb08eb7cf6dfebed2dd"
    sha256 cellar: :any,                 ventura:        "290a55b68dbe7730c06f09588324564e48e5647081cf2bee02c66b8830710976"
    sha256 cellar: :any,                 monterey:       "b86843115993725aeda74ee2ac80ed7e462932cdabcf5500b41be4b626c46f2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60e60ec2897e4575c6ef7fdddebbd5c517af6a9a238247745ea99b0296c0d717"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.6" => :build
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