class GoogleworkspaceCli < Formula
  desc "CLI for Drive, Gmail, Calendar, Sheets, Docs, Chat, Admin, and more"
  homepage "https://developers.google.com/workspace"
  # We cannot install from the npm registry because it installs precompiled binaries
  url "https://ghfast.top/https://github.com/googleworkspace/cli/archive/refs/tags/v0.22.1.tar.gz"
  sha256 "53d5fdf3911d6e559fc6d422e9c17d8555e64234c21a8907374f6d88b9fa2717"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "97c8fa101ddf2ebf12d8d1a24885c580fe5518572554ad232227e5de57a850ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "952ebcc8753b00353c618f237a01eb25f1eeaa3f190ef96b13ed62419d08d7d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "889b753977cd74fac278f8b9fbb790ea9c39fea2df98e8fada9909694d53b978"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3b5129e691c2d1e852565b5cf88ff7c3284248b534d75b9a77006518a5d2a3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0b8fdb3b44c3b271c50572482d1114d65427510d220dcd72cc6909a13a0ccbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8c9ed1a0f4670b34f7eceff621dd691751125cfe82492d6180323d0b337560e"
  end

  depends_on "rust" => :build

  conflicts_with "gws", because: "both install a `gws` binary"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/google-workspace-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gws --version")
    output = shell_output("#{bin}/gws drive files list --params '{\"pageSize\": 10}'", 2)
    assert_match "Access denied. No credentials provided.", output
  end
end