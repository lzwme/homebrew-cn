class Roadrunner < Formula
  desc "High-performance PHP application server, load-balancer and process manager"
  homepage "https://roadrunner.dev/"
  url "https://ghproxy.com/https://github.com/roadrunner-server/roadrunner/archive/refs/tags/v2023.3.2.tar.gz"
  sha256 "b832acd9d31dc1154fbb5ecb4a281f38ccaa759ffc7af60de00c5ff608f3857e"
  license "MIT"
  head "https://github.com/roadrunner-server/roadrunner.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7a7bd924c5e4b0f89f0de95ed5fb3e922bf53c8450e3c792e7f6ff88656340f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc62915a254c57891b8fe3f17e75757b608bae44fc77f9fe127b5f4ba0164cae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "590d1993201a8e9885cac110e31c05d97174b2e5a7e9ff1c96dcc528d8e34528"
    sha256 cellar: :any_skip_relocation, sonoma:         "9560ff732db2cd8a0f0bbde4fc70ed0af40ce89a0692ff2cfd1f2cec8b364e2c"
    sha256 cellar: :any_skip_relocation, ventura:        "59ca3c758b519268deef8c2d82495c51624c44874500854e85f7dadb3744d637"
    sha256 cellar: :any_skip_relocation, monterey:       "a5e5472bbbf519116773f6c9dc52e91341ae0ddd0d2e65bc8c7b24758623dd4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "840478d9e9a6fc0a5d083ec033dd1daa778dc682968e7699576ae3fc9f298f13"
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