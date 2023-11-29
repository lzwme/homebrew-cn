class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghproxy.com/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.53.8.tar.gz"
  sha256 "95f8cc80ec1885c7026a8fc911efe095f018ef4bbf712603ef85e0e9bc6a9e16"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "68952ddefea2e206fcf1e2c2766580703786f08419b352aa065462e2dd3a502b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d6cf183794fb2433cf7b6267cd23aa9c43e5010a64310af79971e9c31d19688f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e910cf86d58c041ed7bd21339f15ecb776d4fa5b1a9761e6a4020874615bf50"
    sha256 cellar: :any_skip_relocation, sonoma:         "505a0cb0224a99e513f6f831300977ff2e05953c55464daa135005189a23c30a"
    sha256 cellar: :any_skip_relocation, ventura:        "d19a600fe36b19672688966ddcac30bcc072abe7b991388089779d4ef9929dfa"
    sha256 cellar: :any_skip_relocation, monterey:       "86379309c7a6ef817b3c2f4c87dea77077207aa6c7ff1cc8323742e5277ed8de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d24b7ca41c3cd052493b3612c5fa3c33341e14f94f1713e32dffa7422d7d1754"
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