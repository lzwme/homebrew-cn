class HelixDb < Formula
  desc "Open-source graph-vector database built from scratch in Rust"
  homepage "https://helix-db.com"
  url "https://ghfast.top/https://github.com/HelixDB/helix-db/archive/refs/tags/v3.0.2.tar.gz"
  sha256 "dd70a415c6e1fad42aeea1513a96b04b2bf78b4b9eccbe282a201bddc315b18b"
  license "AGPL-3.0-only"

  bottle do
    sha256 arm64_tahoe:   "cc7cc535e81ddbeaafda0194f176dc252d459ebe3d60d1f6d00ecd5932a5d7b8"
    sha256 arm64_sequoia: "ac704bfdc92a004f97cb1e7abe351435604767332bf5f65dff309c6f66c9bdfc"
    sha256 arm64_sonoma:  "9f303d3f06dd0e7369a5d25014be0c10216232e8f878d0c447ae15ebfe46884c"
    sha256 sonoma:        "c746aa8bd8463c7b7164be87a458b34a1cbb92e7c613bdf97d5c3156ea005c4a"
    sha256 arm64_linux:   "1f7b92f6606614e595f129ab6417762c9a6136530368452f2d5ceaa871ead5d6"
    sha256 x86_64_linux:  "3a2827cef39b2c6ae5567bdd07fd104ae80ef7edd97915dbfd3c556923b2272b"
  end

  depends_on "rust"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "helix-cli")
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