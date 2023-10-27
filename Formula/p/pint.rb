class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://ghproxy.com/https://github.com/cloudflare/pint/archive/refs/tags/v0.48.0.tar.gz"
  sha256 "b9e0555955bd855b4fc43193003abceb06fa437d0c9cf726c788fd24370c2ec0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9fe1a1233aee145ba6ab53300336b0f7571ec5290157bd5d48e92199ee2ee312"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc0415f64362ae109a5880f6b55c0957f01448628724617a4fe7bc1f9e149293"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7630ae84f6b8c0a9fcd7ea358fc2287c2e92b485d58bdae2e3a697ad17c7f564"
    sha256 cellar: :any_skip_relocation, sonoma:         "e1d6e1a200ea053c77575c322c3e45a6ec26193b6adede2d65e1c48ad7888e2b"
    sha256 cellar: :any_skip_relocation, ventura:        "cf55f100926611710757efe69464c062857d4d67f2f1839cd771afa8df811be1"
    sha256 cellar: :any_skip_relocation, monterey:       "fe3f1229b4482b704394dd1745d592491a6d7b51a6d27102987e72df7a5fec33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0f936ebd043dad166db45e564131c57f579aee659e306fdcd51257913d9ae78"
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
    assert_match "level=INFO msg=\"Problems found\" Warning=3", output

    assert_match version.to_s, shell_output("#{bin}/pint version")
  end
end