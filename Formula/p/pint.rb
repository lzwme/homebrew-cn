class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://ghfast.top/https://github.com/cloudflare/pint/archive/refs/tags/v0.76.1.tar.gz"
  sha256 "c73f506e0465fac36e3e43f599b623c5a1e4f33c467895cbe85b4b47bab58b2c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb5ed85c0864d3a295367e3bebde2bff85fd01c05d141ea81782b0c1bc85dd84"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d268460ee0157f7eb7b669cfb4648128ed37f69a42c5c1b3d72300ca948e302"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "046802acaf9a83591fb43770f7e9104389a99a244118f456e0c51ae89bb77d6c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1c51b909491934376f5885ea59e094c1c20b60695d7308348a2400284e6acb7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a565702fb0bfb5db7c29d13c7cdde99ad0feea054070cb110c5ba52e601856c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2c93f5c7aab53cdd2ba446b891636f945e9c87508dd2b500193fba5eddf75e6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/pint"

    pkgshare.install "docs/examples"
  end

  test do
    (testpath/"test.yaml").write <<~YAML
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
    YAML

    cp pkgshare/"examples/simple.hcl", testpath/".pint.hcl"

    output = shell_output("#{bin}/pint -n lint #{testpath}/test.yaml 2>&1")
    assert_match "level=INFO msg=\"Loading configuration file\" path=.pint.hcl", output
    assert_match "level=INFO msg=\"Problems found\" Warning=6", output

    assert_match version.to_s, shell_output("#{bin}/pint version")
  end
end