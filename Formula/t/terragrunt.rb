class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghfast.top/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.83.0.tar.gz"
  sha256 "9c17272281d330c5a1becc18890733111febb5481342381aad121e2e816a963f"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5eb381dccb47656da507f52bd1f9185fb15a3db21e017308383297e0739e0241"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5eb381dccb47656da507f52bd1f9185fb15a3db21e017308383297e0739e0241"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5eb381dccb47656da507f52bd1f9185fb15a3db21e017308383297e0739e0241"
    sha256 cellar: :any_skip_relocation, sonoma:        "7bf61980e9def595bb847aba9fdc8a1d2f328892137570ecacf652213a1c2116"
    sha256 cellar: :any_skip_relocation, ventura:       "7bf61980e9def595bb847aba9fdc8a1d2f328892137570ecacf652213a1c2116"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "546afe2f45a3575a156d527268645b39afc5c5aa36767d310fda20fac87c70be"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terragrunt binary"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/gruntwork-io/go-commons/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end