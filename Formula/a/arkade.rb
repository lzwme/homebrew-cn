class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://ghfast.top/https://github.com/alexellis/arkade/archive/refs/tags/0.11.116.tar.gz"
  sha256 "39ec737fe61f008e85ec34268116bfb68fa3f5018afad55be499081fd6fe54f3"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef0bbe25f5943ed76dcc02a15d93d66764d50701152e337a32637119e4f7024a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef0bbe25f5943ed76dcc02a15d93d66764d50701152e337a32637119e4f7024a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef0bbe25f5943ed76dcc02a15d93d66764d50701152e337a32637119e4f7024a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a49eb027fc57277b94551a284b49a93f4b8dca85374ba55ed67f203a95ecf33a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c01aa60386528c7acf7519b509fec0fb3822658937cc963982a5c9fa3e9a5280"
    sha256 cellar: :any,                 x86_64_linux:  "84c9ef6f9cfeffea29ff8b52b7526bb55f6198992f37b63bc4e3164ecafa9251"
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