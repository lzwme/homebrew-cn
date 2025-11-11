class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://ghfast.top/https://github.com/alexellis/arkade/archive/refs/tags/0.11.55.tar.gz"
  sha256 "5f520982ed32332e087befca67b402e5f8ad423c0bacc0e88791591fd70d1175"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "058cdd2de51b30d822b2c64bb3179a8106239af6318649a6a282896fd781c107"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "058cdd2de51b30d822b2c64bb3179a8106239af6318649a6a282896fd781c107"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "058cdd2de51b30d822b2c64bb3179a8106239af6318649a6a282896fd781c107"
    sha256 cellar: :any_skip_relocation, sonoma:        "fcd479d8e938ba4eefd84fbe01ab0a9f7fdea7fb846e71ef7e05d75d6fe3455f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f094fe58608a4b8388e4a68ea68c714d1b0380ad62df71f459fdb29b2404788"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9fec0b8d20e34bfd277020ecf7fbe88a64b983cc20b983743e7ebd283f0129b"
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