class MercuryCli < Formula
  desc "CLI interface for Mercury banking"
  homepage "https://github.com/MercuryTechnologies/mercury-cli"
  url "https://ghfast.top/https://github.com/MercuryTechnologies/mercury-cli/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "2a89aa657050a799a0705cbd14d7967e82a0f60a944b7acb27a05d9413a58227"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f991a32eb64d998beaff9b52899e48c8c804e144f93ff77788c704869723b658"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f991a32eb64d998beaff9b52899e48c8c804e144f93ff77788c704869723b658"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f991a32eb64d998beaff9b52899e48c8c804e144f93ff77788c704869723b658"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1f04adceb2e453962161c8c534b7f2a6aaecb8eee295c4bdf76128ea7a404a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f3212c3d3c36aca09dc86eff9f86b0be1e7f8a6ca05046f58bcf4b1a3bf96c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3c771b1f1216cd94d30099323cdd0b20a05419ced620fbdcda6baaa78132ea7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"mercury"), "./cmd/mercury"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mercury --version")
    assert_match "Authentication Status", shell_output("#{bin}/mercury status 2>&1")
    assert_match "Your dedication to modern banking has not gone unnoticed", pipe_output("#{bin}/mercury hat 2>&1")
  end
end