class HelixDb < Formula
  desc "Open-source graph-vector database built from scratch in Rust"
  homepage "https://helix-db.com"
  url "https://ghfast.top/https://github.com/HelixDB/helix-db/archive/refs/tags/v2.2.7.tar.gz"
  sha256 "f310e270dfb90b8031593f12576988aadbf0675939729940ff2b1f764a57a762"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b0868f623782ddafabec0552581560d1b96e9d4e986dc775dfcd7bb478cd6112"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb790496501c4a8dc9838abc7c81267f35aab9cd33c4d1e261457a56f4fdbe3f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4bf24aac478caea8af581302f660d348b1766f5a2baa60486dc9bba55e29418a"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d9e59bb2237920fc7cf302c86d9e1399229b04eee5214655f1005ffb4130527"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1ad57e3f2d6e3761d7994119d7186e4a211e87248bddcf4bf0d3c5c10c1fbe0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4976b7889935bbde311f0273079f77ff7f5419e5c473e3c6f5c6c87743fbb0be"
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