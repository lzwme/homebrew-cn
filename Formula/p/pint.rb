class Pint < Formula
  desc "Prometheus rule lintervalidator"
  homepage "https:cloudflare.github.iopint"
  url "https:github.comcloudflarepintarchiverefstagsv0.65.3.tar.gz"
  sha256 "2db6642676589f99ddb96d2f321f1173747a110402113e32fe9b6ece9acae529"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c8953f130fb2526e1626608a1f2ceb8703028986b4128ae634123cf7e8f48fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c8953f130fb2526e1626608a1f2ceb8703028986b4128ae634123cf7e8f48fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3c8953f130fb2526e1626608a1f2ceb8703028986b4128ae634123cf7e8f48fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f83a0e232e8ae208dd7ee05c512a881916978ed2b935dc285c915124b463ee2"
    sha256 cellar: :any_skip_relocation, ventura:       "3f83a0e232e8ae208dd7ee05c512a881916978ed2b935dc285c915124b463ee2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c59d5904edc28fa3e301a8414fdf5481415aa8ea2b8c400d3fa4a0bfa8194ef"
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