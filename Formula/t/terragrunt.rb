class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghproxy.com/https://github.com/gruntwork-io/terragrunt/archive/v0.50.10.tar.gz"
  sha256 "13cef34192f538a05436ec4faefc526c223624a984b642a14f4f9c5a9b1d1bc7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e959da3932727bd01c3f616f158c9d5ac24adace49df34c62429f8635046c5c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97252e48ce2e77b6a9109e27c020816ec3228610d2244020c725ed0f2b339a7a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "82e9868037f713207a7d9d5930ca142f6ab922d6d43abb18fbe32b8c17ede4de"
    sha256 cellar: :any_skip_relocation, ventura:        "333db53b377b31356f7a695837a71a359a9ea05659a8aad9bd9cada867e10ba8"
    sha256 cellar: :any_skip_relocation, monterey:       "9d08b0232437eb80190a18cbc57bdd3b8d8f97c2c5229839066ae657b6de5fda"
    sha256 cellar: :any_skip_relocation, big_sur:        "7f108df155153229eb2c39cd43d9f2b525661606db370a8f1432a18388c7d92c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a8832dd112ef2c1c6e3fae9f39535467e912b7f994f23f4a7f9895bdbce8ff1"
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