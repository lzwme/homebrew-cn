class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghfast.top/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.91.5.tar.gz"
  sha256 "b6d54b04141d0200e11e13bd4f0e6d617a2ecbfa1495758e1897b0f23e2f0470"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba8734eef90162fff3a56d7b3d076283c678dc56b69b6d7c4efe80c1946af2d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba8734eef90162fff3a56d7b3d076283c678dc56b69b6d7c4efe80c1946af2d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba8734eef90162fff3a56d7b3d076283c678dc56b69b6d7c4efe80c1946af2d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c6756b09d09c2bba2473e034172d8d05a84007f5fde8fbec227871d175c9a8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24c9e43fc796cf7dbe1ee48369df56aeaa2c3fcb3fbea723d251769bd6470b4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc6fa9f13eb224e92c1875cb79f054025a9c7e48892e14066e39831d7ec5234b"
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