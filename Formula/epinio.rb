class Epinio < Formula
  desc "CLI for Epinio, the Application Development Engine for Kubernetes"
  homepage "https://epinio.io/"
  url "https://ghproxy.com/https://github.com/epinio/epinio/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "3be1880e28274496421dcc63bb42fe61b654dd85b002d035fc435fec4b5a9a5f"
  license "Apache-2.0"

  # Upstream creates a stable version tag ahead of release but a version isn't
  # considered released until they create the GitHub release.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d7a4081a329bf08a2c1e5476a8017dbcaae333ce408c2408a4989b4398bda58"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97c7f67e743f2eeee37752e4fe6aa32ef4cf80a3c5145e94377a1086f4c42d92"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "93f6f737475e80a31bc83c6e23291f3a07477ba3d101d76c4bac2b0cc4957330"
    sha256 cellar: :any_skip_relocation, ventura:        "c78c64a8caf75bd16806ff735b7361cdf8224c3d95c790102a0b15f2416dfc0c"
    sha256 cellar: :any_skip_relocation, monterey:       "a60e1c1f4a5384386e9755da9f18603c7577d0f404d58d9ddc12b735128260d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "5fd561c3d0983b95313f8862a20e63befbbc60a37c6ef3b20c723d31afa4ee20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efbc1c29db52a6c8db9bbe021a463ea9bfd6020b40f602cefa67596610330cb0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/epinio/epinio/internal/version.Version=v#{version}")

    generate_completions_from_executable(bin/"epinio", "completion")
  end

  test do
    output = shell_output("#{bin}/epinio version 2>&1")
    assert_match "Epinio Version: v#{version}", output

    output = shell_output("#{bin}/epinio settings update-ca 2>&1")
    assert_match "failed to get kube config", output
    assert_match "no configuration has been provided", output
  end
end