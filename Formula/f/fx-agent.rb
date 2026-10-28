class FxAgent < Formula
  desc "Tiny, open, embeddable, native coding agent"
  homepage "https://fx.sh"
  url "https://ghfast.top/https://github.com/vercel-labs/fx/archive/refs/tags/v0.0.15.tar.gz"
  sha256 "1358cafff78bb6375fab5a5216235eafdde84057e84cc122d841a920af3d1361"
  license "Apache-2.0"
  head "https://github.com/vercel-labs/fx.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3f29b8a12d28f2692ea3e6f0dce73f242874eae77dc909e27ad1364c76467a37"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b45b2bd62b4b0ca4e55d0946b6c2bd33bf768573ea5bde02b227eee8e1b8bb1c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8bb855346e278c00690609c65c9b25e17bbd909066d76b615ecfb1940b345380"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3575eb780e4b25317c8fa6edfc762b1e44438d896f5c713929e8e588bc13cd63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "539a73fddbf33c20be2ce56796e7eaf51bd3a67d88e0d097a5c14ae473b06395"
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