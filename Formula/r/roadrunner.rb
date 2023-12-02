class Roadrunner < Formula
  desc "High-performance PHP application server, load-balancer and process manager"
  homepage "https://roadrunner.dev/"
  url "https://ghproxy.com/https://github.com/roadrunner-server/roadrunner/archive/refs/tags/v2023.3.7.tar.gz"
  sha256 "d966ce578287b555658b85d7a0850afae831cc1d0170fd76762154a074a2a38d"
  license "MIT"
  head "https://github.com/roadrunner-server/roadrunner.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5ec10e7e0fd3c11305b0af4b117ca935b8b5a06fd7a1203cb1b860d2730ca443"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f0d67f14534f331e257c513a7d30aeaed906b44960f043f62e6d4084279aeaf8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0603b3da9746b1c398a1bad7cd61e402c5173bf5cb5bb0dad6d615f9653d079"
    sha256 cellar: :any_skip_relocation, sonoma:         "ab0334a218f126d07f4671427bc651450a8d5653aa942ccec80992cb60687d8a"
    sha256 cellar: :any_skip_relocation, ventura:        "f133f6d6285022e7d080d16bf05317990c1d12e2046dcbc1782643e5eaf57cb1"
    sha256 cellar: :any_skip_relocation, monterey:       "fef317425204e2f7537797dc38d08be2bae6856cc12224248f9a56e165c97373"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60fa9f67cc20cafaaea395bf2dc50cbe842459b263f6c181d3d338f753c2300c"
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