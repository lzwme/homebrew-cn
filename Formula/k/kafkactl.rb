class Kafkactl < Formula
  desc "CLI for managing Apache Kafka"
  homepage "https:deviceinsight.github.iokafkactl"
  url "https:github.comdeviceinsightkafkactlarchiverefstagsv5.6.0.tar.gz"
  sha256 "489540ec9ce6c95efe39d6794f54eb472a6d8d8dc1e33be2ac75ef932d751287"
  license "Apache-2.0"
  head "https:github.comdeviceinsightkafkactl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7942ef6baed562bdc266be1df67b25602aef138b09807ae541fa432a3f6ae706"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7942ef6baed562bdc266be1df67b25602aef138b09807ae541fa432a3f6ae706"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7942ef6baed562bdc266be1df67b25602aef138b09807ae541fa432a3f6ae706"
    sha256 cellar: :any_skip_relocation, sonoma:        "f29157d05983fc2201a0732416feadb56a3e42d8ba16543f3987c1012fe2aebf"
    sha256 cellar: :any_skip_relocation, ventura:       "f29157d05983fc2201a0732416feadb56a3e42d8ba16543f3987c1012fe2aebf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05419326e9e12ab89c9e44079c4b7bdfbc9bd1df56734039458bdbbf27fe8a72"
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