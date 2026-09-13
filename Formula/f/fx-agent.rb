class FxAgent < Formula
  desc "Tiny, open, embeddable, native coding agent"
  homepage "https://fx.sh"
  url "https://ghfast.top/https://github.com/vercel-labs/fx/archive/refs/tags/v0.0.9.tar.gz"
  sha256 "b5c0599af8e93d91059f3fb423e4f16d4295cca0414fac2c2e0d53f1ac5aa519"
  license "Apache-2.0"
  head "https://github.com/vercel-labs/fx.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "32d2bf75e3a905e1bc84ce053008276d9a4194de11eeee591e5681aca515844b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bd2fb9f499ab93e8aa3bf7a74c5ca290307fcbea377ed05f0a3cce9357f939f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "00edf9b19742561613057ce9e9d275c900bfc503aa7d9afbf37f32f3a9b8d32d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8e58578ef8c936d27216952b3ab3b6fbfbf09d3da3d14b011c1160962491cd2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ca0b3e07dcce711cd824700b130603d952bf173188da35b4ace4396aaca5882c"
  end

  depends_on "zig" => :build

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