class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.73.14.tar.gz"
  sha256 "f863ed21f9679754f3b976292e2a3b65c563b264c8ba8644e115c0bb9612b2ae"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18e84a2624f0754bd4e2b3f88e08c98df47fb2e58d185e2def19bf7b59766b4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18e84a2624f0754bd4e2b3f88e08c98df47fb2e58d185e2def19bf7b59766b4b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "18e84a2624f0754bd4e2b3f88e08c98df47fb2e58d185e2def19bf7b59766b4b"
    sha256 cellar: :any_skip_relocation, sonoma:        "12c924d0cb3f4ab3077d9068991df540f48389d33066d42c1d3548d8f1cf1a78"
    sha256 cellar: :any_skip_relocation, ventura:       "12c924d0cb3f4ab3077d9068991df540f48389d33066d42c1d3548d8f1cf1a78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ed3eaea18b3f86d7f1c93fe46dc5f350d725dffcdbc27e13fca7ff050b9944b"
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