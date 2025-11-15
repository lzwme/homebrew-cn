class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://ghfast.top/https://github.com/alexellis/arkade/archive/refs/tags/0.11.58.tar.gz"
  sha256 "2d7975054b9e84181a93064a1b88cf251f9c075188d5c9b3a084bda68dfa02c7"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b41da4e3820516a4623801ba510b03669595d2549f0e4fd8313a2504d4f496cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b41da4e3820516a4623801ba510b03669595d2549f0e4fd8313a2504d4f496cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b41da4e3820516a4623801ba510b03669595d2549f0e4fd8313a2504d4f496cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "22360477d7e7eeb7b58ba9d8dd2328319c45192d12db3014951b55c82601d745"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "780559dbddc22cd6f88f00ad944fa5a23bc1f0e3ede0e4d4e667210625c1c199"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5c72168f8ce5cbf242f92ab28301cf3f5cd3c31be71b745cdf2f1d8de1b70be"
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