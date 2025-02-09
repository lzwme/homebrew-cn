class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.72.9.tar.gz"
  sha256 "6ba1d7454c10d5166130ae4776f84c48822df0d5f68a135fde3e3b94cefefb2d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "feacb48fd325c42f8e857d6e98f6681fdb57a036edb8313dc8fa702a968d0dda"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "feacb48fd325c42f8e857d6e98f6681fdb57a036edb8313dc8fa702a968d0dda"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "feacb48fd325c42f8e857d6e98f6681fdb57a036edb8313dc8fa702a968d0dda"
    sha256 cellar: :any_skip_relocation, sonoma:        "a585d3b49b48e2bd840e682dd2661d33fee7d9036ef9a1b750f7bf8df1815f90"
    sha256 cellar: :any_skip_relocation, ventura:       "a585d3b49b48e2bd840e682dd2661d33fee7d9036ef9a1b750f7bf8df1815f90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a94f6e3f5177a15576b50e74724c7e559c194b8b932242dc8ba67cd77bd3d384"
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