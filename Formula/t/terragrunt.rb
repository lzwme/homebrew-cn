class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghproxy.com/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.52.7.tar.gz"
  sha256 "3da7c89c0602288d867bba51206f37e1486d105c3f4216b01ac06379a175ca7c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7142dbf7cdfcb2eda486ce2eefa41dfcfa367354dc2bface19c6990e637ef236"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d03ab3085bff59b938c0a606459210993ee12c31ffe8d13fdeacf6c1aad05f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c91352f9fd20dd027e19fdee5d965dcdbf50f3222e50672da216df8e0b67b85"
    sha256 cellar: :any_skip_relocation, sonoma:         "329af777cfed9dfdf79a57fc49fa728049bffbfc04c5d8adb23c371912f4c218"
    sha256 cellar: :any_skip_relocation, ventura:        "571540718ec38d7232be06abffecd6a500b7e0a90570ea5e68fe58093b74d8a2"
    sha256 cellar: :any_skip_relocation, monterey:       "2eeeabcf8e3ba8ee1d79fb048d40372cc01f6e8fb70d19d264cd02ccc0f40a7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d30350a6873c9b19736d0e6cb3f8c231a08ad8cfd1e51bd9e6240518257826e"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/gruntwork-io/go-commons/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end