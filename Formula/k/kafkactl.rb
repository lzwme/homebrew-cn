class Kafkactl < Formula
  desc "CLI for managing Apache Kafka"
  homepage "https://deviceinsight.github.io/kafkactl/"
  url "https://ghfast.top/https://github.com/deviceinsight/kafkactl/archive/refs/tags/v5.17.1.tar.gz"
  sha256 "67c23bf72cff4b7eb444a06b8afcfd0ae800fb8a3ab38cce66ffdbc7f4893107"
  license "Apache-2.0"
  head "https://github.com/deviceinsight/kafkactl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "559d801f8bbb18ad408a4a70d1646163934e0234800aae748f11592ada3399c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "559d801f8bbb18ad408a4a70d1646163934e0234800aae748f11592ada3399c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "559d801f8bbb18ad408a4a70d1646163934e0234800aae748f11592ada3399c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "2197efd9cec0af09b3182b8fc0587d81d5f60a7fa93024d0ab6449611636f017"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84172829b25df9a55a0d5f26d5502a6b36d2a5a3a68b3d433a449e16446a54ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ce9840c820478afbebf5917ae14faa4f9a158dde4bf5d12a6f4be7572a51d99"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/deviceinsight/kafkactl/v5/cmd.Version=v#{version}
      -X github.com/deviceinsight/kafkactl/v5/cmd.GitCommit=#{tap.user}
      -X github.com/deviceinsight/kafkactl/v5/cmd.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kafkactl", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kafkactl version")

    output = shell_output("#{bin}/kafkactl produce greetings 2>&1", 1)
    assert_match "Failed to open Kafka producer", output
  end
end