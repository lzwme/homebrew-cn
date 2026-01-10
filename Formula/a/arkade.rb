class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://ghfast.top/https://github.com/alexellis/arkade/archive/refs/tags/0.11.62.tar.gz"
  sha256 "aef839dc3481d8cdb6d3c7af4547df21266b3357f7d1320750893fb4c7afbc2c"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3fab4c12bf9fa241c010ceb86c8389b107cd7983a50aa5b71013213ad4303040"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3fab4c12bf9fa241c010ceb86c8389b107cd7983a50aa5b71013213ad4303040"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3fab4c12bf9fa241c010ceb86c8389b107cd7983a50aa5b71013213ad4303040"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd978329b23284dafafa1146f9b3da82170c5ed99350ae5ba8cc9aa7c7ddfa7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1b83e0714ebb5ffb05c5fd7d0e68f2ae1de5a2510558a0d79e4448035356234"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb394742cb3be8dcfc41fbef229afc9efcec2c9132fe684d4d6796b005aa7340"
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

    generate_completions_from_executable(bin/"arkade", shell_parameter_format: :cobra)
    # make zsh completion also work for `ark` symlink
    inreplace zsh_completion/"_arkade", "#compdef arkade", "#compdef arkade ark=arkade"
  end

  test do
    assert_match "Version: #{version}", shell_output("#{bin}/arkade version")
    assert_match "Info for app: openfaas", shell_output("#{bin}/arkade info openfaas")
  end
end