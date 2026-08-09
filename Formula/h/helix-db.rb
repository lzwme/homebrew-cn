class HelixDb < Formula
  desc "Open-source graph-vector database built from scratch in Rust"
  homepage "https://helix-db.com"
  url "https://ghfast.top/https://github.com/HelixDB/helix-db/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "8365d8dc9e842bb87ddb796261fe9916bd304c81cc9adcdc1273fd0f2785b2b8"
  license "Apache-2.0"

  bottle do
    sha256 arm64_tahoe:   "1a2a396ce89eb04185b341fa10be74f6bc5fc0674ac112a7a3de4ba265b471ba"
    sha256 arm64_sequoia: "bd59e0a0140a746b2420d1998b94d57dc11b8dbb3a0f53c33b342babffc995ff"
    sha256 arm64_sonoma:  "54b5442465cdb8d9b1e84cbb30f5e740261e32575e9efab735382910a7cc233d"
    sha256 sonoma:        "97abf47991194eb9f3194fa99cf319964dc63e712b77b609309b2af200f180ca"
    sha256 arm64_linux:   "199a1276c0fa4a651cb13e6d33fa7a1ae8e8077cb1ce55d74ab1f47614462883"
    sha256 x86_64_linux:  "6eda9e27e98ab24d5ac64d6063cf096921efa92a155f5b62c68a60ef87bcaa76"
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