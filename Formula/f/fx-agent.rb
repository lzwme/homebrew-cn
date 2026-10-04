class FxAgent < Formula
  desc "Tiny, open, embeddable, native coding agent"
  homepage "https://fx.sh"
  url "https://ghfast.top/https://github.com/vercel-labs/fx/archive/refs/tags/v0.0.12.tar.gz"
  sha256 "03497fc19f2b73e110546d38951151842c63bfe174c978537285024b246bd6d9"
  license "Apache-2.0"
  head "https://github.com/vercel-labs/fx.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "acd2865425ad0465c6d4b3a9626b3c7df19c2654d07d3a4d1994535bb6564dbf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "202d5fceb499e28e983e8c0eb12ad258dd10c36f6cbdf0414f2375c653b27c8f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "db2deb4bb5a9908a8feb4deeb084db86a85454fad8e74b3aa3f100ead4e99ac4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b59b62832290920186537027d15f9bf562b380c6c2e3180f5e4eb9d4fe33238b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "39379a5085eef7e7abb9dea50836d55725a65335f12e34854228afae501a65f1"
  end

  depends_on "zig@0.16" => :build

  conflicts_with "fx", because: "both install an `fx` binary"

  deny_network_access!

  def install
    system "zig", "build", *std_zig_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fx --version")

    output = shell_output("#{bin}/fx ask hello 2>&1", 1)
    assert_match "fx needs access to Vercel AI Gateway", output
  end
end