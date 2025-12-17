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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51c64a93082af35d0bc720dee06a97281fd1c5d8fbf88360f166dedb38c7ec9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c7522f386bf4e61fd72d0c55dc16f221432172e059352e845881f2e49d70d88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "280350fb9fe9a95bd33cebcb5b38d3bdbdd51528d4ed2ebe99bbe5eff93b6f34"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2a71e48f80a7f38732b39a834b9c890cdb011c5342b6642294658b8bb3a2c77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27ee57bf2d021d7de759cebe4d1be8bb38b4002c9618ba900883e7530dfb653a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99bdfc02996dfe21a08fd47173ec089ee5f662487e2e75824c773564e901a78c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/epinio/epinio/internal/version.Version=v#{version}")

    generate_completions_from_executable(bin/"epinio", "completion")
  end

  test do
    output = shell_output("#{bin}/epinio version 2>&1")
    assert_match "Epinio Version: v#{version}", output

    output = shell_output("#{bin}/epinio settings show 2>&1")
    assert_match "Show Settings", output
  end
end