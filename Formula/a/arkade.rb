class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://ghfast.top/https://github.com/alexellis/arkade/archive/refs/tags/0.11.117.tar.gz"
  sha256 "4bb7d6bf1d3dcd31bee7593e342d85ada34fadd15fb3701f72f4d9dbd887efb2"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "caca26d96162dde584c4fc24ac1d968293aed0b51426d189fb2c79e40333014a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "caca26d96162dde584c4fc24ac1d968293aed0b51426d189fb2c79e40333014a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "caca26d96162dde584c4fc24ac1d968293aed0b51426d189fb2c79e40333014a"
    sha256 cellar: :any_skip_relocation, sonoma:        "74e67c8fa7f37f5403133636e64a5515d42ee4b195fc8b7dd74aed04c2c31e3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf2c919663d69532e47feb85c7e4c99a68b86c98d674443e8cf2ff0b371af9b0"
    sha256 cellar: :any,                 x86_64_linux:  "34516a9e58fe44966e316b27dc7e987963eda66e9d8372fa18f47be27575a991"
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