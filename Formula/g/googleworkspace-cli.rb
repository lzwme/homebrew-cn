class GoogleworkspaceCli < Formula
  desc "CLI for Drive, Gmail, Calendar, Sheets, Docs, Chat, Admin, and more"
  homepage "https://developers.google.com/workspace"
  # We cannot install from the npm registry because it installs precompiled binaries
  url "https://ghfast.top/https://github.com/googleworkspace/cli/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "047d8576614bdd047c8c8c7febb305420a0e1eb74ee0b26fc3529c96160c1c61"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26cea49436fc5e99f61b1063d04b8810742f3f73bdc6d8a2dd90e8fee268cc54"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc19a7d22870d531d622af4d626dff4d247d482b43a4fa81a2a7f9abf0ca7a9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18e61922603913546b45016755a48a90e234ecdda47d05962d8f89c57be4ee3f"
    sha256 cellar: :any_skip_relocation, sonoma:        "abe703268bc060f7df18b0dff737ae2b557e771b8418b393230022572789ea58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d6315be11d4f9e56890aa0e4ae6d29ed4df9b8de573048cf6210b0e85bf950a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b76e4bcbef6e8932cba179784ba70f87e83f010391a2496d5a5e40d0296dec5"
  end

  depends_on "rust" => :build

  conflicts_with "gws", because: "both install a `gws` binary"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gws --version")
    output = shell_output("#{bin}/gws drive files list --params '{\"pageSize\": 10}'", 2)
    assert_match "Access denied. No credentials provided.", output
  end
end