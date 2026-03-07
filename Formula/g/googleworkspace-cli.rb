class GoogleworkspaceCli < Formula
  desc "CLI for Drive, Gmail, Calendar, Sheets, Docs, Chat, Admin, and more"
  homepage "https://developers.google.com/workspace"
  # We cannot install from the npm registry because it installs precompiled binaries
  url "https://ghfast.top/https://github.com/googleworkspace/cli/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "1a7445195f96fd76860442c821f57614d41debfa5cfdc09791ac7db5f987288f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f59166b4acb964aa45c2fd3f578f24e0fa72d531c75cec511eb0e9e75efeda7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91960430d91270907d58f19c75c57dc01672ffdba320ce2e5a9d33dbb617e023"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "660b976d061aa3f472199d8a2994397b51cc0864d2b6af09cc393f5e1d9eb018"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c29742c67faa7c24a7f65f07e54c823537f4a0d81d5938ea6c263c4b16a3ad1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d33909e1baf425f17fb8b0350b979b7555d09a2f96929d4eacf20e423e0fa2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f9fa773be521ce7b2138a9f4736da9b54ae835df88a6d0d7aec0eb643842d5f"
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