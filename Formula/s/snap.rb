class Snap < Formula
  desc "Tool to work with .snap files"
  homepage "https:snapcraft.io"
  url "https:github.comsnapcoresnapdreleasesdownload2.68snapd_2.68.vendor.tar.xz"
  version "2.68"
  sha256 "317166b18e6b87a1fb24c45b96bc3c0040072ab31a99252db622245ac271dbb2"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6de3c9c13deb1fd24f419d5fea8b3c35e43499ab48a830b3ed87e70690a29378"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6de3c9c13deb1fd24f419d5fea8b3c35e43499ab48a830b3ed87e70690a29378"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6de3c9c13deb1fd24f419d5fea8b3c35e43499ab48a830b3ed87e70690a29378"
    sha256 cellar: :any_skip_relocation, sonoma:        "22be50430ac8de90a76ca49bbe1d44ed1a66df0991820565f1cc44e87dd11edc"
    sha256 cellar: :any_skip_relocation, ventura:       "22be50430ac8de90a76ca49bbe1d44ed1a66df0991820565f1cc44e87dd11edc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b98495a7e4d669bb61400c2f0f68c245b33c60364407f4ba5204d4f1df69349d"
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