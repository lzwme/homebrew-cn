class HelixDb < Formula
  desc "Open-source graph-vector database built from scratch in Rust"
  homepage "https://helix-db.com"
  url "https://ghfast.top/https://github.com/HelixDB/helix-db/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "c12ae9ffa93bb2e15ce656fd5e3cb32af26e6b020ae6ca3f2365ad74de75aef7"
  license "Apache-2.0"

  bottle do
    sha256 arm64_golden_gate: "75a3dded845e13ce8e9a04700943069fa2fa80e72c9f87049763b7635db6cb90"
    sha256 arm64_tahoe:       "d0e96f627e6ca478f76825b56a32495cc295d9358599eb29a8ac46e98d28e027"
    sha256 arm64_sequoia:     "01591be7c09f16f48bec14b98406a66bf38a5decb77d229af6fbbfbaf58946c5"
    sha256 arm64_linux:       "c0671e64677fb61e39da3fa4d503b088a82bf8fd74307699237bc3546cbd4778"
    sha256 x86_64_linux:      "0b89d0ddf190c08ad47e632942eb879d3519b24f3dd29aa6510bf60a519c19c9"
  end

  depends_on "rust"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
  end

  test do
    project = testpath.to_s.split("/").last
    assert_match "Initialized '#{project}' successfully", shell_output("#{bin}/helix init")

    assert_path_exists testpath/"helix.toml"

    assert_match "Added 'test' successfully", shell_output("#{bin}/helix add local --name test 2>&1")
    assert_match "already exists in helix.toml", shell_output("#{bin}/helix add local --name test 2>&1", 1)

    assert_match "helix.toml already exists in #{testpath}", shell_output("#{bin}/helix init 2>&1", 1)
  end
end