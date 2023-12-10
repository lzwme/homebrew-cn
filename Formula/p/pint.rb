class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://ghproxy.com/https://github.com/cloudflare/pint/archive/refs/tags/v0.51.0.tar.gz"
  sha256 "e9bd6ab0c873b07c589e163b20368076e078d02203253da032ebfe2555e4103c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4e9cefa6062d4b7cb856f61a5614b192847582a66f9b4afcfb68f425703bb651"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e33dbc71669e27b93d67c2f8e04ec9156282ae59fe0284e970de2fd24b33c1a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a141fc8d9d42f8dd3e37028fb85c945f92560678cf2c76febbd902dbb51d93f1"
    sha256 cellar: :any_skip_relocation, sonoma:         "821b1db55a707c1e7bbe55d39e36e41c27816b332d7b83529ea5622d6aff5a67"
    sha256 cellar: :any_skip_relocation, ventura:        "f6d2705096384405ab3b34e1eeb0979250b90ecd41e8a3f938b459b2f0321d99"
    sha256 cellar: :any_skip_relocation, monterey:       "978374e4c3758346af3c46f66e70327351e86a92f44e5ba9da8e226197cbbdce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55c1fe45169b1eca6c28b6c7c76e9a31876dc450945ff968e1372031b6600025"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/pint"

    pkgshare.install "docs/examples"
  end

  test do
    (testpath/"test.yaml").write <<~EOS
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

    cp pkgshare/"examples/simple.hcl", testpath/".pint.hcl"

    output = shell_output("#{bin}/pint -n lint #{testpath}/test.yaml 2>&1")
    assert_match "level=INFO msg=\"Loading configuration file\" path=.pint.hcl", output
    assert_match "level=INFO msg=\"Problems found\" Warning=4", output

    assert_match version.to_s, shell_output("#{bin}/pint version")
  end
end