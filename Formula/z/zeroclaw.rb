class Zeroclaw < Formula
  desc "Rust-first autonomous agent runtime"
  homepage "https://github.com/zeroclaw-labs/zeroclaw"
  url "https://ghfast.top/https://github.com/zeroclaw-labs/zeroclaw/archive/refs/tags/v0.6.8.tar.gz"
  sha256 "c90444808091fffc86b5ee903af0a91ecf759c9e694a328d18eb5723594b6301"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/zeroclaw-labs/zeroclaw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d713836f5ab34dc25f3f85c2ce72d89e3d5bbcc32f69329418205b7bdc8d22e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb7e9b82ef37b74e7b5c591ae6bc72a84857ca6dc7b04944e67f475153c2b3d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99da6d6d6daa68d49a78d2f95ee15f531c3fc65b2800ce43a8f9d0ca425f8155"
    sha256 cellar: :any_skip_relocation, sonoma:        "003abecb068bff61ea45f85ef5b5981ecb641882b370969a5d7a4ea91a73219a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e1c2990b9507b75e891364f908d6171fd02745175ab2fe7720e7260580f12e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2ac7a36576ff65a1e8d2c016640776400860782067fcec9192fd728c11f16af"
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