class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://ghproxy.com/https://github.com/cloudflare/pint/archive/refs/tags/v0.40.1.tar.gz"
  sha256 "ce79f68b6b94cd48cca767ea85be3bd40d4129fb16e7c9fdcf84ab6880fa8f8c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "380cdd8e37e5e1d734ebeca3c2ea994022ab79387cd0b611f2f3b32008b574d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e86b27894ff25c8b4d1560547c97617a6d232bba8570c06bcc3deb7fbe1e3222"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5089f688bf20854f7554d91a46aeecfb47577b5480fcb2e9e5da5a4c39f46fe0"
    sha256 cellar: :any_skip_relocation, ventura:        "03740ad92061b9ca0737b8aee8e873e46fdc9356a3dd6a543de6a905f4d95650"
    sha256 cellar: :any_skip_relocation, monterey:       "48cd1fe8e679ea762c1153b51bd7ce15f43fffce86141742bdd31ff994b86c7b"
    sha256 cellar: :any_skip_relocation, big_sur:        "41214222b93225cff32cc5e0c26ee652eddfdc027de15e962ecc3bc273156a01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b30d929d96cede68998686bebaf4dc97f4cd363361564491f4e5c267e36fca4"
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
    assert_match "level=info msg=\"Loading configuration file\" path=.pint.hcl", output
    assert_match "level=info msg=\"Problems found\" Warning=3", output

    assert_match version.to_s, shell_output("#{bin}/pint version")
  end
end