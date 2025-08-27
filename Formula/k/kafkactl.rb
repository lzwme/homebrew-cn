class Kafkactl < Formula
  desc "CLI for managing Apache Kafka"
  homepage "https://deviceinsight.github.io/kafkactl/"
  url "https://ghfast.top/https://github.com/deviceinsight/kafkactl/archive/refs/tags/v5.12.0.tar.gz"
  sha256 "1a54b398bfe4d634967a393c1cf119f31c0b2d5420230c233a424cfff30eb56b"
  license "Apache-2.0"
  head "https://github.com/deviceinsight/kafkactl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "afc68b534f056da709ee62bb3ef3cafab6fc6a049bb58c8319f1de6462638557"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "afc68b534f056da709ee62bb3ef3cafab6fc6a049bb58c8319f1de6462638557"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "afc68b534f056da709ee62bb3ef3cafab6fc6a049bb58c8319f1de6462638557"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d5c8983d1ee2f5ac1dd94a9d7f142df606c9737fdacef7b7597520026dc5d9e"
    sha256 cellar: :any_skip_relocation, ventura:       "6d5c8983d1ee2f5ac1dd94a9d7f142df606c9737fdacef7b7597520026dc5d9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a87ee75fcd1e41b224d482bfc7013f326eaad1cbd8db82fd0713942b9cf3c820"
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