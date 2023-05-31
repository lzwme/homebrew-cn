class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghproxy.com/https://github.com/gruntwork-io/terragrunt/archive/v0.45.17.tar.gz"
  sha256 "3fbe56e94a94216ce7b3e32f6a686f2cfcbfdf380bac5c97cde2b8f79de18f06"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1bc64134e042ea0c7d7e67113c86414e7bde1537a923aaa2157fb9c66841f857"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1bc64134e042ea0c7d7e67113c86414e7bde1537a923aaa2157fb9c66841f857"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1bc64134e042ea0c7d7e67113c86414e7bde1537a923aaa2157fb9c66841f857"
    sha256 cellar: :any_skip_relocation, ventura:        "a75aa70c8ddf3f33c0d949d64aee31f2e15b75f9172b1289d24817e15f0a17c2"
    sha256 cellar: :any_skip_relocation, monterey:       "a75aa70c8ddf3f33c0d949d64aee31f2e15b75f9172b1289d24817e15f0a17c2"
    sha256 cellar: :any_skip_relocation, big_sur:        "a75aa70c8ddf3f33c0d949d64aee31f2e15b75f9172b1289d24817e15f0a17c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6b0a1ba4df6993428a5abc180d5b178e21096baba8ed2bacc6639675a01dd5b"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end