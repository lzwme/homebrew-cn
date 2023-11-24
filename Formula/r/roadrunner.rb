class Roadrunner < Formula
  desc "High-performance PHP application server, load-balancer and process manager"
  homepage "https://roadrunner.dev/"
  url "https://ghproxy.com/https://github.com/roadrunner-server/roadrunner/archive/refs/tags/v2023.3.6.tar.gz"
  sha256 "de24292ff3ffae4e23909614ab665ee0624a83cdcf5b6fa0fc8ee9652c5ef351"
  license "MIT"
  head "https://github.com/roadrunner-server/roadrunner.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c7cf806beeb0c0860b938daf7c6b476d9a3eb59f2b8cdfe9ce2cec070827b6d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a2041cadd5b6fe58b0806fd0421e810b7b1f0ab1d15e6ae7e2f25a064afcd60"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8bee1854ca634ebedec35f8950e9113f6b0db25a936a8b270d1991ef6b00e601"
    sha256 cellar: :any_skip_relocation, sonoma:         "ad6565d7f1892defe63501c6d153f2ba3c058df4f11b43a3dabb37a6b8346dbf"
    sha256 cellar: :any_skip_relocation, ventura:        "01ceaf4317b4fc819515be578334bfad3a7205cfee46281a078c6961e85f26e3"
    sha256 cellar: :any_skip_relocation, monterey:       "ba6ac2d650eb696ff37dc54946caf4c77fef6d905cf46be0ff49d552a064a0bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db45512abd559aaab4c7d38c09690b770a7300667974dabf14abbb8f201a6f9d"
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