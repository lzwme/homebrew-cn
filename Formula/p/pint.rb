class Pint < Formula
  desc "Prometheus rule lintervalidator"
  homepage "https:cloudflare.github.iopint"
  url "https:github.comcloudflarepintarchiverefstagsv0.58.0.tar.gz"
  sha256 "56f9731d4e18fb16a2b1f0ba4f4bb2e0e40748fbb965c8e1dda3a90aa7c4a5b4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f85368b8a65996d0372fe8c53695bdadceba5d83686a62406f8fdba4331fde47"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c13cf261e25c8c3d7c4e4e3955f25734cd6591ccb05410b93776656f690ad525"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "afb9842c5313ee7fe364f33858b557723bd1282995ad864a14321fd690c9f290"
    sha256 cellar: :any_skip_relocation, sonoma:         "0982c3f4ee98e1576419e30f1606079a130bb5732d922f0b700ba6bfd508bda3"
    sha256 cellar: :any_skip_relocation, ventura:        "b2e61fcfb838c6679905e37a3a83536183db6c145e903ee7546fb3566595de12"
    sha256 cellar: :any_skip_relocation, monterey:       "58b5cab1e19e5cf3b5710508c9ddbbad25fbb6e2dc51e818682480549250794f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4481b33b1dce948280ec454507d088725461df77df6328dd98c3bd9748f95b41"
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
    (testpath"test.yaml").write <<~EOS
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

    cp pkgshare"examplessimple.hcl", testpath".pint.hcl"

    output = shell_output("#{bin}pint -n lint #{testpath}test.yaml 2>&1")
    assert_match "level=INFO msg=\"Loading configuration file\" path=.pint.hcl", output
    assert_match "level=INFO msg=\"Problems found\" Warning=6", output

    assert_match version.to_s, shell_output("#{bin}pint version")
  end
end