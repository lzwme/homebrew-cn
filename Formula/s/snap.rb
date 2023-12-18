class Snap < Formula
  desc "Tool to work with .snap files"
  homepage "https:snapcraft.io"
  url "https:github.comsnapcoresnapdreleasesdownload2.61.1snapd_2.61.1.vendor.tar.xz"
  version "2.61.1"
  sha256 "775b7a250f5241b3bfcebcb3df5055b9c9304c4520502b7abf12438a1cdd771d"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "09fa8b606620dcef1848994d9d21f1fd01703c328a974a03443a258fe6d25cdc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a093b27dad166ad8485a4a5d177cfb410ca15b9c3cd435886d8d4130ab760ddf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e8a44c2bf082e1a401a6dc9c54ec23053a847e1957be095e497c37a89a551ee"
    sha256 cellar: :any_skip_relocation, sonoma:         "3a762caeec8f618dfe4394ea6a9918e7854284518654f76054b68fd016ca6654"
    sha256 cellar: :any_skip_relocation, ventura:        "e02f1b1613d0cd99018b97035bbd7935cc96d144ef932b635c92b40661255a69"
    sha256 cellar: :any_skip_relocation, monterey:       "2d9c670ec7ecef3a022fb9244b93dde6ff279d30b8fbb9bbbf650a2d46148330"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2d66b922258414a1d9cfcac7f39edbde946fb0ee4beae62a0d7da7f85c47c2f"
  end

  depends_on "go" => :build
  depends_on "squashfs"

  def install
    system ".mkversion.sh", version.to_s
    tags = OS.mac? ? ["-tags=nosecboot"] : []
    system "go", "build", *std_go_args(ldflags: "-s -w"), *tags, ".cmdsnap"

    bash_completion.install "datacompletionbashsnap"
    zsh_completion.install "datacompletionzsh_snap"

    (man8"snap.8").write Utils.safe_popen_read(bin"snap", "help", "--man")
  end

  test do
    (testpath"pkgmeta").mkpath
    (testpath"pkgmetasnap.yaml").write <<~EOS
      name: test-snap
      version: 1.0.0
      summary: simple summary
      description: short description
    EOS
    system bin"snap", "pack", "pkg"
    system bin"snap", "version"
  end
end