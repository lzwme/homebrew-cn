class Snap < Formula
  desc "Tool to work with .snap files"
  homepage "https:snapcraft.io"
  url "https:github.comsnapcoresnapdreleasesdownload2.68.2snapd_2.68.2.vendor.tar.xz"
  version "2.68.2"
  sha256 "489c1e22e6236d039b185304e7b4a9705505ad9124cbce89885bef96b1717807"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "628310a2d8cb560e9e139db64372f6b5f030fe54a2f4424f38ea98968e7c8737"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "628310a2d8cb560e9e139db64372f6b5f030fe54a2f4424f38ea98968e7c8737"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "628310a2d8cb560e9e139db64372f6b5f030fe54a2f4424f38ea98968e7c8737"
    sha256 cellar: :any_skip_relocation, sonoma:        "de45fcea117d90095a341b1041ce4c31a52e5fd1138be1a1eb1b0d225e173c36"
    sha256 cellar: :any_skip_relocation, ventura:       "de45fcea117d90095a341b1041ce4c31a52e5fd1138be1a1eb1b0d225e173c36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4328c106cc966b7c76e2ff3034a159bbe92525ab9063eb21964af511e99ad0f"
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
    (testpath"pkgmetasnap.yaml").write <<~YAML
      name: test-snap
      version: 1.0.0
      summary: simple summary
      description: short description
    YAML
    system bin"snap", "pack", "pkg"
    system bin"snap", "version"
  end
end