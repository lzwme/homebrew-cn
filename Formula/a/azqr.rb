class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https://azure.github.io/azqr/"
  # pull from git tag to get submodules
  url "https://github.com/Azure/azqr.git",
      tag:      "v.2.7.7",
      revision: "2247c1313c1a0033825d284faaf9c8a90b1ea7fc"
  license "MIT"
  head "https://github.com/Azure/azqr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5ad6b4cf1a7d5038c127b4c5fd550fc46be379d41fc468b0b04a38eb114ce1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5ad6b4cf1a7d5038c127b4c5fd550fc46be379d41fc468b0b04a38eb114ce1e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a5ad6b4cf1a7d5038c127b4c5fd550fc46be379d41fc468b0b04a38eb114ce1e"
    sha256 cellar: :any_skip_relocation, sonoma:        "bbe48e09c1c14e8233c8d8682f04a8bc530581bd9a8c02bb325dd9fe38ce945b"
    sha256 cellar: :any_skip_relocation, ventura:       "bbe48e09c1c14e8233c8d8682f04a8bc530581bd9a8c02bb325dd9fe38ce945b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9d26b2aac2dc06808e02b4307332df9cdb5c2d8efdad79fffca091669d3ad76"
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