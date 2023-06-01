class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghproxy.com/https://github.com/gruntwork-io/terragrunt/archive/v0.45.18.tar.gz"
  sha256 "e00cf7d8ab160add9946bc04c271b2f0b041f66319f90c18dde9618c11a441b1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5570e6ebc289c1fb18926f00f9af2415911e20e716f8f9f5a619b21e9d3989c5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5570e6ebc289c1fb18926f00f9af2415911e20e716f8f9f5a619b21e9d3989c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5570e6ebc289c1fb18926f00f9af2415911e20e716f8f9f5a619b21e9d3989c5"
    sha256 cellar: :any_skip_relocation, ventura:        "f2feccd0436382257d74abce2238acca7df4d0c25cf5bc05734386145e6e8c65"
    sha256 cellar: :any_skip_relocation, monterey:       "f2feccd0436382257d74abce2238acca7df4d0c25cf5bc05734386145e6e8c65"
    sha256 cellar: :any_skip_relocation, big_sur:        "f2feccd0436382257d74abce2238acca7df4d0c25cf5bc05734386145e6e8c65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a143172f5c58337ff840f0a4446d8af15e095d01d720faa9c5a64571822b22ef"
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