class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https://azure.github.io/azqr/"
  # pull from git tag to get submodules
  url "https://github.com/Azure/azqr.git",
      tag:      "v.2.7.6",
      revision: "b4a5d4980f346858f56be656cfce7a9fe4172635"
  license "MIT"
  head "https://github.com/Azure/azqr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af1671178ecb7eef9ff010703623d58fec061801b608dbd55657034b345362fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af1671178ecb7eef9ff010703623d58fec061801b608dbd55657034b345362fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "af1671178ecb7eef9ff010703623d58fec061801b608dbd55657034b345362fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a86ab4153eb57350964091d19a9544deeff0049fc7a92ea38529c036fdb3026"
    sha256 cellar: :any_skip_relocation, ventura:       "1a86ab4153eb57350964091d19a9544deeff0049fc7a92ea38529c036fdb3026"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e122cb8965adf55b3fb134c2e263e74c617d5baa92271a4125a5bb01391e3f1a"
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