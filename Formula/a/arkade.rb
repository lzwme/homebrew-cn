class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https:blog.alexellis.iokubernetes-marketplace-two-year-update"
  url "https:github.comalexellisarkadearchiverefstags0.11.29.tar.gz"
  sha256 "4def5c45bc8b7d7d0476e00c7cb287df90755eb0a6f7b2063e2773a7bdeaa0ee"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7122bc333f469d8a11a9f37c07f0a01208e7c33a98d5c08543923434557083e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7122bc333f469d8a11a9f37c07f0a01208e7c33a98d5c08543923434557083e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7122bc333f469d8a11a9f37c07f0a01208e7c33a98d5c08543923434557083e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "4879293d08103c1d297415e8b36c42f771cca2ecb2bbc086ba26d9db5953e547"
    sha256 cellar: :any_skip_relocation, ventura:       "4879293d08103c1d297415e8b36c42f771cca2ecb2bbc086ba26d9db5953e547"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25b19b5650e9985c865bcd787f0a08da3af0b86ae9b51328cd5ad0906457b15a"
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