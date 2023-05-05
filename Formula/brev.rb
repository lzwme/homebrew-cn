class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://ghproxy.com/https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.224.tar.gz"
  sha256 "9ca9773fb7d6a722ef221fe65b6ff52e2524debf9285bde8f260763bf06bfcf8"
  license "MIT"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "508d98471afc902e3089127b8621886496da303fdec96ba51d345d3a7e293916"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80143cf5a2ccb62404622918ae55b59e3c1b05db637b8e5dec5d1616d12da86b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ee6dd28b73bc521b1cb988e58735a98bf68108b766c01ec504005f6ecfe00dc"
    sha256 cellar: :any_skip_relocation, ventura:        "2c3d67771e561129a951ed6a98b9e4a3f4670edae803098df66f6ecc7c620edd"
    sha256 cellar: :any_skip_relocation, monterey:       "a354462fec73912ccef942b535db3f2e0adb69a1b0415559b264b1c405c7e656"
    sha256 cellar: :any_skip_relocation, big_sur:        "32c390ee381330d9ad97c3f925d48f455b5e520bb7ab37840dea24d05acc9d23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3118837738a30ec798014f83466e034e1d766f27ffa13e0f8739f5c0d920aa7"
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