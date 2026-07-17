class Mimirtool < Formula
  desc "CLI for interacting with Grafana Mimir"
  homepage "https://grafana.com/docs/mimir/latest/operators-guide/tools/mimirtool/"
  url "https://github.com/grafana/mimir.git",
        tag:      "mimir-3.1.3",
        revision: "e8126091843eef89200427008f51904efada71c6"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "620da1f5be2356b7a38618b142fed0b7669e2075c094f297ffbcf791e327b9db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c60a69c37376502929cd2d38806b7d402d444183f27888708bcb8c3a95a39758"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91de5095f829b36e4ddf6598419cc464059484a93889be911286d80689d00878"
    sha256 cellar: :any_skip_relocation, sonoma:        "38d47ab9b78ccc1e83aa13799e36bab0bf34b531b264746518322c43f0a1f309"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fb06b49bbb3be333c7b08b8886996636592312c529111b04a1ba8602adb0fd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35193b105958254828bb9e1672de3b86a7e8dab614fb2dc8791639f6283170d2"
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