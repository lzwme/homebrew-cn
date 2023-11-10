class Roadrunner < Formula
  desc "High-performance PHP application server, load-balancer and process manager"
  homepage "https://roadrunner.dev/"
  url "https://ghproxy.com/https://github.com/roadrunner-server/roadrunner/archive/refs/tags/v2023.3.4.tar.gz"
  sha256 "d0d72d97912184dcbc1d08f9d0aefa20c030a16e36ce3cd08af8375676f87eb9"
  license "MIT"
  head "https://github.com/roadrunner-server/roadrunner.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "62fb61d370c7da663d51bcf48d54d26885a4b5186d38aea02f1447e2ff571a11"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d513723410516d315661a4fa9b117a47cedc4145e4d479c36818e4d2292052d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e160e65aece27a95be7c491aec442e2733d255f0105141f086c0de79c2ffa33"
    sha256 cellar: :any_skip_relocation, sonoma:         "027470b1fbfdb9ebb27511ad10a82ea06a4c6c693e9e00899035b3cda37b982a"
    sha256 cellar: :any_skip_relocation, ventura:        "45c1691bd19833a12add721dd76cd1a6b9b3dce8ccbfc0483c75ce9816d3759c"
    sha256 cellar: :any_skip_relocation, monterey:       "8baaf7c1e124b5d8cb222ac1971cbe09f1e521bb0b060f0f7b0b8641b07d669d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d203b9c3acbf866cb80cede0d29412586a526e6f20b693dd8fd9dc3936893e8"
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