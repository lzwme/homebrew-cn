class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://ghfast.top/https://github.com/alexellis/arkade/archive/refs/tags/0.11.43.tar.gz"
  sha256 "4d392a77b08f88b4db6545e729cd649ff3e7bb86117d0843a5878a3df51678f5"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ede01c46a243bea10b111b39aeca7545f660de5a8e6f799e7b1d725980a03c6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ede01c46a243bea10b111b39aeca7545f660de5a8e6f799e7b1d725980a03c6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ede01c46a243bea10b111b39aeca7545f660de5a8e6f799e7b1d725980a03c6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "06ab87b54251553d2d3a6bca6733096b8eb1de223b10a4dbbbeb7479e0f04017"
    sha256 cellar: :any_skip_relocation, ventura:       "06ab87b54251553d2d3a6bca6733096b8eb1de223b10a4dbbbeb7479e0f04017"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb087ba2ec44ceb0c70c949611c6e4928cce298cdf433531ddc2f338b65f2b18"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alexellis/arkade/pkg.Version=#{version}
      -X github.com/alexellis/arkade/pkg.GitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

    bin.install_symlink "arkade" => "ark"

    generate_completions_from_executable(bin/"arkade", "completion")
    # make zsh completion also work for `ark` symlink
    inreplace zsh_completion/"_arkade", "#compdef arkade", "#compdef arkade ark=arkade"
  end

  test do
    assert_match "Version: #{version}", shell_output("#{bin}/arkade version")
    assert_match "Info for app: openfaas", shell_output("#{bin}/arkade info openfaas")
  end
end