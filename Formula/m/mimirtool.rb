class Mimirtool < Formula
  desc "CLI for interacting with Grafana Mimir"
  homepage "https://grafana.com/docs/mimir/latest/operators-guide/tools/mimirtool/"
  url "https://github.com/grafana/mimir.git",
        tag:      "mimir-2.10.3",
        revision: "eb097eae69b4a324cc67e083f9d99489e36d2ab9"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/mimir.git", branch: "main"

  livecheck do
    url :stable
    regex(/^mimir-(\d+\.\d+\.\d+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a0cfaf4c0115410c3913d188d31446224ecdbabd449a03a9796d7c1bcf2d4332"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2beae82f774dce52c7537d4933d14213d8ecf359d249bda6437ffc0f2665820"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3496d2c278229a1e90bd1f0d75d9c607a66e5f449d395f40e1e748988516710"
    sha256 cellar: :any_skip_relocation, sonoma:         "35e2cec480c81390e11a4f50e71261d95da6fde9612ecca9d864472294d01d6d"
    sha256 cellar: :any_skip_relocation, ventura:        "7d0dbec046185161b5b7a4579866975109c14771f9e56b329c45ba849c8a987d"
    sha256 cellar: :any_skip_relocation, monterey:       "cad2911904fbc7305176229e26a29e11cd219180df79486286ea0bebcf93dc23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87d276a96f87af71cbf3bba6ac710d0f5bc18d125ae26374eeefb6ec51297a25"
  end

  depends_on "go" => :build

  def install
    system "make", "BUILD_IN_CONTAINER=false", "GENERATE_FILES=false", "cmd/mimirtool/mimirtool"
    bin.install "cmd/mimirtool/mimirtool"
  end

  test do
    # Check that the version number was correctly embedded in the binary
    assert_match version.to_s, shell_output("#{bin}/mimirtool version")

    # Check that the binary runs as expected by testing the 'rules check' command
    test_rule = <<~EOF
      namespace: my_namespace
      groups:
        - name: example
          interval: 5m
          rules:
            - record: job_http_inprogress_requests_sum
              expr: sum by (job) (http_inprogress_requests)
    EOF

    (testpath/"rule.yaml").write(test_rule)

    output = shell_output("#{bin}/mimirtool rules check #{testpath / "rule.yaml"} 2>&1", 1)
    expected = "recording rule name does not match level:metric:operation format, must contain at least one colon"
    assert_match expected, output
  end
end