class HelixDb < Formula
  desc "Open-source graph-vector database built from scratch in Rust"
  homepage "https://helix-db.com"
  url "https://ghfast.top/https://github.com/HelixDB/helix-db/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "7d62d8f774ea5c4529d3e9b15b2feaec72d6ef6a74592e8895bdf80e934ce50d"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0d64ec2183ada867eab36317c7be689f721d6a6d393a223aa74d59695646ca4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5bec8db0ccb5f5a8afcf9d3824e86102d7aaec77bd1ecefd3009aa84d5962e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09d41ab7fbfe504e858ffb5261791772006d4ab22986504d6ce9a1e531161753"
    sha256 cellar: :any_skip_relocation, sonoma:        "245a3a2fad4771141ebed74009ad9595aff692729437d4fc3a11bda0e72781cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "afcf94780bf886595000c4ff0238fb1ddf50618da799788eb054ff5a15fbc1ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "351d97f972d8ef2766553dd5c52fcc1ea5d54198f13e1d62519041b21a869046"
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