class Roadrunner < Formula
  desc "High-performance PHP application server, load-balancer and process manager"
  homepage "https://roadrunner.dev/"
  url "https://ghproxy.com/https://github.com/roadrunner-server/roadrunner/archive/refs/tags/v2023.3.5.tar.gz"
  sha256 "c5551cd656c8d4ba1c08a060e9dc1cfded40d6d7131061fc7a0e09b9163ab951"
  license "MIT"
  head "https://github.com/roadrunner-server/roadrunner.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eb1139acea66683f3bd9bb6f6f34130c1bee6c7534e724e8a3a6003ec11141c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f66a301fcfce7765aeefa2681d637d94aeea54389a44d3d6e76c524192f3546"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4c8af6e7639fa11238de48f6d16e9463c7ae31c19c139fd10eab804bb3ba540"
    sha256 cellar: :any_skip_relocation, sonoma:         "96d4b25fe5ef7c56e2c70f564a8cc121791682539544e79767eda5a2826c8a94"
    sha256 cellar: :any_skip_relocation, ventura:        "b01358f9eac99cd624f53dbcec755936f5963a812f0faf1b220d65224a98e4a4"
    sha256 cellar: :any_skip_relocation, monterey:       "f192d859c10c93961d2eebb0bd50ba1bab5083e166072b13a9712d6c42849d66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0266f4ae3f630bd2cfde0b10b3a0f7ff8f5232c336b04c8f91b99e37e0282066"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/roadrunner-server/roadrunner/v2023/internal/meta.version=#{version}
      -X github.com/roadrunner-server/roadrunner/v2023/internal/meta.buildTime=#{time.iso8601}
    ]
    system "go", "build", "-tags", "aws", *std_go_args(output: bin/"rr", ldflags: ldflags), "./cmd/rr"

    generate_completions_from_executable(bin/"rr", "completion")
  end

  test do
    port = free_port
    (testpath/".rr.yaml").write <<~EOS
      # RR configuration version
      version: '3'
      rpc:
        listen: tcp://127.0.0.1:#{port}
    EOS

    output = shell_output("#{bin}/rr jobs list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/rr --version")
  end
end