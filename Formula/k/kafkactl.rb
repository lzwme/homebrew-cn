class Kafkactl < Formula
  desc "CLI for managing Apache Kafka"
  homepage "https://deviceinsight.github.io/kafkactl/"
  url "https://ghfast.top/https://github.com/deviceinsight/kafkactl/archive/refs/tags/v5.11.1.tar.gz"
  sha256 "3661f29890fe0709838e5464a51e1431f3ef1415140cfc90d0ca627d41ec1206"
  license "Apache-2.0"
  head "https://github.com/deviceinsight/kafkactl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c49a6fcc094508d3fc998f44a1a5916a6a89cc9b05ed49c7bdb2301425cc5072"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c49a6fcc094508d3fc998f44a1a5916a6a89cc9b05ed49c7bdb2301425cc5072"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c49a6fcc094508d3fc998f44a1a5916a6a89cc9b05ed49c7bdb2301425cc5072"
    sha256 cellar: :any_skip_relocation, sonoma:        "d512f12f95600e1c5a7932257b9405354024443d48d4bbe77fb9994b9aba5098"
    sha256 cellar: :any_skip_relocation, ventura:       "d512f12f95600e1c5a7932257b9405354024443d48d4bbe77fb9994b9aba5098"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4694903a00091692938a01d38deb53c933e20439fedc34512379e97814b260ff"
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