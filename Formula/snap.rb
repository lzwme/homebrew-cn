class Snap < Formula
  desc "Tool to work with .snap files"
  homepage "https://snapcraft.io/"
  url "https://ghproxy.com/https://github.com/snapcore/snapd/releases/download/2.59.4/snapd_2.59.4.vendor.tar.xz"
  version "2.59.4"
  sha256 "ee34c5db793efcc91a4f9f48c0c283437b8b0a15482dd205ae393d299ae3711b"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9be1229c50090afd6fcba8fd6d345edc76828f0a9b85d5a2a4de696a1d6b7373"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9be1229c50090afd6fcba8fd6d345edc76828f0a9b85d5a2a4de696a1d6b7373"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9be1229c50090afd6fcba8fd6d345edc76828f0a9b85d5a2a4de696a1d6b7373"
    sha256 cellar: :any_skip_relocation, ventura:        "a416c46cd239b2eac9e21fabc47cb3680afbf8bc1162259aa57b85672d1445c6"
    sha256 cellar: :any_skip_relocation, monterey:       "a416c46cd239b2eac9e21fabc47cb3680afbf8bc1162259aa57b85672d1445c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "a416c46cd239b2eac9e21fabc47cb3680afbf8bc1162259aa57b85672d1445c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67a9c9d50bd78531e65eee0f9bd67e3ef8591c774baca57cd1c2021af22af815"
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