class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://ghfast.top/https://github.com/alexellis/arkade/archive/refs/tags/0.11.52.tar.gz"
  sha256 "ecc5816114e1d5cb2bad60cf111e256c1fd037ee7df8ca4c2ec2bd51dc59d861"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a0048f12a7893ff7d213adec5ac917eead8a79becc09bfb7039375558042865"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a0048f12a7893ff7d213adec5ac917eead8a79becc09bfb7039375558042865"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a0048f12a7893ff7d213adec5ac917eead8a79becc09bfb7039375558042865"
    sha256 cellar: :any_skip_relocation, sonoma:        "839c72065fb53b3a81242357572b988e87edcf7fa776abacf13f206e72a213fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a87f281c033066a9b10fb6660b5214e11dbc188edd19ae95c9aed218864c490"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cedb1f2fced2dd7bd4fd0586fcb05f139ee5b9bbbeefccab1225461eddd51702"
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