class HelixDb < Formula
  desc "Open-source graph-vector database built from scratch in Rust"
  homepage "https://helix-db.com"
  url "https://ghfast.top/https://github.com/HelixDB/helix-db/archive/refs/tags/v3.4.3.tar.gz"
  sha256 "b61acf0a43e5c9f28f7e75375036044cbaf6183fcf1a6304673ef02af7f44b7e"
  license "Apache-2.0"

  bottle do
    sha256 arm64_golden_gate: "70cde99f81a6691c26758186141d6d15e589a7e66d14a9757aead900e6f7e055"
    sha256 arm64_tahoe:       "45a998f79709043a7b549f72df7e74cef34518fefa0988de70cb3c648ab59876"
    sha256 arm64_sequoia:     "4276e7c4cb90bfa0a0f36ef62c45f88393ba0b90b1e45915080396f2a015e604"
    sha256 arm64_linux:       "1d15175865a36a79b742211db9c786de98ee70f8e94f8fd02dfb496385a78b55"
    sha256 x86_64_linux:      "5eb19454ae6edb1a85580b2846df0c810ad170e46d3ba77b65abd6c42e8c739a"
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