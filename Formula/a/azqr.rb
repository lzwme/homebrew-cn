class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https://azure.github.io/azqr/"
  # pull from git tag to get submodules
  url "https://github.com/Azure/azqr.git",
      tag:      "v.3.1.1",
      revision: "b5a1f6b526893e4aa2f57103c0e3d33971359e9d"
  license "MIT"
  head "https://github.com/Azure/azqr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "08d484cec26df74bd767a534a03f160edfebdc7b414dadf499f31b302a51cc51"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08d484cec26df74bd767a534a03f160edfebdc7b414dadf499f31b302a51cc51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08d484cec26df74bd767a534a03f160edfebdc7b414dadf499f31b302a51cc51"
    sha256 cellar: :any_skip_relocation, sonoma:        "024ec32b5f8112f9bb539bbcfd434a330dabea6c15bea84197a7a22045ba61d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "deac6537edcdd84c2bc3345590dbe53de852a48376634b5ed1c6439fc78bbf60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e81bbe92d18a1dac7af775e48902a0183e594aeffa15f6b38592c88ed8d15994"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Azure/azqr/cmd/azqr/commands.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/azqr"

    generate_completions_from_executable(bin/"azqr", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azqr -v")
    output = shell_output("#{bin}/azqr scan --filters notexists.yaml 2>&1", 1)
    assert_includes output, "failed reading data from file"
    output = shell_output("#{bin}/azqr scan 2>&1", 1)
    assert_includes output, "Failed to list subscriptions"
  end
end