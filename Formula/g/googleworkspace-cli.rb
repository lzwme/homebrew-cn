class GoogleworkspaceCli < Formula
  desc "CLI for Drive, Gmail, Calendar, Sheets, Docs, Chat, Admin, and more"
  homepage "https://developers.google.com/workspace"
  # We cannot install from the npm registry because it installs precompiled binaries
  url "https://ghfast.top/https://github.com/googleworkspace/cli/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "385feb75f45da21da4ed09f6a4d3785fbf6dca3c114ebd9f1bdc053a1afffdc5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "32f553609d6579c20d4efca6e40cd6ac00f4ff8f05b35b9bcdf372394cc86e79"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1c550d96a7a7118dfc9a905125e85e031ac4a65b19299ada3a7a889ae4be13b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb8b481027a507dfa9267f71477889bbaba2f4848e9b6c9f60d0b0d0a79ddc6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "05d7d1fd7efb6034b3cf921845e3a2cd62c6c1582e95c5856981569b4cb80e38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b780738ded46e397ee21c5668b4e7c140cbc179ad2272705caf5f94427efc9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb3befa2fc469339fa45a91e568d01b24746c796c5ba180f821ecd8c5cd6b1d9"
  end

  depends_on "rust" => :build

  conflicts_with "gws", because: "both install a `gws` binary"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gws --version")
    output = shell_output("#{bin}/gws drive files list --params '{\"pageSize\": 10}'", 1)
    assert_match "Access denied. No credentials provided.", output
  end
end