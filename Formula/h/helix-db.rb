class HelixDb < Formula
  desc "Open-source graph-vector database built from scratch in Rust"
  homepage "https://helix-db.com"
  url "https://ghfast.top/https://github.com/HelixDB/helix-db/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "463779516e6281ad35c1bce60825f7b161befedab0fcac173ef7d269b21501b3"
  license "Apache-2.0"

  bottle do
    sha256 arm64_golden_gate: "b2b66449696a999bb342e1319cd93c1b61ac1e4e03a9b74c9581818df41fb621"
    sha256 arm64_tahoe:       "cf6f635d709600e2301cff2c43ed95f6e5d9eb4f2875431e21596b96a5be46a9"
    sha256 arm64_sequoia:     "ce5fa54f17363e9c95e84714f3dfa1e0ba4d948f8c73313dcf5f45502bad1d3c"
    sha256 arm64_linux:       "d9460fa7ecafa2b678e970d84b2f0baa02ef368b9f3b7894fe9ffe9adc127c8d"
    sha256 x86_64_linux:      "52894b2520ad30ceb3d4b701640316bc84ab9f640c2d18dc47ea8df61b7420b8"
  end

  depends_on "rust"

  on_linux do
    depends_on "openssl@3"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
  end

  test do
    project = testpath.to_s.split("/").last
    assert_match "Initialized #{project}", shell_output("#{bin}/helix init 2>&1")

    assert_path_exists testpath/"helix.toml"

    assert_match "Added test", shell_output("#{bin}/helix add local --name test 2>&1")
    assert_match "already exists in helix.toml", shell_output("#{bin}/helix add local --name test 2>&1", 1)

    assert_match "helix.toml already exists in #{testpath}", shell_output("#{bin}/helix init 2>&1", 1)
  end
end