class Epinio < Formula
  desc "CLI for Epinio, the Application Development Engine for Kubernetes"
  homepage "https://epinio.io/"
  url "https://ghfast.top/https://github.com/epinio/epinio/archive/refs/tags/v1.13.5.tar.gz"
  sha256 "e07a3f1ff3cc7174e396687aa0232915524aa455ef347e4eb3bef13e25d7fe09"
  license "Apache-2.0"

  # Upstream creates a stable version tag ahead of release but a version isn't
  # considered released until they create the GitHub release.
  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aafb6e9c34467c447905e37a61be05142e02f513cb108b366ef4bc0a40431225"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a78044e3477cd3842fee275558f83d410ada9136530be83bc587cb22ff3c1c34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84fe14e845b486bbdda9b4a29ddddd010249b70e26f9b09676a03995702d119a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3d4e99a067a43fed8939261831beeb3c9a24342a11deaaf3b0dea112c0ae485"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f15b31677e8fb4477c9bb18f3893262e1e1f9729e4ade013e4778c17db6526e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ce2e4e402c5cd159a3dc546ad6236f3a202ce66ca428a3371e23e8ccfc0dfe4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/epinio/epinio/internal/version.Version=v#{version}")

    generate_completions_from_executable(bin/"epinio", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/epinio version 2>&1")
    assert_match "Epinio Version: v#{version}", output

    output = shell_output("#{bin}/epinio settings show 2>&1")
    assert_match "Show Settings", output
  end
end