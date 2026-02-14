class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghfast.top/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.99.2.tar.gz"
  sha256 "d0e3a9b4ac0b14b4e3c83a7e14e348786ca00959754811d8325a166f9c06a9be"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82b388905f24d885e8cf40ff308e655c86579d2514411838e70f57cacb7f2350"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82b388905f24d885e8cf40ff308e655c86579d2514411838e70f57cacb7f2350"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82b388905f24d885e8cf40ff308e655c86579d2514411838e70f57cacb7f2350"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9cb1fbab17b5da425e4fe9be27fd92bb1a95458cd0c978ce66f2c21341525ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a41de086accecdd2c2301a884056a44f34c230087c5412568ba107dce81594a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8737fd000cd0df576e10f147fa370acae7956d7f37cac7953f7354df1bc2daa"
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