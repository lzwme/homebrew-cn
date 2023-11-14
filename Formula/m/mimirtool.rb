class Mimirtool < Formula
  desc "CLI for interacting with Grafana Mimir"
  homepage "https://grafana.com/docs/mimir/latest/operators-guide/tools/mimirtool/"
  url "https://github.com/grafana/mimir.git",
        tag:      "mimir-2.10.4",
        revision: "d1f4f1291001db7384ba66ca90b4f753309f262d"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/mimir.git", branch: "main"

  livecheck do
    url :stable
    regex(/^mimir-(\d+\.\d+\.\d+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ac1339071c12c6ed2af6da1655f66a6a8f3a7cdb2ffc064dedc4705b1fa4a5f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a5d95c9935d2f8741f39120cd700a79c3a608771fe13a555ea133c96e0e7f68e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f36536312b73f5aa67e828ae6bd533b959e56b0c570fae6d7f8abce666ed1c2f"
    sha256 cellar: :any_skip_relocation, sonoma:         "9eec00074c172e9605d4a45cc6db50d7d07735b2884859f44586c71343818b2e"
    sha256 cellar: :any_skip_relocation, ventura:        "a2cdbb8eb2e158ce6f5b7b105fbab2d385c9120e1b1c9060aabd1762c50ff1f1"
    sha256 cellar: :any_skip_relocation, monterey:       "d25f7de2493d32e0a0ca41c89559760a22475c1d679c8804387af03edb4e3d3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ff0da87a35649ccab22d81aef3c1d05d7a77348a6831b7ef00c67dc138eefb1"
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