class GitAnnex < Formula
  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-10.20240831/git-annex-10.20240831.tar.gz"
  sha256 "72e06316098182cea4dd56123b11b8e397a7817134cc815589c91890738cc9d3"
  license all_of: ["AGPL-3.0-or-later", "BSD-2-Clause", "BSD-3-Clause",
                   "GPL-2.0-only", "GPL-3.0-or-later", "MIT"]
  head "git://git-annex.branchable.com/", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "968572a6c12733bdc54e44d053ca4a2f91b34518fdaf04e08dd8d74e508e179c"
    sha256 cellar: :any,                 arm64_ventura:  "4593f290b73192e5e52279ddc93a68a3c09ba19e5e0712c3de294a408c0706df"
    sha256 cellar: :any,                 arm64_monterey: "00b04d98c3a698f5cb6d336a70a007b4afd290728bcae063a9feb7d9a8e8cd67"
    sha256 cellar: :any,                 sonoma:         "fe8ff87a02b32e9647ee4d88ab2de186b4b68baefbf9b910f62d59f06e775388"
    sha256 cellar: :any,                 ventura:        "fb37167d2d5a5db8f9b0d4d86cf25088374bee2ffc7e301851c277762b737825"
    sha256 cellar: :any,                 monterey:       "86270067e4fa21018cee312ec77a91082c03b9d20b52fe1357f12d215d273c7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2e9d30e22b6c3e6b3c991ddae0e96239ec22a48ae5f4fe5e31616c8c2ad0a1b"
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