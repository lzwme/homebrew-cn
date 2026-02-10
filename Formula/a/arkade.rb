class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://ghfast.top/https://github.com/alexellis/arkade/archive/refs/tags/0.11.74.tar.gz"
  sha256 "e6510d31b4f93addbe0ac6c721cf5ae8cf8dd5f9be5e8b7f0833ccc50798b4f5"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "04666fac58fd4591bf5e723d2f90c6b78faecefd05e0e81a46ba3084b6145483"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04666fac58fd4591bf5e723d2f90c6b78faecefd05e0e81a46ba3084b6145483"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04666fac58fd4591bf5e723d2f90c6b78faecefd05e0e81a46ba3084b6145483"
    sha256 cellar: :any_skip_relocation, sonoma:        "f62998104a044c81a13cb2673ca91720c2257c1d61201286fd8c11563735353e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57756f1bd5b08e021bbb8fa5a7ed066ab6a879581adc9afd2266088d1ea6e80e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36a917438d387b89627e1e0b6865d7d3255b0f612d418dca53e276d54707bc83"
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