class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://ghfast.top/https://github.com/cloudflare/pint/archive/refs/tags/v0.84.0.tar.gz"
  sha256 "3b7f9d8819bf1ceb62b17b5d41482918b9316320345e6e747fb546fbc1e227b5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45a5d68e30284b0afecd8fc9753a0e58ded99d52041d4109742ab72eb905b6ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d687ad25a61cb1372a8db751f547df08727436591d92650f23d6822f1784707d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab0a67387f77a9ce0a88c40e4674f401e08eef6044342daf011cbce5bee21926"
    sha256 cellar: :any_skip_relocation, sonoma:        "5791b68bc2d25dca8c534c6b5629dacb6f4fa2a33affbddba8b2f225a3dfac2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54f6de7fa51c21391da476141c2d4a140aade6531d0b9472f71d36d0e8764e2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03a90449d640183dc1149667660bc1544bce712500d624e004a9279d7b6da98e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/pint"

    pkgshare.install "docs/examples"
  end

  test do
    (testpath/"test.yaml").write <<~YAML
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

    cp pkgshare/"examples/simple.hcl", testpath/".pint.hcl"

    output = shell_output("#{bin}/pint -n lint #{testpath}/test.yaml 2>&1")
    assert_match "level=INFO msg=\"Loading configuration file\" path=.pint.hcl", output
    assert_match "level=INFO msg=\"Problems found\" Warning=6", output

    assert_match version.to_s, shell_output("#{bin}/pint version")
  end
end