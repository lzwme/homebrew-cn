class Pint < Formula
  desc "Prometheus rule lintervalidator"
  homepage "https:cloudflare.github.iopint"
  url "https:github.comcloudflarepintarchiverefstagsv0.74.1.tar.gz"
  sha256 "74af409dd2075416d6b365ff7f9fcb02ea6424341b627089acdb245f1ec8cc0a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aab53981c51bcd1e645f1d9a1c9e1069c40aa70fa61f778f4847564e2c73ad18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4b3c544c10a983a49b25b422f1c3752f2bd8fddbf6682ed99a1f75444bd0c51"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e7bd90efa0b78fe0ead9e364d6c6c8009b78aa68801708f87e8881d806f1680a"
    sha256 cellar: :any_skip_relocation, sonoma:        "26d1c09e49cdccc1cb50d7467969da431d95df2ff1ee00cbc13c00c38669f96d"
    sha256 cellar: :any_skip_relocation, ventura:       "03f3a5e126ef6f6ffba7a1182f417b755f0da79a4a0af9b27cbc21e4bbc97e5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d6e8f8680a07695de2966e2343fcb2eed5d4670aa58907da03beb812f3ba940"
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