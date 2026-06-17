class Pay < Formula
  desc "HTTP client that automatically handles 402 Payment Required"
  homepage "https://pay.sh"
  url "https://ghfast.top/https://github.com/solana-foundation/pay/archive/refs/tags/pay-v0.19.0.tar.gz"
  sha256 "4b3d925398f4a7645b60d535be5f7181637233811d20723ea7787908f681c1e9"
  license "MIT"
  head "https://github.com/solana-foundation/pay.git", branch: "main"

  livecheck do
    url :stable
    regex(/^pay[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d0b5470396da843b8f80908fec07aac25df12ceff0a82b60d1498e0a85843aa4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8730d788295a8656b71ec97f85d3fdff5a99059e9da95263aeae82983b39b5c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af97e0e1c7ff4fb1bf14efc5b718e3b702f25890694d2ae09c8630de8656497b"
    sha256 cellar: :any_skip_relocation, sonoma:        "e07cc6dc5d79d4493daae6a0b202972dd0d5ff095c934516370b6c296b32c824"
    sha256 cellar: :any,                 arm64_linux:   "88a7a613c927536018188aaa62bea453412985063a600e5478de54131a3f7bb4"
    sha256 cellar: :any,                 x86_64_linux:  "1d297e06eaf3c62610f5e9373a63d970596689ab14d341df5f6aca74937f0d26"
  end

  depends_on "just" => :build
  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "pnpm" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  uses_from_macos "python"

  def install
    system "just", "install", "pay", *std_cargo_args(path: "rust/crates/cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pay --version")

    expected = "No pay account configured"
    assert_match expected, shell_output("#{bin}/pay --no-dna fetch https://httpbin.org/status/402 2>&1", 1)
  end
end