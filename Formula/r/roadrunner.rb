class Roadrunner < Formula
  desc "High-performance PHP application server, load-balancer and process manager"
  homepage "https://docs.roadrunner.dev/docs"
  url "https://ghfast.top/https://github.com/roadrunner-server/roadrunner/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "bf687e6ae9b544ef51db550a7d7588b4f35fa6e04de768c5e115d36f974030a5"
  license "MIT"
  version_scheme 1
  head "https://github.com/roadrunner-server/roadrunner.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d{1,3}(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dcbc24fda2992803b4e58d3a9fab6a182abb9022fda47e07a30182eb2ffbfb0c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b46cebfb8d5dc927d8d840619ab8ef8577c7db4d7bd72f5f1c5b5eb08559e905"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e64488c6a444ad2e077d07a2527f79d35622a336920fc7dee7d2a7f6d0d42a13"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "101392eb817c572cb39c945708cacfb5f1673acb4cd9092bd68b426fa785814d"
    sha256 cellar: :any,                 x86_64_linux:      "38ff4dfc0da35b6bd902311b47c6bf487cdbd3c31760c11771f939f415a77d74"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/roadrunner-server/roadrunner/v#{version.major}/internal/meta.version=#{version}
      -X github.com/roadrunner-server/roadrunner/v#{version.major}/internal/meta.buildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"rr"), "./cmd/rr"

    generate_completions_from_executable(bin/"rr", shell_parameter_format: :cobra)
  end

  test do
    port = free_port
    (testpath/".rr.yaml").write <<~YAML
      # RR configuration version
      version: '3'
      rpc:
        listen: tcp://127.0.0.1:#{port}
    YAML

    output = shell_output("#{bin}/rr jobs list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/rr --version")
  end
end