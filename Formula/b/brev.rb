class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https:developer.nvidia.combrev"
  url "https:github.combrevdevbrev-cliarchiverefstagsv0.6.309.tar.gz"
  sha256 "6244a5c211764810e36f2d7b4e529dc2ea9f5183d4405dff1f330b9196528ba9"
  license "MIT"
  head "https:github.combrevdevbrev-cli.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62d93163e5ca4ec4f149adf1715899cafaae3ec7bf9204818ed7829b84a13092"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62d93163e5ca4ec4f149adf1715899cafaae3ec7bf9204818ed7829b84a13092"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "62d93163e5ca4ec4f149adf1715899cafaae3ec7bf9204818ed7829b84a13092"
    sha256 cellar: :any_skip_relocation, sonoma:        "68130acae5a92481a3e9b89a4159702cd59c8b22d0f614429a5aea8277dbb25e"
    sha256 cellar: :any_skip_relocation, ventura:       "68130acae5a92481a3e9b89a4159702cd59c8b22d0f614429a5aea8277dbb25e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4cad3838c487f692d8fd0d79a48c32509c7e9663a704c36bedb3b752a6a7570"
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