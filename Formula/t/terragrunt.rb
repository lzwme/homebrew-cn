class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.77.9.tar.gz"
  sha256 "57cf98b4a2143cb87a96bf844ac12f6c79ae831dc77eb52b4d01eb2a3dc25774"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f79b256d357ac2234be8039ae5b434d95c707cc0c93d1f8e32b08d7930cfea45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f79b256d357ac2234be8039ae5b434d95c707cc0c93d1f8e32b08d7930cfea45"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f79b256d357ac2234be8039ae5b434d95c707cc0c93d1f8e32b08d7930cfea45"
    sha256 cellar: :any_skip_relocation, sonoma:        "e29f52de2171737f40d2b9b7a58f2368ef7115d1567d02ad55616ceff7ca9fc5"
    sha256 cellar: :any_skip_relocation, ventura:       "e29f52de2171737f40d2b9b7a58f2368ef7115d1567d02ad55616ceff7ca9fc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fd70be6314a2454d4d6e8e542678b7c663c6b858d5382929ef7f3f7e69a8d73"
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