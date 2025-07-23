class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https://azure.github.io/azqr/"
  # pull from git tag to get submodules
  url "https://github.com/Azure/azqr.git",
      tag:      "v.2.7.2",
      revision: "8c07d67ae6c9db38f2dcfd50c9e4b4bc68cfc910"
  license "MIT"
  head "https://github.com/Azure/azqr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96a2eb75f45b9fa219cace655db282b8513b5f909023f62b47ee278012ad6c27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96a2eb75f45b9fa219cace655db282b8513b5f909023f62b47ee278012ad6c27"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "96a2eb75f45b9fa219cace655db282b8513b5f909023f62b47ee278012ad6c27"
    sha256 cellar: :any_skip_relocation, sonoma:        "d38476c15c7e8b2bbda2b9f70d33e9a0aa0f228c8cd36e0dbc102631e9af0fff"
    sha256 cellar: :any_skip_relocation, ventura:       "d38476c15c7e8b2bbda2b9f70d33e9a0aa0f228c8cd36e0dbc102631e9af0fff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f95f92e96dadc942550b9e91e6db2779cffa8fd75cb4d24b724ba5c954ed76f1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Azure/azqr/cmd/azqr/commands.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/azqr"

    generate_completions_from_executable(bin/"azqr", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azqr -v")
    output = shell_output("#{bin}/azqr scan --filters notexists.yaml 2>&1", 1)
    assert_includes output, "failed reading data from file"
    output = shell_output("#{bin}/azqr scan 2>&1", 1)
    assert_includes output, "Failed to list subscriptions"
  end
end