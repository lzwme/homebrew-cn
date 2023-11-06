class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghproxy.com/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.53.2.tar.gz"
  sha256 "44f2f71b1e0aeb2c6feb113c097e45c6a9e2d55318e994ec8817195e709f7019"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dcae5e697fd8ff7ec61e6eaa3d72d83e7c7d6c1363779e38fa18b7e7fea7084e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f298e3635a15a4e5f9b7307895b5d6558ec00cd9dc38732aa6a330a70d337ef5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a0baeccfab24ccd3542350591f74d26e0fb6e298a563327dd4e33a70a9c94c59"
    sha256 cellar: :any_skip_relocation, sonoma:         "692faf84242220fe9a62f4d71bc1d66d9b1caf48e8ffa71adde07ceda1808460"
    sha256 cellar: :any_skip_relocation, ventura:        "03b0029778dac4db6c0cbd1c54e73fbd021ada7652d407f2e3354a31b41621a3"
    sha256 cellar: :any_skip_relocation, monterey:       "fd69497b3b38d22697da6b57fca6ffc29fabae525b7ea9e08b615a99531fd02c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e292df949d7a8f79716207a8c15e48e3ce1aa3b7e0e1d69a4c9287d2c67f66f4"
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