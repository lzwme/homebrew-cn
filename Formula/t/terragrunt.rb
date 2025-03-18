class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.76.1.tar.gz"
  sha256 "24ccc722de773b1a8ea67f92e1752c33602c8d9174c7b26ff56302d503f7ef87"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd22c6302967d3b0355a1e70e4ae3e2a503cea873440bcf7295d25517725c04a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd22c6302967d3b0355a1e70e4ae3e2a503cea873440bcf7295d25517725c04a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dd22c6302967d3b0355a1e70e4ae3e2a503cea873440bcf7295d25517725c04a"
    sha256 cellar: :any_skip_relocation, sonoma:        "db6096e667a4bb1c9032103bbed032f96fcbeb5f6ef675cd064e78c3916a2fd5"
    sha256 cellar: :any_skip_relocation, ventura:       "db6096e667a4bb1c9032103bbed032f96fcbeb5f6ef675cd064e78c3916a2fd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e9f72a3857884612f2b2272db991e84149190872a096c2893d9fab1209955c5"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terragrunt binary"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.comgruntwork-iogo-commonsversion.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}terragrunt --version")
  end
end