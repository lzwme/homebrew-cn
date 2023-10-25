class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghproxy.com/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.52.5.tar.gz"
  sha256 "34a39b31a787251c5f4e5e5ecf5678bd8f27c81f726a3d4fb2d19fb4e3f87cdd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "72dfa20a58bcb375e4409b10b6427b801c15832b6e57951478b7439105ff01fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd44c9228911f9a6cfc43e7597a96cc49b5ed868b24e6bad261b8851025e3523"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cba8bf516a2ac4e3a0bec13d8f551621a5aab7a4f8783eb908f133bc89034377"
    sha256 cellar: :any_skip_relocation, sonoma:         "b60f54c4eac95122bfd2b3ea0a21d896a2a051f12737a8351458ffd643ac17bf"
    sha256 cellar: :any_skip_relocation, ventura:        "fb971b15bff95f7ec48e199abb17cdd47b04685fba73ae08c2e05fa08337664c"
    sha256 cellar: :any_skip_relocation, monterey:       "1abd4bc6d289b55971afed1b8c58982b180fec9b8f8f87c32b3f0136b4c4c88f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3bdd944a624b49af09141e6d212c62156002547a25465d4e96019e1111da6ab4"
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