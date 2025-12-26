class Kafkactl < Formula
  desc "CLI for managing Apache Kafka"
  homepage "https://deviceinsight.github.io/kafkactl/"
  url "https://ghfast.top/https://github.com/deviceinsight/kafkactl/archive/refs/tags/v5.16.0.tar.gz"
  sha256 "95da6a5a2fc129b26f359d255de1e35d5135ff1f8c87f1f64e5b89538e6e1c17"
  license "Apache-2.0"
  head "https://github.com/deviceinsight/kafkactl.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a3bb8c54558980fe1a61ec70464b5607e7e7fa6e2f59530f4478787d14d908d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3bb8c54558980fe1a61ec70464b5607e7e7fa6e2f59530f4478787d14d908d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3bb8c54558980fe1a61ec70464b5607e7e7fa6e2f59530f4478787d14d908d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9558ace72ff4a20157c8e5dff6b2bf7fb26fa2323b63f9b96c5400a5b4e9180"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "694636005668aa45da5df544290f60e9b4f3ce68b009505375b5a9c1ec30faa1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10bb59c712fa574b8b07e3f7526196965fdedf2f06ee35103c41e3441f68ddd0"
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