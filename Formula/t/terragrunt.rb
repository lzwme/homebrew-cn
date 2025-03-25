class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.76.7.tar.gz"
  sha256 "fdd347facc9d4d7ac827d1fd4ed6a8977ef8efe137169a8cb85d240d02b39282"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4680ca9552341fec3580048850a14085cb0a89b93e58612d0097d95502ceeb4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4680ca9552341fec3580048850a14085cb0a89b93e58612d0097d95502ceeb4d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4680ca9552341fec3580048850a14085cb0a89b93e58612d0097d95502ceeb4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b06a18b55bf11293b308e1fb5cb6f4d0263ae6a767d23aeafe09eb5d9b02da1"
    sha256 cellar: :any_skip_relocation, ventura:       "9b06a18b55bf11293b308e1fb5cb6f4d0263ae6a767d23aeafe09eb5d9b02da1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8cd1e38616a80ceb27b9f2dcdca09e6e851b4a95071a2f5d87b62ea836302f1"
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