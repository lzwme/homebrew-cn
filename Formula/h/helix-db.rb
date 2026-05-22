class HelixDb < Formula
  desc "Open-source graph-vector database built from scratch in Rust"
  homepage "https://helix-db.com"
  url "https://ghfast.top/https://github.com/HelixDB/helix-db/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "90eea09a53ceda322410f7f9f30498bffe4dec9ce7650f65fc113857a6ce6438"
  license "AGPL-3.0-only"

  bottle do
    sha256 arm64_tahoe:   "af2f58d3722f33db0c04f705222af30c188a6e6e2466c1dc35bc2280f9a2e37c"
    sha256 arm64_sequoia: "70b1e689b1e1aa270346a9e4043542f9173f144de108cf410fab675aab2bc9b6"
    sha256 arm64_sonoma:  "386850ad2499f0a79d67ec900abac82227830ff3b13fbcbbb656d06113cac5b9"
    sha256 sonoma:        "4d65134b02dbdc3aae4b7487adf15c17a87104c8d660136b5ccc17e49c3d6701"
    sha256 arm64_linux:   "df14a714d24d794bbbb5586d3dd48750edf890c5918458188d407e199518a184"
    sha256 x86_64_linux:  "c7e01acc6e89107ada0cb3aa7ea5a8ddee29b61f9c05e9a1226f0d8c45b59615"
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