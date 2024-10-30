class Pint < Formula
  desc "Prometheus rule lintervalidator"
  homepage "https:cloudflare.github.iopint"
  url "https:github.comcloudflarepintarchiverefstagsv0.67.1.tar.gz"
  sha256 "13dfd2f05540a82ba5cdd344d9df237a318c055a9e25f29c25da316731a4cd54"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b300ad8f4d733b6ae871aee3ac104870ee69f2ae93370b93576b771f7e7a50dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b300ad8f4d733b6ae871aee3ac104870ee69f2ae93370b93576b771f7e7a50dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b300ad8f4d733b6ae871aee3ac104870ee69f2ae93370b93576b771f7e7a50dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "e045f1842878199b7aa60baf079b05ef6af1af31dad35d284a597727483c97ec"
    sha256 cellar: :any_skip_relocation, ventura:       "e045f1842878199b7aa60baf079b05ef6af1af31dad35d284a597727483c97ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e63c9d79079b3be8f0c673fd4a88a4c1f3c56bab364aa3a0c15459146ec0a19f"
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