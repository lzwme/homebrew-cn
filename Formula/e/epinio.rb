class Epinio < Formula
  desc "CLI for Epinio, the Application Development Engine for Kubernetes"
  homepage "https://epinio.io/"
  url "https://ghfast.top/https://github.com/epinio/epinio/archive/refs/tags/v1.13.3.tar.gz"
  sha256 "09e13c6fbae4cf1873a2b909f5022cfb409f6ef64e1e7a0adafbd12499355d5b"
  license "Apache-2.0"

  # Upstream creates a stable version tag ahead of release but a version isn't
  # considered released until they create the GitHub release.
  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "048ea47020ac4292f63f198ef27fe2ec7f477ea2dadd5017bca1597a4e72fb7e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c9f3475dfc485564bfa5a84d2b691933b0a08dda58aa33a572e156bc6926600"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4567489fafde2c3db7217ca3a065494a046ef3405d0e54b674ede73187087086"
    sha256 cellar: :any_skip_relocation, sonoma:        "9124df40d0dc9475e82ac29b9e430b31ac08df42064d669186550122de0c6e04"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7cacaa3af5b4002142820b101cd607286024337502e391b09bacd5aa781f883"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05254a4f384babc414115cf288250fc92531f03558f507503d3f9c1b1ec55f94"
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