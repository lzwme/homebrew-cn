class Pint < Formula
  desc "Prometheus rule lintervalidator"
  homepage "https:cloudflare.github.iopint"
  url "https:github.comcloudflarepintarchiverefstagsv0.72.0.tar.gz"
  sha256 "b31d1dda1c5197147f6638f904a416f49d74c5b2686c60e0c1114953c4856788"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3cc599f10c244bef4ae21559b568f5dfa7baf7df72caa5d94a2c95bc48122e51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5fd4c0f6a2bcdf6fd0c2045eaae1821a05573426d0d2c0498142baee5b01ab82"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a33479200dd5d8fb33d68d331885a7b388d5620b76ef4819849ac2585762a244"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad246e3e720bcd88f855b492cb17490194b80ecb98848b89cfd3d760edbbed27"
    sha256 cellar: :any_skip_relocation, ventura:       "0154e78e02c4b934853f96ca96083c34bf715586855c01e257a26d53c5f3b12f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8dc26e8f8d075716cb88f7f5f8fd263829c43339be6bb1fae834b62c647c434c"
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