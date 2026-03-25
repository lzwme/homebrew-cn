class GoogleworkspaceCli < Formula
  desc "CLI for Drive, Gmail, Calendar, Sheets, Docs, Chat, Admin, and more"
  homepage "https://developers.google.com/workspace"
  # We cannot install from the npm registry because it installs precompiled binaries
  url "https://ghfast.top/https://github.com/googleworkspace/cli/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "bfe44bc17113b798522d74339a276ebf7df049a4c6b56d69bb14527da11fb699"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6793cabf43caed04a9b9f8cf485626adbec8d6c299b960a54a61b36aed02c2f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b59f0692aafb6a84499e815b1855f736a00f3f861f1dec7f64454a07a065d792"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f78faaaacc8ebe5d1d40264ee35d66544d3463ded7f6c09aa87da8ec8336b7e"
    sha256 cellar: :any_skip_relocation, sonoma:        "21e46b699c54664832fb5d99e4f64090033c2bd507c65f12cdfd3d9f03f8040d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7fc2ff456b52f5c816e723cd19836ce6c3e96a794302da91d470c6891e77e14c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "434ec9393d5850d8c7dfc9aefafa66cc3403554cd19016fcfd99a1e091f64fe2"
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