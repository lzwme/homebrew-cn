class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https://azure.github.io/azqr/"
  # pull from git tag to get submodules
  url "https://github.com/Azure/azqr.git",
      tag:      "v.2.7.3",
      revision: "5f4cd0f878177a0c3bac2509f010abbf6d6b7da5"
  license "MIT"
  head "https://github.com/Azure/azqr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7bec97e908ad56096b430fec3ca151ed8a1fcda36376a7b5b6830461177e98d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7bec97e908ad56096b430fec3ca151ed8a1fcda36376a7b5b6830461177e98d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7bec97e908ad56096b430fec3ca151ed8a1fcda36376a7b5b6830461177e98d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "16bdaf8c9050614f102f5e4a8da8d8b8e2442abdb800b8822d7d4f2cf8d71222"
    sha256 cellar: :any_skip_relocation, ventura:       "16bdaf8c9050614f102f5e4a8da8d8b8e2442abdb800b8822d7d4f2cf8d71222"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c616bbc15caaeef567a3cf2ad0c87c033b431cfddaf4238b84506fc2dffac48"
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