class Kafkactl < Formula
  desc "CLI for managing Apache Kafka"
  homepage "https:deviceinsight.github.iokafkactl"
  url "https:github.comdeviceinsightkafkactlarchiverefstagsv5.10.0.tar.gz"
  sha256 "c51ba608949a029151b90185c8977fad4cf24c0b0ea1f41f8b0da9434d252701"
  license "Apache-2.0"
  head "https:github.comdeviceinsightkafkactl.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e9335fdb4fa576340e429988675911a3aec62a5bd1ed2312e3cc74c1ba83cfb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e9335fdb4fa576340e429988675911a3aec62a5bd1ed2312e3cc74c1ba83cfb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8e9335fdb4fa576340e429988675911a3aec62a5bd1ed2312e3cc74c1ba83cfb"
    sha256 cellar: :any_skip_relocation, sonoma:        "800c386fd8f3d2c38b6be04e13da506b50604f4632b6ddc3dcbe3592e0310f02"
    sha256 cellar: :any_skip_relocation, ventura:       "800c386fd8f3d2c38b6be04e13da506b50604f4632b6ddc3dcbe3592e0310f02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "539c1a9f7373d13d863cdebfdd32e48be1c6da8364b8d818cbeaf9afa99092a7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comdeviceinsightkafkactlv5cmd.Version=v#{version}
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