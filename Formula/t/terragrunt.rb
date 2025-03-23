class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.76.6.tar.gz"
  sha256 "4eeef64aaff048d1a2c86ce1b0635f67204363ffbe565b6c62087cf0cececb0f"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3276b00da00ea1df4cf2ed574f46cca1bf5b75621bda8949b74629bda3c915f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3276b00da00ea1df4cf2ed574f46cca1bf5b75621bda8949b74629bda3c915f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3276b00da00ea1df4cf2ed574f46cca1bf5b75621bda8949b74629bda3c915f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "64c864beb4b72c92aede0947a0eb6784b954095aec8928e14248ed1176bea9b4"
    sha256 cellar: :any_skip_relocation, ventura:       "64c864beb4b72c92aede0947a0eb6784b954095aec8928e14248ed1176bea9b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "538698ef8ab4556d392863a1a891b94000d2b5c5addde92cf08a2dda5a939af4"
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