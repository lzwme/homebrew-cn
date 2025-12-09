class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://ghfast.top/https://github.com/kyma-project/cli/archive/refs/tags/3.3.0.tar.gz"
  sha256 "10ba1e5fe4ad6b9f37ec2b7366f55fa8c7a54718584d9a98ad047926f45f2976"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released and they sometimes re-tag versions before that point, so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "90885b359fc1679109e8574f36a3eee1b39d4c17407e9c4348cce4f16096a988"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46b4902048332aaf8c6555a18b1ac50cad1946c3484c08d2bd834272f861bfa3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4fffbe9f964a40f75154846e399c73d518241d148db95cbe41ec45836a469093"
    sha256 cellar: :any_skip_relocation, sonoma:        "f7120f2f35988b58ea01b74e815eeaca6c8ecff7de8f4260374294646f5c5f8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d23ca5ad1fc63b812d9e38a0faf611f23a6aab9edc19a93da55c6960140588d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8102974bac2185561ca666f0a7cfcb4d8e6143dfc7e7db27d5dd057f04be9ee1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kyma-project/cli.v#{version.major}/internal/cmd/version.version=#{version}
    ]

    system "go", "build", *std_go_args(output: bin/"kyma", ldflags:)

    generate_completions_from_executable(bin/"kyma", "completion")
  end

  test do
    assert_match "Kyma-CLI Version: #{version}", shell_output("#{bin}/kyma version")

    output = shell_output("#{bin}/kyma alpha kubeconfig generate --token test-token --skip-extensions 2>&1", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end