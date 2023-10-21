class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghproxy.com/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.52.4.tar.gz"
  sha256 "974a1c0f42af567fecde08957ba66a9cc97318ab47453fcb58cbe6a0df12555e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c0aba02624cdd252ac6408f9b4758f16fd1f824212dfce958409ff02e383dd32"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0eaedce91f9e661944c39720e1219927828e554fd96ee03995efb2754fcc12b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a7efa6b408df0f154107f0ee51861bf16a5317b79ef396e7785a5cabcf6f555"
    sha256 cellar: :any_skip_relocation, sonoma:         "eb8963e07a6f775926bf23f6998a6c322dff5047bc8c23a4e683fde8d139c501"
    sha256 cellar: :any_skip_relocation, ventura:        "07a5a79b39f714cf33b4f924a6f15869712baf8bf359709cfe31cd13d09f4c15"
    sha256 cellar: :any_skip_relocation, monterey:       "0f1df0e888abd9bc2a639ceaea07df5cdd45df6b7c17e93839c6a917456216e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5bb22640aa5438917b2490eaf03b7f17cb63d2ff233857b3d57bf312d0cdfdc"
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