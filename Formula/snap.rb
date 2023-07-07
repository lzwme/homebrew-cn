class Snap < Formula
  desc "Tool to work with .snap files"
  homepage "https://snapcraft.io/"
  url "https://ghproxy.com/https://github.com/snapcore/snapd/releases/download/2.60.1/snapd_2.60.1.vendor.tar.xz"
  version "2.60.1"
  sha256 "f7b4a95501179d1aaf7e066989b3543a38eec44c623caffc2e149875def41a4b"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d582cbb07644ee0a2a6900b59875b7782f9eb3101651faabce805a0f58701b7f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d582cbb07644ee0a2a6900b59875b7782f9eb3101651faabce805a0f58701b7f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d582cbb07644ee0a2a6900b59875b7782f9eb3101651faabce805a0f58701b7f"
    sha256 cellar: :any_skip_relocation, ventura:        "9a67fb94aa3b149ad137370903f058d5e5966bdb28057583de1d8aa21152a679"
    sha256 cellar: :any_skip_relocation, monterey:       "9a67fb94aa3b149ad137370903f058d5e5966bdb28057583de1d8aa21152a679"
    sha256 cellar: :any_skip_relocation, big_sur:        "9a67fb94aa3b149ad137370903f058d5e5966bdb28057583de1d8aa21152a679"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a11291ae4656b78a40cf13e95c746f7abaec8e30304e49684d3a73d983ddbc5"
  end

  depends_on "go" => :build
  depends_on "squashfs"

  def install
    system "./mkversion.sh", version
    tags = OS.mac? ? ["-tags=nosecboot"] : []
    system "go", "build", *std_go_args(ldflags: "-s -w"), *tags, "./cmd/snap"

    bash_completion.install "data/completion/bash/snap"
    zsh_completion.install "data/completion/zsh/_snap"

    (man8/"snap.8").write Utils.safe_popen_read(bin/"snap", "help", "--man")
  end

  test do
    (testpath/"pkg/meta").mkpath
    (testpath/"pkg/meta/snap.yaml").write <<~EOS
      name: test-snap
      version: 1.0.0
      summary: simple summary
      description: short description
    EOS
    system bin/"snap", "pack", "pkg"
    system bin/"snap", "version"
  end
end