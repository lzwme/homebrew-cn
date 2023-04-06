class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghproxy.com/https://github.com/gruntwork-io/terragrunt/archive/v0.45.2.tar.gz"
  sha256 "a216317a7621013185c32bb4f68164ed32136e30242f64da61dcdbff845dfdc2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b1b1e308b67ff00d5579a9f7d77ffa442084ad4bf104da4d760c866f6f3dbfe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b1b1e308b67ff00d5579a9f7d77ffa442084ad4bf104da4d760c866f6f3dbfe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b1b1e308b67ff00d5579a9f7d77ffa442084ad4bf104da4d760c866f6f3dbfe"
    sha256 cellar: :any_skip_relocation, ventura:        "d8b3e7263eb178ffe5b9200d84b11f74fc80311f3aa807265697a7fdc7b6b8e2"
    sha256 cellar: :any_skip_relocation, monterey:       "d8b3e7263eb178ffe5b9200d84b11f74fc80311f3aa807265697a7fdc7b6b8e2"
    sha256 cellar: :any_skip_relocation, big_sur:        "d8b3e7263eb178ffe5b9200d84b11f74fc80311f3aa807265697a7fdc7b6b8e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3681cf9c79a880055a2c92c3a0c70175941ee81bad106d7c3954f93a0d89a80"
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