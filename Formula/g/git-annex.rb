class GitAnnex < Formula
  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-10.20240731/git-annex-10.20240731.tar.gz"
  sha256 "b1b6b7aea692a7f852b1002ac0c5840821e6ebe56d99d82d9fb24794de2e720e"
  license all_of: ["AGPL-3.0-or-later", "BSD-2-Clause", "BSD-3-Clause",
                   "GPL-2.0-only", "GPL-3.0-or-later", "MIT"]
  head "git://git-annex.branchable.com/", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ad33034b115e104dfd7d3ba8896c7b122f5b3ca2ea311129a4c1637ea7550eb0"
    sha256 cellar: :any,                 arm64_ventura:  "cd70757a6db530b054453f6a5074a9e42d9e590d727b13f594762f4a01929305"
    sha256 cellar: :any,                 arm64_monterey: "b93903326cabd76947e61cba7ea6a23e17f037c9775c5c993e171fb92fce887c"
    sha256 cellar: :any,                 sonoma:         "919d9395afd6ded8b5e063072440bd3f160fe9b6875102604c59565af6848475"
    sha256 cellar: :any,                 ventura:        "4b43bead6189aa58fa973f9ba10e756afd07d471c2ed8aae1e8ac23d1b47dfaf"
    sha256 cellar: :any,                 monterey:       "8458eb1a491b2b5dacaaeb4436c27ffe83e118f6cc0d0e8405aa04665c7f3574"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab847970c73a31168ee77c9fc3f0abbe25cc09f6f2b0ec4db73c5bd91cb9e474"
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