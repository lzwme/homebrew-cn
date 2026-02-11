class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://ghfast.top/https://github.com/alexellis/arkade/archive/refs/tags/0.11.75.tar.gz"
  sha256 "3b049dd5fa9780e603f85a9cc0e156923dc4059b936f60ed02e9fc9a78f1fb50"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37d9c895d4e80d2c8d6102c34db72e1475fd286d3da9f739a32c08696f03eb3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37d9c895d4e80d2c8d6102c34db72e1475fd286d3da9f739a32c08696f03eb3c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37d9c895d4e80d2c8d6102c34db72e1475fd286d3da9f739a32c08696f03eb3c"
    sha256 cellar: :any_skip_relocation, sonoma:        "b838cae89e816f4ea8a6640d043c9adbd6fef4f3e8d1dd57732786e4bf0fb1b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53d4384d4144272044f7f703bc318f80806fbc15bdabbe35962ec3eb3d036145"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c23ba9885ded26e034e735403b5632eeab4a567e9ed65c44dc143b0f0b8ec44a"
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