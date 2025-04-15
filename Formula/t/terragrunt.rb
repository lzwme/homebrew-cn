class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.77.17.tar.gz"
  sha256 "729f4647d2221d1dcdf0dda79b1629e19636e8d71a81022df8272865226dd566"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e93b13b48ce92b2460f933599c1d162b080d7278affc5b18349f486edcca4103"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e93b13b48ce92b2460f933599c1d162b080d7278affc5b18349f486edcca4103"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e93b13b48ce92b2460f933599c1d162b080d7278affc5b18349f486edcca4103"
    sha256 cellar: :any_skip_relocation, sonoma:        "9539ee40b8d05d71986f68a4227fef2dea74456cfa52bca02dc9f69ce5d86c93"
    sha256 cellar: :any_skip_relocation, ventura:       "9539ee40b8d05d71986f68a4227fef2dea74456cfa52bca02dc9f69ce5d86c93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a16a864c034182709fdc52fc99fe2e41f9f3354f343fef7428f4b29fe8aa0eca"
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