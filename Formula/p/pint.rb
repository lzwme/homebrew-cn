class Pint < Formula
  desc "Prometheus rule lintervalidator"
  homepage "https:cloudflare.github.iopint"
  url "https:github.comcloudflarepintarchiverefstagsv0.71.0.tar.gz"
  sha256 "f21fe9f3e671576c246ad393c3cd2a6862feb1ce0a41e7480395a02d7f92221f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73c0996ad323e6fb1efbcc3892ca7fb4e5fe9acfad2ddd0bb3bc0b400aa45c73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5257cbd16d9987a426dfb00740c1f68818d3348040216364ebef31878a24dd9b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1ce4b2657148fd3c8e4aef254dec4c7b97b14047409ad603b1a4640d44819aff"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b34ee236d043007a7215f8792a1ca3b032735bcc2b3d031ae5df1578cd7f0c4"
    sha256 cellar: :any_skip_relocation, ventura:       "80bff0734b913442cd73781e7f03559efeef75f0bace66a75f575a1b055f7a42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc6151800efcc081210ffa510308646e7aeed298fa862fc880e3e90e8db5a120"
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