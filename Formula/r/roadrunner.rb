class Roadrunner < Formula
  desc "High-performance PHP application server, load-balancer and process manager"
  homepage "https:roadrunner.dev"
  url "https:github.comroadrunner-serverroadrunnerarchiverefstagsv2024.3.3.tar.gz"
  sha256 "61654351c8fb17ff44438a06b8605f17eb2cb093857d2dd0e113c79eca3a1bcd"
  license "MIT"
  head "https:github.comroadrunner-serverroadrunner.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef50f2b3e808716f36c4b21c2f603cf9be9fa92fe057f6496656f061e3cb6d34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32f5cc60992c8b1e11048bae4634d005409e8857022816c57f095adcedfc05ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "22315a9d44e4ee390bafc3a970fe10ec42c1b68a1ff37c7c27b1f3e111a53ac9"
    sha256 cellar: :any_skip_relocation, sonoma:        "f64590f60248de210be6000aac70d7a78a6e1b94e28495549bbff7fb1cdc1280"
    sha256 cellar: :any_skip_relocation, ventura:       "62bc0d2023234cb15a2ff1a2fcbfce11ea18b6c6027b4201b816951dc7472972"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45a7ca8339453a3b95b16cec56ec6169042e1f7124061f982f230dcef92565f9"
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