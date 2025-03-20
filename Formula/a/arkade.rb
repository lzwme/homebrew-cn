class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https:blog.alexellis.iokubernetes-marketplace-two-year-update"
  url "https:github.comalexellisarkadearchiverefstags0.11.37.tar.gz"
  sha256 "a2b740256bb771f87b05727aac4790460eca444110f69a99b0ce813c4ed70989"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "974362fb5cee53a710fe2f46956abafc903c03518889dce734422ed0c82928aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "974362fb5cee53a710fe2f46956abafc903c03518889dce734422ed0c82928aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "974362fb5cee53a710fe2f46956abafc903c03518889dce734422ed0c82928aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f83d3cf4dc354c010b6ab3827bbf26ddf2c73da82b66776d1797726037a2d6e"
    sha256 cellar: :any_skip_relocation, ventura:       "6f83d3cf4dc354c010b6ab3827bbf26ddf2c73da82b66776d1797726037a2d6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b93b0d814c98098fb07f2548e97849d7d5bb5e707c065c48ac9d1224b58a3e9"
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