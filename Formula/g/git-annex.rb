class GitAnnex < Formula
  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-10.20231129/git-annex-10.20231129.tar.gz"
  sha256 "e85c091e79d3506a19973be728c74b9800fcbff24cf92f0868edbdffb42ace6b"
  license all_of: ["AGPL-3.0-or-later", "BSD-2-Clause", "BSD-3-Clause",
                   "GPL-2.0-only", "GPL-3.0-or-later", "MIT"]
  head "git://git-annex.branchable.com/", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "80af731fe6b1efc015b601099ca1719c044fe50cb10717fb2e512a811bf42d42"
    sha256 cellar: :any,                 arm64_ventura:  "ac805252b8c33d1411e4fd7ce93d5edf69c57a4070bb3406dd00afdef41346e3"
    sha256 cellar: :any,                 arm64_monterey: "ba207bb564348146d893556c8a65c40c43f5f8f750879957db0ae554e87f31e9"
    sha256 cellar: :any,                 sonoma:         "f0eda74e0da8c47ab34ea8b7f86148f136c70296745a43f112929eb7d2b25479"
    sha256 cellar: :any,                 ventura:        "4670e4e2af2b804ca6e06bdb788301175696fed1ce3251f5dd2be97edfb7b037"
    sha256 cellar: :any,                 monterey:       "4825e364e6195f2790f7b17f1d7ef0a58186696b7e26eedc5f7c6223e9259c45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "694f30e741e3dde7e1aabd863df797730291d9599898d2930c6ee85c3ce4e9d6"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.6" => :build
  depends_on "pkg-config" => :build
  depends_on "libmagic"

  def install
    # https://github.com/aristidb/aws/issues/288
    cabal_args = std_cabal_v2_args + ["--constraint=attoparsec-aeson<2.2.0.0"]
    system "cabal", "v2-update"
    system "cabal", "v2-install", *cabal_args, "--flags=+S3"
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