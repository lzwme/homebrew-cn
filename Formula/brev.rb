class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://ghproxy.com/https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.223.tar.gz"
  sha256 "2e03dba73e025650a9cbf4f52520f5ecd8b73a8b9a128a85d712973df9a71afd"
  license "MIT"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "389d6fbe87776a27b1bb75c4438f93434c517ab64d634e760941497d3b093b78"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f438336e4642e82ad570c3449ef838812691ca3ce58809064d58834ba8e2ac8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "06fd2ea7c2e188f16a9987237f431af37308567ff6701859665181ec235b60f0"
    sha256 cellar: :any_skip_relocation, ventura:        "3251080a80ee991d81318f2b1a18f92c1f257efa308210b156448dad45cb0e22"
    sha256 cellar: :any_skip_relocation, monterey:       "94aa295a3f7b9eadb0832bc54b508cfb46033a9a0668d0cae71d114c2b6e2c36"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb5522994516c6d0ad856cefa2987e9fc2e40ee0b5af848460db675911f8bf49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11f65419bd52d3a0424f59b6c16ec904aebfd01ddc30d70bc1781e9b2a4d9018"
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