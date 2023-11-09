class PhylumCli < Formula
  desc "Command-line interface for the Phylum API"
  homepage "https://www.phylum.io"
  url "https://ghproxy.com/https://github.com/phylum-dev/cli/archive/refs/tags/v5.8.1.tar.gz"
  sha256 "c723c87832d47694fe55cc860bb7969efec52c5ac0bcee917d3bd6b2e1a1ccfc"
  license "GPL-3.0-or-later"
  head "https://github.com/phylum-dev/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "367a4616ff626124f3e75a5192e64f6d5d6fd7289afb8c3d5c1a03f3630da482"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf6f221c27afba65de24263bb6c6db4a047ea7f6d00547acd88c6416060a6873"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ff70b6edf50b09e56995710c2d6b09dbb385e0ecf0aef83b5fad3974b920d62"
    sha256 cellar: :any_skip_relocation, sonoma:         "8d9d955083afc6e13de273bef89b925cb1c8c7c61f89ea869d2efc6999639038"
    sha256 cellar: :any_skip_relocation, ventura:        "21c49a3c99a285ccda22760afb1975029bc4aa33cea1e368d40dfbdea2770da9"
    sha256 cellar: :any_skip_relocation, monterey:       "4920d2fde5cd71b4776a57aeef2d264836c27d272a14f3935f568c6f38f78769"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ebd35eac681d32b88fc09b95b69896107982b9ea8db0a2976a7089138ec42c2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/phylum version")

    output = shell_output("#{bin}/phylum extension")
    assert_match "No extensions are currently installed.", output
  end
end