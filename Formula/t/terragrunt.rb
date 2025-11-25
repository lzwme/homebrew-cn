class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghfast.top/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.93.11.tar.gz"
  sha256 "6b3e93ea819724a3fc644a41d585eaa1c53f81e5049874641e52358391ffd87e"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "59ec56771b0fb809f93c6a9de9a6dfaeec06a3769cd96a7965284ad280ce3819"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59ec56771b0fb809f93c6a9de9a6dfaeec06a3769cd96a7965284ad280ce3819"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59ec56771b0fb809f93c6a9de9a6dfaeec06a3769cd96a7965284ad280ce3819"
    sha256 cellar: :any_skip_relocation, sonoma:        "f51311ffbd468d8dc411708ed45fc38511fd08fb95771e7f86dbb3a883e3479e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f92592015e7e497baf0954ca241a2786ba69ece20c9fcbcc930dacc9742da41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05b84b74c24015f6cdf26326582967526d368f93041a2a44f1051c632c0c020a"
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