class HelixDb < Formula
  desc "Open-source graph-vector database built from scratch in Rust"
  homepage "https://helix-db.com"
  url "https://ghfast.top/https://github.com/HelixDB/helix-db/archive/refs/tags/v3.4.1.tar.gz"
  sha256 "946a53daea9d34fd55f4f86e12c09465208f9797e6be1d78121e9a92a7f9bdcd"
  license "Apache-2.0"

  bottle do
    sha256 arm64_golden_gate: "97615bd5be1903b957ea31f0bbcb9fcf5edd203fb357a5e31acad907df62a9ab"
    sha256 arm64_tahoe:       "83b7db1d4416e111676000bcc47107495b93d92e8a6b2a9d728f85d267c5f4d2"
    sha256 arm64_sequoia:     "33d5d807a48ab8c00ea21908a19a04aa16c01f4c5e6f7e5b67291e7d7aeca270"
    sha256 arm64_linux:       "09c385d87871bcfbebd6b57cc229ce5365963d057e998f999f7ae77ba290fba6"
    sha256 x86_64_linux:      "532fe4a53d6cf8426e0d8f02d10f826bc0bd0311715dae7a3ef41aa276e62180"
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