class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://ghfast.top/https://github.com/alexellis/arkade/archive/refs/tags/0.11.128.tar.gz"
  sha256 "ca714590188e344b158b68bd55547e131dd3830dab6f00706cb52b78cccb5afc"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3acd003c0f70dd3594377610bd4634cbc1dac3e4638be1c89d93e87b2ac979cf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3acd003c0f70dd3594377610bd4634cbc1dac3e4638be1c89d93e87b2ac979cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3acd003c0f70dd3594377610bd4634cbc1dac3e4638be1c89d93e87b2ac979cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e16a711c37a026b5780536eeb4a53d0581ab032bf652774c70ec24d8567969e7"
    sha256 cellar: :any,                 x86_64_linux:      "ff16a110d20ded4ae003c64c93c63ebd34ba606a1987ba1fe99df5512f78fc7d"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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