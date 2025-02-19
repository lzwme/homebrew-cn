class Roadrunner < Formula
  desc "High-performance PHP application server, load-balancer and process manager"
  homepage "https:docs.roadrunner.devdocs"
  url "https:github.comroadrunner-serverroadrunnerarchiverefstagsv2024.3.4.tar.gz"
  sha256 "8e4b76f5ea362c7aa450429bfeb927e97f6a6584a013a41a4519aaf4c17a6156"
  license "MIT"
  head "https:github.comroadrunner-serverroadrunner.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "583a100e1b9fe0f0f37c0b56e6f8bc94f1440ccf6148f6231985224fbf0e4a91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5293affdf8fba38465f17e91ccb0ccdba0702a1b70004a45f099548c22ea562f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cefa50c9d88acded363a0fdf25a0d61c38fc3f37a9d8331268e413352c36d210"
    sha256 cellar: :any_skip_relocation, sonoma:        "d88d79f52d41d3785da9cbe7adb9a86ce418695ec750a844309fa9a2aadbf00b"
    sha256 cellar: :any_skip_relocation, ventura:       "b967c60767d0d1508e9c0638742aac6c7ea81f162438ad296006cd84fa02debe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec90a25a626187d17ac4bf77feed1b4c138caf81fb8867833a73c775d81a318e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comroadrunner-serverroadrunnerv#{version.major}internalmeta.version=#{version}
      -X github.comroadrunner-serverroadrunnerv#{version.major}internalmeta.buildTime=#{time.iso8601}
    ]
    system "go", "build", "-tags", "aws", *std_go_args(ldflags:, output: bin"rr"), ".cmdrr"

    generate_completions_from_executable(bin"rr", "completion")
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