class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://developer.nvidia.com/brev"
  url "https://ghfast.top/https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.320.tar.gz"
  sha256 "961569aa6e9905380f6386b26d7e4e57599221a4077d87552177b55b26b4cd8a"
  license "MIT"
  head "https://github.com/brevdev/brev-cli.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3718315509e1f848d9594993a77d3cf34c70dc9074429620902a47bed05cd8a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3718315509e1f848d9594993a77d3cf34c70dc9074429620902a47bed05cd8a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3718315509e1f848d9594993a77d3cf34c70dc9074429620902a47bed05cd8a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9b290cca5f30f4df20a55ec54b72819c36cbccb82008fa10feaef4280e5efec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "140482360a85728c55673cfdf635c2fb0239791ce6b77ecdc331544c70aba35a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f849e1cbddbcb780205540aa27488ca993968c1cf2fffd3568a4aea0407bb48"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = "-s -w -X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"brev", shell_parameter_format: :cobra)
  end

  test do
    system bin/"brev", "healthcheck"
  end
end