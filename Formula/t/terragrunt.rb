class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghfast.top/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "09c2bf530264a6fac3933e84ed39bcf4a10d3a3bba03eaea0a0654c64320dbdd"
  license "MIT"
  head "https://github.com/gruntwork-io/terragrunt.git", branch: "main"
  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3349ab5264bda0e8d9c16a69e591bf748eff3f839b9a8f57473b54ae3dbed40b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e785cefd1e96dbe49f1203a3d0466f156ef5af9f5d21067e3d9392526765e1e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e785cefd1e96dbe49f1203a3d0466f156ef5af9f5d21067e3d9392526765e1e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "e785cefd1e96dbe49f1203a3d0466f156ef5af9f5d21067e3d9392526765e1e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c54b4483a4ba626523621638fad0c2f51cc756b98f5977d58c70afb25d2cc1f0"
    sha256 cellar: :any,                 x86_64_linux:      "fe933a3d88c4b815ac7fcf9e221bd21d1a646dd02b17bebd4f693c4592c239e3"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terragrunt binary"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[-X github.com/gruntwork-io/terragrunt/internal/version.Version=#{version}]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end