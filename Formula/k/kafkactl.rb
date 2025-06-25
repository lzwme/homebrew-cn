class Kafkactl < Formula
  desc "CLI for managing Apache Kafka"
  homepage "https:deviceinsight.github.iokafkactl"
  url "https:github.comdeviceinsightkafkactlarchiverefstagsv5.10.0.tar.gz"
  sha256 "c51ba608949a029151b90185c8977fad4cf24c0b0ea1f41f8b0da9434d252701"
  license "Apache-2.0"
  head "https:github.comdeviceinsightkafkactl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32ca932cf76f1450a60e8a47b521a20c971486773c0c5babadbe124238e95b23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32ca932cf76f1450a60e8a47b521a20c971486773c0c5babadbe124238e95b23"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "32ca932cf76f1450a60e8a47b521a20c971486773c0c5babadbe124238e95b23"
    sha256 cellar: :any_skip_relocation, sonoma:        "f82860fbd94c40183891a0ca035a36e8f3efbe6df4fb016f997df070a187dda2"
    sha256 cellar: :any_skip_relocation, ventura:       "f82860fbd94c40183891a0ca035a36e8f3efbe6df4fb016f997df070a187dda2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9e674403b9462d608bc88eb84ede915b338849506af5959ac4a388619ae4fc8"
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