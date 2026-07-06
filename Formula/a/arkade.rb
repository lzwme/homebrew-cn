class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://ghfast.top/https://github.com/alexellis/arkade/archive/refs/tags/0.11.108.tar.gz"
  sha256 "ece510536361e0b3aad5b89238ec111756dc76a565e8a27dc47f55c0aaa1cca9"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4700897d8930a5a3c6f8a768c558a88b2a4c9e8f000937dbe45b9c0a8c9b11a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4700897d8930a5a3c6f8a768c558a88b2a4c9e8f000937dbe45b9c0a8c9b11a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4700897d8930a5a3c6f8a768c558a88b2a4c9e8f000937dbe45b9c0a8c9b11a"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b4f99adf2ac509fa6cb1e74f855febdc761fd390a5c7f5cd39a0441aee55143"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10bd231dd8a3fdb10af82f09f1389cecd033ffcf76b9db88830b2faef0e3e5bb"
    sha256 cellar: :any,                 x86_64_linux:  "99d4144cc6ad1ea37f1a787ca6e6445a97e250f32f7c45e71dec55908bdbe8be"
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
    assert_match version.to_s, shell_output("#{bin}/arkade version")
    assert_match "Info for app: openfaas", shell_output("#{bin}/arkade info openfaas")
  end
end