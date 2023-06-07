class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghproxy.com/https://github.com/gruntwork-io/terragrunt/archive/v0.46.2.tar.gz"
  sha256 "0d8bb4e98276e68c76d770e662bb434fb5c89f8fc06c3c00e14e717417123ec5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0ee8ac689c823f9a737cbfa7fd6a234946491eca01042393822a2b991bdf773"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0ee8ac689c823f9a737cbfa7fd6a234946491eca01042393822a2b991bdf773"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e0ee8ac689c823f9a737cbfa7fd6a234946491eca01042393822a2b991bdf773"
    sha256 cellar: :any_skip_relocation, ventura:        "0d359826199ad8014c48d00864d7403814d56462a322bd1bc6e42e88fdb95888"
    sha256 cellar: :any_skip_relocation, monterey:       "0d359826199ad8014c48d00864d7403814d56462a322bd1bc6e42e88fdb95888"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d359826199ad8014c48d00864d7403814d56462a322bd1bc6e42e88fdb95888"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d255de1bac98a2732379c63ead2a4c2370ebe827c4b8d6d38eb43471cf28980"
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