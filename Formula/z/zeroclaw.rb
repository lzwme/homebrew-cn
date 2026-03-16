class Zeroclaw < Formula
  desc "Rust-first autonomous agent runtime"
  homepage "https://github.com/zeroclaw-labs/zeroclaw"
  url "https://ghfast.top/https://github.com/zeroclaw-labs/zeroclaw/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "929241d33d4cb21c462374aec0b6630ad3cc194d5367d5f0cee83136e1b59771"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/zeroclaw-labs/zeroclaw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc0c0c10fba0ac5f27b0776cdcea1fbe69380dfb22b5ca4f96d2239c14471946"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f001194a3ed2b51264f9ee70be296869fb2c00a8aa54d4234ae601c8aec5d510"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0071d1eae3fdb36b92e3c73dbebb1c816fe8926666ed971f30f5dd34fd3c279"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a04c9acd4cb3c7db85ed963159cb992b256a42af99e275b211b3a6b68c2841f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b33a6a23463638971d0e92712a1ee28589b3d68c3f7aba928fbfaa651eec4528"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3176cc6c4bd8d440817188f75d5d0ab597b042607b2e26b540dd896fac0e9a33"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  service do
    run [opt_bin/"zeroclaw", "daemon"]
    keep_alive true
    working_dir var/"zeroclaw"
    environment_variables ZEROCLAW_WORKSPACE: var/"zeroclaw"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zeroclaw --version")

    ENV["ZEROCLAW_WORKSPACE"] = testpath.to_s
    assert_match "ZeroClaw Status", shell_output("#{bin}/zeroclaw status")
    assert_path_exists testpath/"config.toml"
  end
end