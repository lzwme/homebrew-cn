class Kafkactl < Formula
  desc "CLI for managing Apache Kafka"
  homepage "https://deviceinsight.github.io/kafkactl/"
  url "https://ghfast.top/https://github.com/deviceinsight/kafkactl/archive/refs/tags/v5.14.0.tar.gz"
  sha256 "cf7bbd17b2664e12bd4ca78ff579c359f894cf8df202fcf1014fbca21a212171"
  license "Apache-2.0"
  head "https://github.com/deviceinsight/kafkactl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b07e3798db9709f83a12451efb54e373f14acf1ebc1caaf7d3b8827b02b9441"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b07e3798db9709f83a12451efb54e373f14acf1ebc1caaf7d3b8827b02b9441"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b07e3798db9709f83a12451efb54e373f14acf1ebc1caaf7d3b8827b02b9441"
    sha256 cellar: :any_skip_relocation, sonoma:        "eed48865d1a2e36603aaf2c74b5e89e925a1db106545009821da7267d86594ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2308dfdbdce35abf85159dd7cfd2eaf24190c084a0e7066a2989fb6a4d213e9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9b0a3fdae1792ade3da96a8d45b33e1f534f309af957559b5a5d55102497530"
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

    generate_completions_from_executable(bin/"kafkactl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kafkactl version")

    output = shell_output("#{bin}/kafkactl produce greetings 2>&1", 1)
    assert_match "Failed to open Kafka producer", output
  end
end