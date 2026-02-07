class HelixDb < Formula
  desc "Open-source graph-vector database built from scratch in Rust"
  homepage "https://helix-db.com"
  url "https://ghfast.top/https://github.com/HelixDB/helix-db/archive/refs/tags/v2.2.8.tar.gz"
  sha256 "50296aeeff274b2e7fc6f37de3c749d08132a14484a1803a0d62c38abaefc0de"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab1f15696027e1c17702de245fb64278a5cedb288169bf545ef8c8c7e1211760"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9208fc4098088331969f48349168f1d463f32612898c96f64950229100ef485f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07369cb2ce50003aec8b545f16c3bb9851477c52f8a4c53795255754496dcee2"
    sha256 cellar: :any_skip_relocation, sonoma:        "20d1a5321ac7f048385e7a207e1107a368314fdcface69645a92b78feedfac58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3c593a37863eb0f46ba52ece76d79b6711cf64a01aa9d74642ead6d7d5efedb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5238a852f9bd60161722ab0c3b51115aa7d920bbea7bf37de01c00aa8c940cc"
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
    assert_path_exists testpath/"db"
    assert_path_exists testpath/"db/queries.hx"
    assert_path_exists testpath/"db/schema.hx"

    assert_match "Added '#{project}' successfully", shell_output("#{bin}/helix add local 2>&1")
    assert_match "already exists in helix.toml", shell_output("#{bin}/helix add local 2>&1", 1)

    (testpath/"db/schema.hx ").write "N::User { name: String }"
    assert_match "error: helix.toml already exists in #{testpath}", shell_output("#{bin}/helix init 2>&1", 1)
  end
end