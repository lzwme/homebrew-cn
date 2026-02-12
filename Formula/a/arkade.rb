class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://ghfast.top/https://github.com/alexellis/arkade/archive/refs/tags/0.11.76.tar.gz"
  sha256 "961015b18bce205dcdc6dd0b6a6da748261603b998296ffe45ef440f077f6ad3"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b2ba191e2880babb673ed3c0e34ea301d0d2472356e140c797c57a7d8e9c2bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b2ba191e2880babb673ed3c0e34ea301d0d2472356e140c797c57a7d8e9c2bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b2ba191e2880babb673ed3c0e34ea301d0d2472356e140c797c57a7d8e9c2bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ef0b983003978d25ae0482fb3132dca61ee7edf10d4d934e58059058fa999a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bbd6521d1c5b5c6bea0f77d01d89d46de380f71b939f24531557ba28ed75c84d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f32979537ff1bf2ab53c758793b3c00bdd1caa65709cd06c7a4d7f80592eacf9"
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