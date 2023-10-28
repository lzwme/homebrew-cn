class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://ghproxy.com/https://github.com/cloudflare/pint/archive/refs/tags/v0.48.1.tar.gz"
  sha256 "bdc37796dd9fe27510e5f4bfdb8a1abcc7bcaabe46b4231adb6c442f3b40f094"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7285ac74a32dbbcc35d3a09d154146c788ee4be409ce977a95b0fe1ffa1d12c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "480bd7dd40b67d75da7d8979f22c711273d70d033f31f44a3d0b60485771b5e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29f78b436bd58e85b833f78d45bdadcc03bc742f38ecadfd9f4f12ab97753de2"
    sha256 cellar: :any_skip_relocation, sonoma:         "92a3d71c28b30c721fb1ace3970bde692b29d94f1cfd6eaec3ac8478bfa08d1d"
    sha256 cellar: :any_skip_relocation, ventura:        "60f3a86de900218858235f3fb2e648b104a5598c8a9122af1c3ab6499fa1e031"
    sha256 cellar: :any_skip_relocation, monterey:       "c6e7df1705abce223334c9dcdd0c2b3bb360931fdf03fb9f5b056043b7f1e4d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8d1bf061f3936810da5493861b45aebb45dff85aaaee4b7e1da3814dc20661a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/pint"

    pkgshare.install "docs/examples"
  end

  test do
    (testpath/"test.yaml").write <<~EOS
      groups:
      - name: example
        rules:
        - alert: HighRequestLatency
          expr: job:request_latency_seconds:mean5m{job="myjob"} > 0.5
          for: 10m
          labels:
            severity: page
          annotations:
            summary: High request latency
    EOS

    cp pkgshare/"examples/simple.hcl", testpath/".pint.hcl"

    output = shell_output("#{bin}/pint -n lint #{testpath}/test.yaml 2>&1")
    assert_match "level=INFO msg=\"Loading configuration file\" path=.pint.hcl", output
    assert_match "level=INFO msg=\"Problems found\" Warning=3", output

    assert_match version.to_s, shell_output("#{bin}/pint version")
  end
end