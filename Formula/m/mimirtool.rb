class Mimirtool < Formula
  desc "CLI for interacting with Grafana Mimir"
  homepage "https:grafana.comdocsmimirlatestoperators-guidetoolsmimirtool"
  url "https:github.comgrafanamimir.git",
        tag:      "mimir-2.14.2",
        revision: "2db2c4d9de8565c52fcef3050b95b8a2808b407e"
  license "AGPL-3.0-only"
  head "https:github.comgrafanamimir.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    regex(^mimir[._-]v?(\d+(?:\.\d+)+)$i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3abd5840c227d7988dfc5db4e981acd6a707c7f5d50b69d616302ed7ea32edef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d78c51021842d6c9d0f38fca782b7fe488f267c00134b0c3450068a2a0007d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "76a7490e63b9c523f733b2d58845294162e7b010be31caacf7fe183a98492f8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "7109d9d397c08d3a878e72afd974695e87dace96902d647882afeca6f1c71021"
    sha256 cellar: :any_skip_relocation, ventura:       "9b72abe29d092897fa274a8721d0384019a0aa54b6ee3d948d285f2a722b3682"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02f4e83812fa70f6f78390e5a90b9385aabfe12fa37d118fbef270b7310061d7"
  end

  depends_on "go" => :build

  def install
    system "make", "BUILD_IN_CONTAINER=false", "GENERATE_FILES=false", "cmdmimirtoolmimirtool"
    bin.install "cmdmimirtoolmimirtool"
  end

  test do
    # Check that the version number was correctly embedded in the binary
    assert_match version.to_s, shell_output("#{bin}mimirtool version")

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

    (testpath"rule.yaml").write(test_rule)

    output = shell_output("#{bin}mimirtool rules check #{testpath  "rule.yaml"} 2>&1", 1)
    expected = "recording rule name does not match level:metric:operation format, must contain at least one colon"
    assert_match expected, output
  end
end