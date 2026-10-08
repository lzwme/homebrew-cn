class HelixDb < Formula
  desc "Open-source graph-vector database built from scratch in Rust"
  homepage "https://helix-db.com"
  url "https://ghfast.top/https://github.com/HelixDB/helix-db/archive/refs/tags/v3.4.4.tar.gz"
  sha256 "3386f06852bfb9b5b4a392c97663e38de952183433b0805e985b55a33ecd6f89"
  license "Apache-2.0"

  bottle do
    sha256 arm64_golden_gate: "a4a782ab5b7f1dd91d8aed1e6f4b80d1e62a419f357895e230c8a2b6650f0af2"
    sha256 arm64_tahoe:       "fbfe6039519cdff8fa1253e0905ae55ebf4166ae8db1b898eddbac73c2511d2f"
    sha256 arm64_sequoia:     "005ab9410dd171ace6e27ae09a3b2f4d089004800892921a93ae319ff4b3396d"
    sha256 arm64_linux:       "0f882f3d8e8e1f601fe636cacd35aabf05a066a9005e9b25613dd55718818754"
    sha256 x86_64_linux:      "eb692f5eed358edf31975229772a69db5eec46519d3c351d12e3897b698b206d"
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