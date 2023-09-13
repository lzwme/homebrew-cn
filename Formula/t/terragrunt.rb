class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghproxy.com/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.50.15.tar.gz"
  sha256 "7e07b97a5e1875d06b7b54c67e35df7705a06f7ed72e6a0334037e6cb5237d89"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b743a87ea9529a6ec5f66fe87f171e4e3ba5ab89b36f7c86bdb526fcc267b4c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ea369e68fb6c060f49df3f6b5b4dccd3443dd25f093db53e65e998719096deb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe1e13138a6ae55baf7c26fbf04c747c02fe2f0efc9d97b21c4d830b9ac9023a"
    sha256 cellar: :any_skip_relocation, ventura:        "3b9897f68cc96f5801b63dce34d46e9f39b220e736be860c16c6012631f621b7"
    sha256 cellar: :any_skip_relocation, monterey:       "d9169654161bfa1cace668c5d56d76e3847027ab6c4730c5d83d623040779d59"
    sha256 cellar: :any_skip_relocation, big_sur:        "80f914176919011aa3c6f3bd2a8902cc080847b593bc7b77f78354f92f302be1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32ecb4aa90d4aef6986d69bc807b2662977b4285c8d267b6b1ffbf06e1237246"
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