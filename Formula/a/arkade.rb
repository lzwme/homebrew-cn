class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://ghfast.top/https://github.com/alexellis/arkade/archive/refs/tags/0.11.40.tar.gz"
  sha256 "b4ffc7a20c752b9e7eeec16043d86134ca48db71489c402ae17a915957ec1fda"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ee4ae60883bf169edcb7cbe7343fe96ee18382b0abf9a8a1e94c85c10d65b1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ee4ae60883bf169edcb7cbe7343fe96ee18382b0abf9a8a1e94c85c10d65b1a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6ee4ae60883bf169edcb7cbe7343fe96ee18382b0abf9a8a1e94c85c10d65b1a"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba13b849b428b05e77f70d5b7cf710e1b694d54a26cf810231c1f6bbebb7f25b"
    sha256 cellar: :any_skip_relocation, ventura:       "ba13b849b428b05e77f70d5b7cf710e1b694d54a26cf810231c1f6bbebb7f25b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f8eb231c21b37149159f38548ccb527024c3c2981754a717af3c6bfc0c01b2c"
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