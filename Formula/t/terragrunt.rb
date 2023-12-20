class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.54.8.tar.gz"
  sha256 "12026ce5fc78197367301148ee8317e065b682638430443de47c35fda978e28b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "16d2ecb7fa7b787807ff1610f140c74bb48b2233008f152a49a5a445fcf55bd5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a7a97707a10280bfd6ecb3626f3e5eb4c15197b153e2d72c418dd86ceda4d2a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9908513d1ceeabce0b59d04fa2833ac6927cef7c54d0f17dfeeae32a1e7f535"
    sha256 cellar: :any_skip_relocation, sonoma:         "12ccaad5bba7f2fde0d7cd608f21859b0d8496e40574c65e2f799b5a6e838d1f"
    sha256 cellar: :any_skip_relocation, ventura:        "ddbcf40fb264f17cd98c72840171a8c5038d0ba9822d7622043dc6631afaa11f"
    sha256 cellar: :any_skip_relocation, monterey:       "4fcc6e134e3645270ff02999a860645d7bb054a8afdeff0f80a24b5070331e95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b0bec625a64720d07d538f72c07811a2a150e1434834eb08414bea1755b67b5"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.comgruntwork-iogo-commonsversion.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}terragrunt --version")
  end
end