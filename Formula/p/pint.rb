class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://ghfast.top/https://github.com/cloudflare/pint/archive/refs/tags/v0.76.0.tar.gz"
  sha256 "d94e6449dcbf8b6352f9ca4f160504aa1b7eb2d1ab524e6e98babeb5d73df226"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8876cbaa5250711061dd2f46d3307d0de1b0cd5939c29be574847c15a79d1c64"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33f595092e33410919ff15d4acf784c882c425142889f56af652c5d9ab766dc2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "278b43a9500a00357ea2f492c9c79b624bfda5bea7b2cd104d807af32d21f597"
    sha256 cellar: :any_skip_relocation, sonoma:        "6fbb12467670b39c51625c9ed8b98635862ea7008831a5f9bceece369a8dfe5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f47ef0aa97f69223a7fbf2601240a0999f134d57f71958cb9cf90fe133d93547"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44ac04b2e5c6c5d9dcfedbfeda2bab7f3b82d828793d7c759d7f0f1a53c90a35"
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