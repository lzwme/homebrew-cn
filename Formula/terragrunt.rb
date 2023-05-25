class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghproxy.com/https://github.com/gruntwork-io/terragrunt/archive/v0.45.16.tar.gz"
  sha256 "11c2fadf60545ec495a031ddc72e985af83aa5171f952ef0da451f37f5160435"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "efa333d5a9ac53ebd113282a4102258ee7da43f5246aa3dcbd90af6f78a9bbf7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "efa333d5a9ac53ebd113282a4102258ee7da43f5246aa3dcbd90af6f78a9bbf7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "efa333d5a9ac53ebd113282a4102258ee7da43f5246aa3dcbd90af6f78a9bbf7"
    sha256 cellar: :any_skip_relocation, ventura:        "504c49a276e6e661146660e046ebe88c654e7ae740c7755ce85a79df3a45579a"
    sha256 cellar: :any_skip_relocation, monterey:       "504c49a276e6e661146660e046ebe88c654e7ae740c7755ce85a79df3a45579a"
    sha256 cellar: :any_skip_relocation, big_sur:        "504c49a276e6e661146660e046ebe88c654e7ae740c7755ce85a79df3a45579a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a943b1f36a53488a6a2adcc75b14f1de13caf2d8f54a969b88e73d668125f2e"
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