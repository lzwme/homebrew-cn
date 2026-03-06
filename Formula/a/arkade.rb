class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://ghfast.top/https://github.com/alexellis/arkade/archive/refs/tags/0.11.86.tar.gz"
  sha256 "a03f76e06ba0c0d4dd5adbddfa4f5601822dd20fbfb4d1039d12c4fcf297fdbc"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b83d884f346caa1014008d67820b4efe323d8bec093f7cfc1a55f7bda823a030"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b83d884f346caa1014008d67820b4efe323d8bec093f7cfc1a55f7bda823a030"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b83d884f346caa1014008d67820b4efe323d8bec093f7cfc1a55f7bda823a030"
    sha256 cellar: :any_skip_relocation, sonoma:        "e74d0ea7fcdb34f7c8744694a4bf1dd54c992031217d197bed380be424416e34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20558f3f0dafaa7cca09a8a7f18e1aab328c96a10206c62b12f5f4f1751a985e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "352ba358bf535b787df1719d5c94bb23f937b80aa5cf6f4abc9b67249ff36812"
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