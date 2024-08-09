class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https:blog.alexellis.iokubernetes-marketplace-two-year-update"
  url "https:github.comalexellisarkadearchiverefstags0.11.19.tar.gz"
  sha256 "4c0d5e8156c848feabcb0da8aaba1d5c1dfc31708b503b383344022c2996641b"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "400ad5a58931c6895bd51ccb4b408b7f59b2cd94e6b342862805864b974f28b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "909fa2b7e4427840df18be75282bede566cea084b148c095a77c469b523a57cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "243becaa214f747ac5bc48b7942b042592541de2d3459c430566ab70bbaa024a"
    sha256 cellar: :any_skip_relocation, sonoma:         "0e691e6e12403604fc1409d1f08e71a7d87c0a8f4abf3e9aabc313e284004ec1"
    sha256 cellar: :any_skip_relocation, ventura:        "7a11e78bafb126bfa4eb858897d1ffa6cb8119edf0354215ecbc30c1abd02a5c"
    sha256 cellar: :any_skip_relocation, monterey:       "f9c072ba310a94534c46d48d22b792360be8cf8989d120aff0c1bc3770c9ee8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f61e793d7ed2c79744b8b90a34453d0a3a586a3f87fcd74bd3dcc6b2d65ad886"
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