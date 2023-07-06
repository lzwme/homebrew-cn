class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghproxy.com/https://github.com/gruntwork-io/terragrunt/archive/v0.48.1.tar.gz"
  sha256 "c151fde4f75536a4ba77b6db77893cd978cdfbf29adab4766d9216ceb2c4f0b8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "405fa9310b53db333045da33cc3048229c42975da7ff4025ee559167527203c5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "405fa9310b53db333045da33cc3048229c42975da7ff4025ee559167527203c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "405fa9310b53db333045da33cc3048229c42975da7ff4025ee559167527203c5"
    sha256 cellar: :any_skip_relocation, ventura:        "ea1d2ada0428d2b29c374a526c2e813c713f57fdc820398ed86a1659240b08da"
    sha256 cellar: :any_skip_relocation, monterey:       "ea1d2ada0428d2b29c374a526c2e813c713f57fdc820398ed86a1659240b08da"
    sha256 cellar: :any_skip_relocation, big_sur:        "ea1d2ada0428d2b29c374a526c2e813c713f57fdc820398ed86a1659240b08da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41d15d2beb3b37bcfdd3b2e1983f894f2286344d2a4b5b9b4b845177efc8d957"
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