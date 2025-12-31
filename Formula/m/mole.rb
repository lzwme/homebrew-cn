class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://github.com/tw93/Mole"
  url "https://ghfast.top/https://github.com/tw93/Mole/archive/refs/tags/V1.17.0.tar.gz"
  sha256 "327717e53c4d61d4a2f076b3f9b8dc9f79f2d95c1bb135d38be0110e38bc6089"
  license "MIT"
  head "https://github.com/tw93/Mole.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c97d822f94a5a7724f0ac7bf0b16ca2ab70c049fa54eb9dec95c0d2d88c37f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f47abcd1c9fc2791cb667af3fade6f86445c30d3f6a997a73e4695b756e8b485"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5dca63e45251edd1851547e8be9e481818bd57d84b6151f62e86821c0ea7b3a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e43973c1e1b2a1bcbaf85da1a8bb6e1927db8d3e8e140a4c3374ecac6335047"
  end

  depends_on "go" => :build
  depends_on :macos

  def install
    # Remove prebuilt binaries
    buildpath.glob("bin/*-go").map(&:unlink)
    ldflags = "-s -w -X main.Version=#{version} -X main.BuildTime=#{time.iso8601}"
    %w[analyze status].each do |cmd|
      system "go", "build", *std_go_args(ldflags:, output: buildpath/"bin/#{cmd}-go"), "./cmd/#{cmd}"
    end

    inreplace "mole", 'SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"',
                      "SCRIPT_DIR='#{libexec}'"
    libexec.install "bin", "lib"
    bin.install "mole"
    bin.install_symlink bin/"mole" => "mo"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mole --version")
    output = shell_output("#{bin}/mole clean --dry-run 2>&1")
    assert_match "Dry run complete - no changes made", output
  end
end