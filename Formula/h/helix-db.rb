class HelixDb < Formula
  desc "Open-source graph-vector database built from scratch in Rust"
  homepage "https://helix-db.com"
  url "https://ghfast.top/https://github.com/HelixDB/helix-db/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "b00ff6213065f1b8a29251656ccee5f11b17f120832269ceb38fe26e0e1dd22a"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "38f06fdef522655150063a9401ebb8f86bfcb230e02fc4953084ba1ef2af6dce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f4d30569d3d4030e51660c452f6dd6e1d0f82c02f945ca96f3c1861a68a54cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72063d891e2a367734de19c945acb746d83adc2ea5d7c136e6d38d13dd396a00"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa09186f4730ac4c4cb0baf493729812d4aca5b1c7391db7fdd88247390cc579"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9843887e03bb186ace4892fc7db8a64ede653a1ee7cb8624eba9cbd9edc0b5dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ddebb1a2b68bff78f16021c3b8c0adbf0bbf861266c85e242cd0a1e40346f21"
  end

  depends_on "rust"
  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "helix-cli")
  end

  test do
    assert_match "Initializing Helix project", shell_output("#{bin}/helix init")
    assert_path_exists testpath/"helix.toml"
    assert_path_exists testpath/"db"
    assert_path_exists testpath/"db/queries.hx"
    assert_path_exists testpath/"db/schema.hx"

    assert_match "SUCCESS", shell_output("#{bin}/helix add local 2>&1")
    assert_match "already exists in helix.toml", shell_output("#{bin}/helix add local 2>&1", 1)

    (testpath/"db/schema.hx ").write "N::User { name: String }"
    assert_match "error: helix.toml already exists in #{testpath}", shell_output("#{bin}/helix init 2>&1", 1)
  end
end