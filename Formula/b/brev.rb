class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https:developer.nvidia.combrev"
  url "https:github.combrevdevbrev-cliarchiverefstagsv0.6.307.tar.gz"
  sha256 "7055e4eaa428fc28d25c7addde6cf5837a06ea918c067563211ec944548160af"
  license "MIT"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97c0818ab757d34e53de52c9162ae4c47df3311ddca85f33f14369033cc0f4ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97c0818ab757d34e53de52c9162ae4c47df3311ddca85f33f14369033cc0f4ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "97c0818ab757d34e53de52c9162ae4c47df3311ddca85f33f14369033cc0f4ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "41a6f33113d709b4b7d1d9933e88801c1233eab305256c21004517f70cc21290"
    sha256 cellar: :any_skip_relocation, ventura:       "41a6f33113d709b4b7d1d9933e88801c1233eab305256c21004517f70cc21290"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2869ff1d72e59f9d6f8c0522dc46d3096d049e7707a8b2b33cd184f0f8709f15"
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