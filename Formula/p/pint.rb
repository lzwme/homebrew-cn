class Pint < Formula
  desc "Prometheus rule lintervalidator"
  homepage "https:cloudflare.github.iopint"
  url "https:github.comcloudflarepintarchiverefstagsv0.74.2.tar.gz"
  sha256 "7cbb0209a6318799cff3a3f6356dc9a318a6b78f42d082b2041303989adec946"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9cdd6f6a73ef9021674a4817b9206438610ec3ca13b05afd738b2bce363c1d1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e8bec4b4f1906f4220a290a1f38dfaf62d4b77ad9e401347c58e78198c7edca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9e9a104cc3b2d3fbfbad0a0335912cec8396df4934ab58e4266f9de0aafd5add"
    sha256 cellar: :any_skip_relocation, sonoma:        "f13f24e0fb24b5515863da9f5f1462bc17749ce8e30f4e0137a1424382949f45"
    sha256 cellar: :any_skip_relocation, ventura:       "d285482c50cd146066891b73333ace2c0dba329d88892e3ee95d0533e85e48c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "403fa1d3f703ec4c6fa8dc1cdfeb786c1ec04e1cf13cb10239acd41a2fba92ec"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdpint"

    pkgshare.install "docsexamples"
  end

  test do
    (testpath"test.yaml").write <<~YAML
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

    cp pkgshare"examplessimple.hcl", testpath".pint.hcl"

    output = shell_output("#{bin}pint -n lint #{testpath}test.yaml 2>&1")
    assert_match "level=INFO msg=\"Loading configuration file\" path=.pint.hcl", output
    assert_match "level=INFO msg=\"Problems found\" Warning=6", output

    assert_match version.to_s, shell_output("#{bin}pint version")
  end
end