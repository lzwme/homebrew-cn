class Roadrunner < Formula
  desc "High-performance PHP application server, load-balancer and process manager"
  homepage "https:roadrunner.dev"
  url "https:github.comroadrunner-serverroadrunnerarchiverefstagsv2024.2.1.tar.gz"
  sha256 "42af64a92eafbff58e8f684fb50a721be9f5668e38b44171c776563e1bd399f8"
  license "MIT"
  head "https:github.comroadrunner-serverroadrunner.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "451c73e478ce1e89972cedb3000c48ede56fbe44ac8d3fce2af36cec9e3f5563"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1a410466a2a76ab968d076b94f3cac1927fd5c3974299a7d7e643e04652c719"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eae38ca8b888a9cea9cb1831fb25460a07dff648e2eb00625c3f17071413ff57"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1633141b912b2802408347d0e6fddfe497d7ecfeae56aaecb891e855a0b0cee"
    sha256 cellar: :any_skip_relocation, ventura:       "e42b6436e67d10f30534d2d610965003005b2101f31aea2ae7005c96699d9853"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b76be12d581849133ffa5a6a2fd5f3764ddff7dab50f5322ca86babfc2a6ed4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comroadrunner-serverroadrunnerv#{version.major}internalmeta.version=#{version}
      -X github.comroadrunner-serverroadrunnerv#{version.major}internalmeta.buildTime=#{time.iso8601}
    ]
    system "go", "build", "-tags", "aws", *std_go_args(ldflags:, output: bin"rr"), ".cmdrr"

    generate_completions_from_executable(bin"rr", "completion", base_name: "rr")
  end

  test do
    port = free_port
    (testpath".rr.yaml").write <<~YAML
      # RR configuration version
      version: '3'
      rpc:
        listen: tcp:127.0.0.1:#{port}
    YAML

    output = shell_output("#{bin}rr jobs list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}rr --version")
  end
end