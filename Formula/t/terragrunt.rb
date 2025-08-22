class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghfast.top/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.85.1.tar.gz"
  sha256 "19a3dba8207857a2f0474b0dc0a22de3dc87586dd65a486359bbfb4d606a5a69"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a443550f669a86c6437015323c0561f43379a0eb2d22b7e8afb0376db47ce2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a443550f669a86c6437015323c0561f43379a0eb2d22b7e8afb0376db47ce2b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0a443550f669a86c6437015323c0561f43379a0eb2d22b7e8afb0376db47ce2b"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a19579cb540ff0391c6f87ff9c837f5de61b5fcea74cb6cd64687360c4332e8"
    sha256 cellar: :any_skip_relocation, ventura:       "1a19579cb540ff0391c6f87ff9c837f5de61b5fcea74cb6cd64687360c4332e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e7b8bc8b4ba9c1f6148583485bcb5c52659f1a89c453be7b4704b7cdc14e698"
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