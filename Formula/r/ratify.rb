class Ratify < Formula
  desc "Artifact Ratification Framework"
  homepage "https://ratify.dev"
  url "https://ghfast.top/https://github.com/notaryproject/ratify/archive/refs/tags/v1.4.4.tar.gz"
  sha256 "e5f2da2e9c43d575faf52e56dfc2d28d3ebb7e09f99e9b541c998b8fe7078f5c"
  license "Apache-2.0"
  head "https://github.com/notaryproject/ratify.git", branch: "main"

  # Upstream moves the tag until a release is finally made and marked as latest,
  # so we have to use the `GithubLatest` strategy to avoid picking up a pre-release.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "600a8fb4cf442e5b299f5c602b856f1e7b9dde6949cedc737eeab470d5970326"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "efcafab70b13423cc9f2e9ed590f48496b51782958e72b1fe866f6f3e8724a2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17cbc3480343af44511e4795f39b658c37da2c1779f6aa45942ad28f37ec35a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "f818cfce318d6eab9db5eef3b9d40f663173d6a55e078c35e47f8b9cacdcb59b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39ada5c96ade587d3e464328c7dec7b32270017a1c0d11bbd6ea29504522964f"
    sha256 cellar: :any,                 x86_64_linux:  "c8d24e1b883f36f3ca8096d6dc07a2b9b745e04e789380faf99c729730769dc4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/ratify-project/ratify/internal/version.GitTag=#{version}
      -X github.com/ratify-project/ratify/internal/version.GitCommitHash=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/ratify"

    generate_completions_from_executable(bin/"ratify", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ratify version")

    test_config = testpath/"ratify.json"
    test_config.write <<~JSON
      {
        "store": {
          "stores": [
            {
              "name": "example-artifact",
              "type": "oras",
              "settings": {}
            }
          ]
        },
        "policy": {
          "policies": []
        },
        "verifier": {
          "verifiers": []
        },
        "executor": {},
        "logger": {
          "level": "info"
        }
      }
    JSON

    example_subject = "example.com/artifact:latest"
    output = shell_output("#{bin}/ratify verify --config #{test_config} --subject #{example_subject} 2>&1", 1)
    assert_match "referrer store config should have at least one store", output
  end
end