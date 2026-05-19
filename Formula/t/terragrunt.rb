class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghfast.top/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "75013ef30d3ec05343876d3cd9deccc5191334013007a0c8a9be29b3b94b1be8"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c5ba097a47d6edebeb579dc4283929198c7546b6edd701430edd8d03f105a46"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c5ba097a47d6edebeb579dc4283929198c7546b6edd701430edd8d03f105a46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c5ba097a47d6edebeb579dc4283929198c7546b6edd701430edd8d03f105a46"
    sha256 cellar: :any_skip_relocation, sonoma:        "b868e281be5ccdd31fbde1bdfed3246be3ee3e8de5cda6fcafbb3e8f43427994"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3bfab57667d5e1d41897e7d55b9d88c1b932a10a9abaecfcf3db86a473adf60f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef7ceb90947b616f9df3a3636cbe3e66f6228e1f3b4d95f0766afd8fec5ac183"
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