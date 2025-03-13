class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https:developer.nvidia.combrev"
  url "https:github.combrevdevbrev-cliarchiverefstagsv0.6.306.tar.gz"
  sha256 "a0eb3d8ce8aeb0e2bce61832cdbf88e573e7b2972883b651de9e27a63bf59bd7"
  license "MIT"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "409d6dce521b0f14bacae9f1f831836307a3e33992d60d912cc45b1978e39f26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "409d6dce521b0f14bacae9f1f831836307a3e33992d60d912cc45b1978e39f26"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "409d6dce521b0f14bacae9f1f831836307a3e33992d60d912cc45b1978e39f26"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8fbd999dabb1e07a412e37ab2bd6d9ca7b9736ab2858e89ff90bb01d5670b8b"
    sha256 cellar: :any_skip_relocation, ventura:       "c8fbd999dabb1e07a412e37ab2bd6d9ca7b9736ab2858e89ff90bb01d5670b8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "855accc82f4906e5fd426d3239b17aadb28ce06a785d11c4f1f2a5a1a1ddf498"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.combrevdevbrev-clipkgcmdversion.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"brev", "completion")
  end

  test do
    system bin"brev", "healthcheck"
  end
end