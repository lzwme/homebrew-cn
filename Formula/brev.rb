class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://ghproxy.com/https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.227.tar.gz"
  sha256 "ee2349cc0d880b8e7e7b57340da6b5f876aab972eecc783fe8a9a5d211c110af"
  license "MIT"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08b42e0c0cbb9b55b8442287aa927854ba6bdcdc8b31b188d19b163e21a9cc62"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53a247e94c007b4456f8e5cc2eea07719abc1634f07dc05a0e87173ea0851eff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "25b4f782663cd3513c5e01ef56b4917ed2ce754258616a1b214c2f8c4e5a731b"
    sha256 cellar: :any_skip_relocation, ventura:        "b1ebc3c33558b0c3879c8a69cfdca5c9945e01bff2bdfc91f6afb63aa286ef37"
    sha256 cellar: :any_skip_relocation, monterey:       "eb33ce643c98b1142268f0d8f0598f722923b41f08a21c4dafecf7d929e5267c"
    sha256 cellar: :any_skip_relocation, big_sur:        "60e700ed118c0de5d7cffbcfd79517b6c576b858966d55fd20413777f7ee801f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2fea85388899556c3bce41fbe5eb69b30176dd4b87330bed8a76831c6a95f8f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"brev", "completion")
  end

  test do
    system bin/"brev", "healthcheck"
  end
end