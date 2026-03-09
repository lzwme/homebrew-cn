class HelixDb < Formula
  desc "Open-source graph-vector database built from scratch in Rust"
  homepage "https://helix-db.com"
  url "https://ghfast.top/https://github.com/HelixDB/helix-db/archive/refs/tags/v2.3.2.tar.gz"
  sha256 "90863b3eac381173e49cbb9031f41abb3117c3d0fe88ab3d2c04c5f75a7457f7"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87d1cedb5f11d79b02d2dc85c6da85c4dc963941c7012e93050a4ee9268a32dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a3a0416fa65ab622154edab793cde5fbbc8f7d538e9db75285b67d90983810b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f8e095ce0674fd7a40c7657a5571ea05468e3d54128bf5d49baa50226e486dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc17d3d1ada63f50d0314bc6d047e0bbc83b7597a4be3dd7035a98b7d7c5d6eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "713de1ca8242be26894eef7126ee3e133841e1da2e46aa7f2277ab20def45fe8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c046c84a62c5cc44cd9910adcf7f62e94b6f38a0f3bd758b57126a5e0fbdc5e8"
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