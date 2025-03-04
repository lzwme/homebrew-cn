class Kafkactl < Formula
  desc "CLI for managing Apache Kafka"
  homepage "https:deviceinsight.github.iokafkactl"
  url "https:github.comdeviceinsightkafkactlarchiverefstagsv5.5.0.tar.gz"
  sha256 "d8611f0ac3c091216e5cfff21ae1cc6de2fe0d72bdc0f0a47b7a1b0507a6b157"
  license "Apache-2.0"
  head "https:github.comdeviceinsightkafkactl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9acad5b914763f89340a8a0cd62173fb2703e5acdcc1f8ca58765c6fa7a50c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9acad5b914763f89340a8a0cd62173fb2703e5acdcc1f8ca58765c6fa7a50c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e9acad5b914763f89340a8a0cd62173fb2703e5acdcc1f8ca58765c6fa7a50c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "959aa526759e6a7b40ed808b5eea08efb980f686d41af10b757b04764c516974"
    sha256 cellar: :any_skip_relocation, ventura:       "959aa526759e6a7b40ed808b5eea08efb980f686d41af10b757b04764c516974"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff2f34ce6e8c6b4a177bb44e62e45ac78cd8aafe316858e54ab39f404c95bba2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comdeviceinsightkafkactlv5cmd.Version=#{version}
      -X github.comdeviceinsightkafkactlv5cmd.GitCommit=#{tap.user}
      -X github.comdeviceinsightkafkactlv5cmd.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"kafkactl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}kafkactl version")

    output = shell_output("#{bin}kafkactl produce greetings 2>&1", 1)
    assert_match "Failed to open Kafka producer", output
  end
end