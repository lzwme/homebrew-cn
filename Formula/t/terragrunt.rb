class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghproxy.com/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.50.13.tar.gz"
  sha256 "be001fa5a8d99122ce97944d52e92e712d23958c81f57bd0860d5ff674014e6e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be003242129aa06f7a7539cc1938531296b46e496666fbd11df0c9a13766f2ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ac7060343c3da101e40974c76e93e8a9e7cfdb81518cc11c83777fabc42c95f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df929bd5d1e3f803b0c5a1b820d595db2261bc7da701c5c863defdcdac020214"
    sha256 cellar: :any_skip_relocation, ventura:        "a7524e7a757c4127ffa60c9908b87da4caee56fe07bf35f5020d693e7ec0cbd1"
    sha256 cellar: :any_skip_relocation, monterey:       "b6b64b9ac46fe02de1c91870bdd3bd0ad0b6d81543c4cc842b083af5045b03c1"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee26ce95d32ef05a98e71dc75c3e3a41600929ab175d53bf3205621ac16867b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "105fce9f66788742229aade9bfffe68685d0279bae45a5a18a8b95abc8dbdeee"
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