class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghproxy.com/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.51.5.tar.gz"
  sha256 "49e9f893eab64d9a025f7dd23858b040210b15c0e2486a660db225c1a6d954f5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6d0cca4e4e499826457afee3c1cc0d6ce30c2d0df13b90b8038b0571c36dbaa5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97c71e351f6882d96bedcc2b1c3806994ad0051a68ab1dd0afce4626e89a7235"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4778a845bd1086bdd5d290f898c1eb5a90bcba8454e3d84f0ac5b28ba80d7dff"
    sha256 cellar: :any_skip_relocation, sonoma:         "57228ceff1010c9f175eb6be793c14c084b88fd4c7b91b63c434c0172b87b472"
    sha256 cellar: :any_skip_relocation, ventura:        "e5351a70dc11ec9da6a23eb323ac079fb391a662e2e7605e323d1792b7932341"
    sha256 cellar: :any_skip_relocation, monterey:       "155409393f8a23f84398f2c47936596b5a99f4f6e7b176340a6ab98ad57adfef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "491cbf7bfc7ef8878b361e5c741ff57403a085c05ac25ce985aa9c9cf918d668"
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