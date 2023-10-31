class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://ghproxy.com/https://github.com/cloudflare/pint/archive/refs/tags/v0.48.2.tar.gz"
  sha256 "88d1426e912f7f16bf51e92b8ad341a1eeeca88132a66bf16edd2291e511ad77"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3508ef243a062e2d5cf0cc516b443ccb157c0e818b138f94c36a4323bbbb8f46"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dededb48c389ea8614ea1391b568949d9a97be1a769311fed5195786aeeec95a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef054aa05a441f52d0d427aff956aa314e4a9018a6ab398051cd83a0e0c962c7"
    sha256 cellar: :any_skip_relocation, sonoma:         "dc75781b52ff01cf6153b6803324322fea9f0107e6d2c9d0ae013d1578acc8ec"
    sha256 cellar: :any_skip_relocation, ventura:        "2e515b2c00ff9bb0dc3272b51c0e1caafbdf7ad1abb1e1949546c7cfb8fe182e"
    sha256 cellar: :any_skip_relocation, monterey:       "44460385d7c3d80da0b3e5ced3e5566e4572401cfe984c2ed9926996ad655462"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31f9b3d45cd5cd1941439d05d044cf814b02639eae23ffb29cd8bca078cb3687"
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