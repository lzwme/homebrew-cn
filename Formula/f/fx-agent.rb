class FxAgent < Formula
  desc "Tiny, open, embeddable, native coding agent"
  homepage "https://fx.sh"
  url "https://ghfast.top/https://github.com/vercel-labs/fx/archive/refs/tags/v0.0.8.tar.gz"
  sha256 "18c572580ead3bd633b8ff66ce94b88b2aea8bccd41778ef23b7b51f79ec9b8d"
  license "Apache-2.0"
  head "https://github.com/vercel-labs/fx.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3429a241d73d614f975e5c7fe823f93965b4f716657083c7a9cd22c8dbe53c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a98fd3159c53538573c694af2067b903db29c66a3f5feda74208f0f9d61607dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "321d5296b37b6248a058e7745cfea7198aa0378f3ddadc2b79c402635c0f9e5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "937167fb1f969c354585e623d0f0b844858e35832f44fbca99e3f12c2af3e0b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25865224bc7f14878e86f6407fc6a05ba3cfeac810a0f4aa13ecd266fa435ce9"
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