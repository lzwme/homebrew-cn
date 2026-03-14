class GoogleworkspaceCli < Formula
  desc "CLI for Drive, Gmail, Calendar, Sheets, Docs, Chat, Admin, and more"
  homepage "https://developers.google.com/workspace"
  # We cannot install from the npm registry because it installs precompiled binaries
  url "https://ghfast.top/https://github.com/googleworkspace/cli/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "19d3c004bb33627eaed9d9aa3eaecbabb8e6f30f03a7842d9f9a46c9bcd1ee30"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "31cc20af924f6ad37ecb6fe60d78242dcfecc5889e7ba25c4d3d54b9aec56dd4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a880bb7d580c2e0e5a0212cacdb8e5fa0ab159cf3c200faff4a81d72ea177a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8efdeaf106ac91ad5d04cd12107e6cbde5849b8712f9e952db5ccb59683f0c82"
    sha256 cellar: :any_skip_relocation, sonoma:        "76c22eb7bdeb2de1689628210c8a97490e8620f193fdd52f9143e0196f67e800"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "165ca0c8659386acf4520e96d0394b4c3d35916210254bb562cb7b0a8bc18506"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bec94bdb976d19affd0d5b1ee1acdaedbd9ba257de240eb0de42cf815cc5e3ac"
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