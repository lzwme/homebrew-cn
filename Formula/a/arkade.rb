class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https:blog.alexellis.iokubernetes-marketplace-two-year-update"
  url "https:github.comalexellisarkadearchiverefstags0.11.34.tar.gz"
  sha256 "6a5f4e0a9135be04926c75f4378ab4dc575bccffcb5c045af07d159eb2fc3b1e"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "769272efbc02a2ae113da1c046f0c81ff964ca50773ff1226c66de20dc868a60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "769272efbc02a2ae113da1c046f0c81ff964ca50773ff1226c66de20dc868a60"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "769272efbc02a2ae113da1c046f0c81ff964ca50773ff1226c66de20dc868a60"
    sha256 cellar: :any_skip_relocation, sonoma:        "61d3638dc6bd81527d8183ce7b7e9428a5bf8c04e24d280893fcb2dd2f5fef44"
    sha256 cellar: :any_skip_relocation, ventura:       "61d3638dc6bd81527d8183ce7b7e9428a5bf8c04e24d280893fcb2dd2f5fef44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1349b41afad918c64c64e323ce717406f9d18cfc0f7fe12c32996c4f8c7f50db"
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