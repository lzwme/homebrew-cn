class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://ghfast.top/https://github.com/alexellis/arkade/archive/refs/tags/0.11.100.tar.gz"
  sha256 "9975594eb52fea701f25bf7e4e5d63d9fede4697c255ce5d37e423454eb0201a"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0208a419ee065ce3989598c42bf1173704449075468f91c8471106ec77996b64"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0208a419ee065ce3989598c42bf1173704449075468f91c8471106ec77996b64"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0208a419ee065ce3989598c42bf1173704449075468f91c8471106ec77996b64"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff54de15ee9ba5c8689533a4d37de0fb5d7a415e6c9cae0118a9b27f64b95ffe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c294ce0bdfb531519eea2a5cadb72d2be83be625eaddf0741bff9c4ce8c70df2"
    sha256 cellar: :any,                 x86_64_linux:  "3fdfb8e1ffc5eab2a73f089256843d998cb6363163b5468927ffd3dc3baa3e51"
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