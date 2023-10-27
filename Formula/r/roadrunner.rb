class Roadrunner < Formula
  desc "High-performance PHP application server, load-balancer and process manager"
  homepage "https://roadrunner.dev/"
  url "https://ghproxy.com/https://github.com/roadrunner-server/roadrunner/archive/refs/tags/v2023.3.3.tar.gz"
  sha256 "143ebad697ffbc780b0f434dd38db55f0cc8b044218fd8e82cf82d0ff5c0dc30"
  license "MIT"
  head "https://github.com/roadrunner-server/roadrunner.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ced603ac7ba0624d459d5c2e2eb313fa05c1cae1c94c625be3bfb0741db879cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "131df7938263fcc1b0da7792e276c1b7eed85bed3b0ed21efcf7345ab15d70ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "653651905f662e7c576e5b950437f4ceebaa4370824b78bf1704007016ddccb5"
    sha256 cellar: :any_skip_relocation, sonoma:         "ae0c72f2e58a7704b0e8d6109c779810c190e359f27ac2db9526358720708d2c"
    sha256 cellar: :any_skip_relocation, ventura:        "cb25da43d37df98c3f8d811d6f8d46c669c1e72a3295fd14185a8a7e4fbdfc50"
    sha256 cellar: :any_skip_relocation, monterey:       "fe88d1de99bfceee7d25a5ecb8c9b7a64b2d3aee8e61c49e1cef52f2062bd91a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c706eebb120bf6ab96417b0ecc61c736af6ca22a7c93795abbed893052f0746e"
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