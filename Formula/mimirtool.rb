class Mimirtool < Formula
  desc "CLI for interacting with Grafana Mimir"
  homepage "https://grafana.com/docs/mimir/latest/operators-guide/tools/mimirtool/"
  url "https://github.com/grafana/mimir.git",
        tag:      "mimir-2.6.0",
        revision: "27698f399fc9e13c6fe0a8c79f882993814fda4a"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/mimir.git", branch: "main"

  livecheck do
    url :stable
    regex(/^mimir-(\d+\.\d+\.\d+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd4b80edb33a2bdc205b2726650707044e6b052fa64bfcde25e5c4e032aef5fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "848e162e24a5eca027861845a8f0b3a5cca3e41d3b849c2d61466c051e047237"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8468e69b70ddd150caabb2099655259554aefd675f1e88aca7c9fd31f09dc72b"
    sha256 cellar: :any_skip_relocation, ventura:        "47e11cce207ec57f33fcdc75968a7a174e8080710b4d443d279fff22bd031ab1"
    sha256 cellar: :any_skip_relocation, monterey:       "a99f4333edddd5b32cd1b24d0280269ff8156036f1da02ae08fd1b10a14308d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "98145919dd3339c314a0b3a55f67e94290b236610023f659d6fcc8f4efb24b8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e59a911de274f645a03391a179c975c888c27c19330b66a437ce204214dd02ad"
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