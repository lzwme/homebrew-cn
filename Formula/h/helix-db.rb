class HelixDb < Formula
  desc "Open-source graph-vector database built from scratch in Rust"
  homepage "https://helix-db.com"
  url "https://ghfast.top/https://github.com/HelixDB/helix-db/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "f58278f8f3f05dfde71fa801789282b1a8a6f88aeedf7c8f78690ed2ba0777c6"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "624fab301c597c5f09654c119c53ec4e13c62e18d649b3d48c61dacc3a122036"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f382b167886b0073c892a41be611d4902a84b456e29f6f2be9a85426a80cad01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9f16a2983e385d88503d8078c44b41e9bc9e19f0ae9b8520451ac4bd20c956f"
    sha256 cellar: :any_skip_relocation, sonoma:        "dfe68cbf93ba8479f1214b2facd6d70a7cbe5bf42550ab97d9db2a66f405eb65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3442a77551dbe127103291c7e95a47ff222717509b2807a5066b1a890b17c372"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "039a81b73443b9de443c31eeb46b277fa6d9ff09062563428a673da43b5a49f7"
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