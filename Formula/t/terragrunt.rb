class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.68.5.tar.gz"
  sha256 "1fe21df080c62b143be26d19fafe3f4d7a116f93482d6789474687c221d01b6e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "526041a55f0d6fe7aeca889d019afa65571ee2db9e604385805912563505df12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "526041a55f0d6fe7aeca889d019afa65571ee2db9e604385805912563505df12"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "526041a55f0d6fe7aeca889d019afa65571ee2db9e604385805912563505df12"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ad5d37ebe9cbab0d146f823287c66c3c69ddbcf63b2e7a1f083529bce3af6ba"
    sha256 cellar: :any_skip_relocation, ventura:       "8ad5d37ebe9cbab0d146f823287c66c3c69ddbcf63b2e7a1f083529bce3af6ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0e3300da3ba9eb8859ba0e1327b08e0a1f6d1e6e1113e8b2961e876d661f84e"
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