class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghproxy.com/https://github.com/gruntwork-io/terragrunt/archive/v0.50.0.tar.gz"
  sha256 "5da28d41775fdedb326d769c11c3be9bab8a7cb38a5b9149f86b51bc04f326a4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb16b88b0df92d9a306fde86c0a1ddc97b52cfd64bd7abd2eb36eb41c9db2268"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dcc39a3a48391d2802d1da9fea132dc66603a09e9e33b6f9e5b8d758a463b678"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "342db30c0d466d156c688467be9a1140f63f0167c5c23e652c3d35374fb5f005"
    sha256 cellar: :any_skip_relocation, ventura:        "aaf6b0d5d7598a62e1380fb131a294961ec0cbd54e8d5aa4eb0012024fa67078"
    sha256 cellar: :any_skip_relocation, monterey:       "52b7f699a4255c2265e59edec52d41435ddebea0daad8f7c657ad86331cd49ca"
    sha256 cellar: :any_skip_relocation, big_sur:        "f505fa44c1a40e6147f49ccda88f55c056d42922122e14487b4ca8b4aa8b6eba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbcdc04bfa5dccf9593f63aaf5459fa1fa7df40536e0992c43c2f63aeaf41d0c"
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