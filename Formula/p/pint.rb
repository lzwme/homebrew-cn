class Pint < Formula
  desc "Prometheus rule lintervalidator"
  homepage "https:cloudflare.github.iopint"
  url "https:github.comcloudflarepintarchiverefstagsv0.71.2.tar.gz"
  sha256 "8e7c268ef6211b646b0b3dfb5dd9049eaf0edd8c6a81da41cf548025d29a04fd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90518e08fffa8d5a5f52f6279aba9f3d9872740ba62e5db2b89e6c0ec59a275a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8d050963199b2f9bc0ee1d16878ca9e74044d4161935198118c2f247bbf58b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7dd03758e3207de1ced1914d2276a0564eb87920155342ad9a89811b04516e37"
    sha256 cellar: :any_skip_relocation, sonoma:        "33dd2b8fa3350be2982aaecc1801684a78454372e80b0874c3a52b142bd7ce2b"
    sha256 cellar: :any_skip_relocation, ventura:       "a16f014c9149c23bf63b772af9668e549f3980d4d138ab6632ba6304d9cfbc71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54f6a39d6595b2e38a6c6e8ef5d46b471ac7284995b4d82d12784ddb19ebd593"
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