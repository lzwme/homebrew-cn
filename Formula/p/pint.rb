class Pint < Formula
  desc "Prometheus rule lintervalidator"
  homepage "https:cloudflare.github.iopint"
  url "https:github.comcloudflarepintarchiverefstagsv0.69.1.tar.gz"
  sha256 "8f8c67a86b81dc0518dcb65ee53aa698d101801c587800a52daf3dab515d3791"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5eb3ee6a681e77ff021fe0b18d56acc52fe2fe34b9cdb325e3a2aab78ff7f81a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5eb3ee6a681e77ff021fe0b18d56acc52fe2fe34b9cdb325e3a2aab78ff7f81a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5eb3ee6a681e77ff021fe0b18d56acc52fe2fe34b9cdb325e3a2aab78ff7f81a"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc496ab6a5bfb537bc4c3f424198b5112f74eea869c42484006a3a184f3bd3f0"
    sha256 cellar: :any_skip_relocation, ventura:       "fc496ab6a5bfb537bc4c3f424198b5112f74eea869c42484006a3a184f3bd3f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfbacaa44373e1533cbd43106e9d876c27ca46eb0bdb3ea7a28061bda4fca1e3"
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