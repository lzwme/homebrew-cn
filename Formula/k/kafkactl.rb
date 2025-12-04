class Kafkactl < Formula
  desc "CLI for managing Apache Kafka"
  homepage "https://deviceinsight.github.io/kafkactl/"
  url "https://ghfast.top/https://github.com/deviceinsight/kafkactl/archive/refs/tags/v5.16.0.tar.gz"
  sha256 "95da6a5a2fc129b26f359d255de1e35d5135ff1f8c87f1f64e5b89538e6e1c17"
  license "Apache-2.0"
  head "https://github.com/deviceinsight/kafkactl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79b120cfe41c0e0253006d6ffdc531a16bf0fbd6df2b691469c1cf7f314d39fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79b120cfe41c0e0253006d6ffdc531a16bf0fbd6df2b691469c1cf7f314d39fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79b120cfe41c0e0253006d6ffdc531a16bf0fbd6df2b691469c1cf7f314d39fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "6178c9a2586f3539e9df1098982912f63031691a89698e1a48036af54f862867"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "535383e9dbc06bdaa53378fc75a5c056ce46fd4d677fdd047eb8dd15546c0c37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9744eeaf1b1d8cbf55ad3c43e20a65e800cd74eaeb01ded20dd6200bdd7b91f9"
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