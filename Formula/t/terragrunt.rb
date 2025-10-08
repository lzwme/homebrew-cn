class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghfast.top/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.89.2.tar.gz"
  sha256 "0f4ecea6b13bd892c8af0c3800bdd2f59c3f35fde24570ba4a679a9d6660cc63"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "53b4a7e08c3eb8c3f93f32b1c8877a469f56b5b30868ccb970e9df3e0399fd2d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53b4a7e08c3eb8c3f93f32b1c8877a469f56b5b30868ccb970e9df3e0399fd2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53b4a7e08c3eb8c3f93f32b1c8877a469f56b5b30868ccb970e9df3e0399fd2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed8ee8a70594cd985b97178891ebe53bf6b3e03fbea685447c005cc9166c522b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2b3247fa974877d934aadd584c98cba353a9392412fd6d009626fafcd6787d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c4ac54db82e1577ca1084b72767a8af2445b5150d594518bb32fefff7d0efd4"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terragrunt binary"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux? && Hardware::CPU.arm?

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