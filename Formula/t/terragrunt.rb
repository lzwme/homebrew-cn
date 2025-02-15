class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.73.5.tar.gz"
  sha256 "0e27273f24f3e9096f733e9f64dba176a0c64e54cee69ca6056b5ecbff2a138d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5463a744c9c48d19f8df33f8049f42c028f6f9f9adaa2e393ab559de32340cc6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5463a744c9c48d19f8df33f8049f42c028f6f9f9adaa2e393ab559de32340cc6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5463a744c9c48d19f8df33f8049f42c028f6f9f9adaa2e393ab559de32340cc6"
    sha256 cellar: :any_skip_relocation, sonoma:        "1525555cfc0fc79f6e25a435a0b30af413177d225d6e620f69d1420bc71bcbb6"
    sha256 cellar: :any_skip_relocation, ventura:       "1525555cfc0fc79f6e25a435a0b30af413177d225d6e620f69d1420bc71bcbb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0006e395c9a833e837475671b45aa9f701991a0606f9a8f8a0115b3a4b74659a"
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