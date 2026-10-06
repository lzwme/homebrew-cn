class MermanCli < Formula
  desc "Mermaid.js, but headless, in Rust"
  homepage "https://frankorz.com/merman/"
  url "https://ghfast.top/https://github.com/Latias94/merman/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "900fcb1c947e886ba501f5b5663f89455724fe16c3623fa5bb30b116bec7e33a"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dfd0f0d555b053f0223ec45756634efd974c3e2206dbd0fc69d55e94a6c24267"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a541cd63827a5b7d9987ebede55c8113fce2f9c5cef14adcadb4445c189a2513"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "42497596399555985ca847d0622220b5456926fb5dbdeb4128618b76b2fecd5e"
    sha256 cellar: :any,                 arm64_linux:       "a634bb48f22175c980a3faf74f2424ad574f3f5e94e5f0d201e1bedfb1fbd016"
    sha256 cellar: :any,                 x86_64_linux:      "2526d5ca799a1469a5d313ee160cf68800207f7ac1a5ad3ca07045b78cc2a1e6"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/merman-cli")
  end

  test do
    mermaid = <<~MMD
      flowchart TD
        A[Start] --> B{Decision}
        B -->|Yes| C[Do thing]
        B -->|No| D[Do other thing]
    MMD
    testdata = testpath/"sample.mmd"
    testdata.write(mermaid)
    assert_match "svg", shell_output("#{bin}/merman-cli render --format svg --output - #{testdata}")
  end
end