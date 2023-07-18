class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghproxy.com/https://github.com/gruntwork-io/terragrunt/archive/v0.48.2.tar.gz"
  sha256 "003c361a5dddc2f164a16444b279fee7f78ada6525df6d0c76efd8a6a9ab948a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97be26d32999779bcd77390c244020c459015ed2d168343bb608e848349f108a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97be26d32999779bcd77390c244020c459015ed2d168343bb608e848349f108a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "97be26d32999779bcd77390c244020c459015ed2d168343bb608e848349f108a"
    sha256 cellar: :any_skip_relocation, ventura:        "f812b0fb4eb4d60f54dafe1e552589b966bf420e04b8d939a1d09f0d5fea8753"
    sha256 cellar: :any_skip_relocation, monterey:       "f812b0fb4eb4d60f54dafe1e552589b966bf420e04b8d939a1d09f0d5fea8753"
    sha256 cellar: :any_skip_relocation, big_sur:        "f812b0fb4eb4d60f54dafe1e552589b966bf420e04b8d939a1d09f0d5fea8753"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21194f8672604946ea1fd7f45164664e22f6c8b38b1794b4b2071808128c668e"
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