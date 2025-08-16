class Mimirtool < Formula
  desc "CLI for interacting with Grafana Mimir"
  homepage "https://grafana.com/docs/mimir/latest/operators-guide/tools/mimirtool/"
  url "https://github.com/grafana/mimir.git",
        tag:      "mimir-2.17.0",
        revision: "e150acbc8f6061b1995bff5105f786843c6a5277"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/mimir.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    regex(/^mimir[._-]v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37219e8d50cbff831cbb1b4c97f21dfff43c661d031504e559278b8e50c6f402"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08a154e0679266efc6489fa618a65461221e9a864d4761505e3ede54fd322a1f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6d8886f806322bf80db2f98665af9e2b2594db1f8602b159ebba7c60c9018d9c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ed26e5f42b1b45157246b09185dfba967e07a732126b0446313712d748bec05"
    sha256 cellar: :any_skip_relocation, ventura:       "c751ea1d9de7b0a23c44a2e1e28c8b3f183c25f7ebc11b9a1fb6c7d6655dbbcb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc13ee45da03358b998238c9e119acf02d6fbdb34fb57d54c9fca6148f1b13de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13bca41d815bc264391ec21606414860f2f996978171165b5fb00724e7581e5c"
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
    test_rule = <<~YAML
      namespace: my_namespace
      groups:
        - name: example
          interval: 5m
          rules:
            - record: job_http_inprogress_requests_sum
              expr: sum by (job) (http_inprogress_requests)
    YAML

    (testpath/"rule.yaml").write(test_rule)

    output = shell_output("#{bin}/mimirtool rules check #{testpath / "rule.yaml"} 2>&1", 1)
    expected = "recording rule name does not match level:metric:operation format, must contain at least one colon"
    assert_match expected, output
  end
end