class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://ghproxy.com/https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.265.tar.gz"
  sha256 "c73216275aa07f8f4aad72834494189c11fa2c407f6692f79389f86e971cfa27"
  license "MIT"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b84f428f921df419582c2b95a81b1eb4f487ec728af7d20cbc648020411e6416"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3012f8b7032001f5f3fa72b441ec4b671ed955a1b3be7f14822e09fe0cad1ca9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d256ad779b8122d18266f6c23cd155f2ea0f4e6b445412271d0f6edda3a77bb1"
    sha256 cellar: :any_skip_relocation, sonoma:         "d56dc99894dc09ec4c4b9af048164b27937d99e9e4d5c2ddcb2b46648c4cf851"
    sha256 cellar: :any_skip_relocation, ventura:        "2661a58f343856a28b50124199b819c44e5fe65c49304143c04fe716e1ed0be4"
    sha256 cellar: :any_skip_relocation, monterey:       "4545e5ed8857ac85010b52899215b1e67151c64d0f693a5f8985ad0bd10f434f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "760ed0f03f15946861a8c8de6adce92c1d96c30b522727fd5db845f08490810e"
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