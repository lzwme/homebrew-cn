class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https:blog.alexellis.iokubernetes-marketplace-two-year-update"
  url "https:github.comalexellisarkadearchiverefstags0.11.25.tar.gz"
  sha256 "8c508b0020922b3cc3e3ef3160ce36aea429f754b98f0d5b368d9b7928f52488"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "362c7c9bd4337b2ed55c5ec2f0ea27cb044c7b3d2455d6dfe6aafbff146f3dfd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "362c7c9bd4337b2ed55c5ec2f0ea27cb044c7b3d2455d6dfe6aafbff146f3dfd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "362c7c9bd4337b2ed55c5ec2f0ea27cb044c7b3d2455d6dfe6aafbff146f3dfd"
    sha256 cellar: :any_skip_relocation, sonoma:        "6660df000ca0afe16b23ff6a72afe0da978144a954c4e83e4fa3df81aab71024"
    sha256 cellar: :any_skip_relocation, ventura:       "6660df000ca0afe16b23ff6a72afe0da978144a954c4e83e4fa3df81aab71024"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf14859011dbab6855b4a2e96f9bc7e17c5603c8e5e28c979a204fc50116d0ca"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comalexellisarkadepkg.Version=#{version}
      -X github.comalexellisarkadepkg.GitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

    bin.install_symlink "arkade" => "ark"

    generate_completions_from_executable(bin"arkade", "completion")
    # make zsh completion also work for `ark` symlink
    inreplace zsh_completion"_arkade", "#compdef arkade", "#compdef arkade ark=arkade"
  end

  test do
    assert_match "Version: #{version}", shell_output(bin"arkade version")
    assert_match "Info for app: openfaas", shell_output(bin"arkade info openfaas")
  end
end