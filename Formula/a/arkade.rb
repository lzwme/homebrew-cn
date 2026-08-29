class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://ghfast.top/https://github.com/alexellis/arkade/archive/refs/tags/0.11.125.tar.gz"
  sha256 "1c089d23271fc8e87891be42416a99c8a940d17f3bdcf55514e24444ad6393bb"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "94a4f33d5cbe0f85f80d5966dee5603b90dbfe853a1ab53464376cedd3b615d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94a4f33d5cbe0f85f80d5966dee5603b90dbfe853a1ab53464376cedd3b615d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94a4f33d5cbe0f85f80d5966dee5603b90dbfe853a1ab53464376cedd3b615d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a61a7335c1f60341c07fb76d9eaf37f793009b11d688a3402d71750926c14c4"
    sha256 cellar: :any,                 x86_64_linux:  "67fbaf685dada01bd457252a94e9ca9f2321415837a4711bf6569853734d1ec9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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
    assert_match version.to_s, shell_output("#{bin}/arkade version")
    assert_match "Info for app: openfaas", shell_output("#{bin}/arkade info openfaas")
  end
end