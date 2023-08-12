class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghproxy.com/https://github.com/gruntwork-io/terragrunt/archive/v0.49.1.tar.gz"
  sha256 "e654a04d0aa1efab935da8a92848ced17123c250bf2902b16a38c16e2053389e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "073eeca68d995ed65dd01bc5035fedb0d5056f47d83c229d09a6bdf3bdceccc6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "073eeca68d995ed65dd01bc5035fedb0d5056f47d83c229d09a6bdf3bdceccc6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "073eeca68d995ed65dd01bc5035fedb0d5056f47d83c229d09a6bdf3bdceccc6"
    sha256 cellar: :any_skip_relocation, ventura:        "3350493a2e72c4ad0480e94286f5aedec436bc08ad26280ab4c311b38af85016"
    sha256 cellar: :any_skip_relocation, monterey:       "3350493a2e72c4ad0480e94286f5aedec436bc08ad26280ab4c311b38af85016"
    sha256 cellar: :any_skip_relocation, big_sur:        "3350493a2e72c4ad0480e94286f5aedec436bc08ad26280ab4c311b38af85016"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "016efefd192bdd20835c6b8211d4812d295a2253ea72753113518ae80debd00b"
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