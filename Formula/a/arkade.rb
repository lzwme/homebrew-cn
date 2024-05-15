class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https:blog.alexellis.iokubernetes-marketplace-two-year-update"
  url "https:github.comalexellisarkade.git",
      tag:      "0.11.12",
      revision: "d93098490dd3ba78c556c89a502bdf139c29a458"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d611afcc045dd4acb0d13dc415581ffcd3a4b48b479294124c5ca137753ed90e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "23286462e94a117d6db807791c01364b6490629a730a6e6c82fbefeb4b37b436"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e33c34cfb4ad85e0773fb9931f0f5ad07fe4f8f643dabc772540b31169ab2c4f"
    sha256 cellar: :any_skip_relocation, sonoma:         "6057d36f0c651a6f77504d0108019c284b3a72d5164b4b9be69b2659c4a7c50d"
    sha256 cellar: :any_skip_relocation, ventura:        "207414b563fe9a5f12e5d59d6a1fa31a68984a86622a5771be01a6eae00211c6"
    sha256 cellar: :any_skip_relocation, monterey:       "81a471e2096475fc2f33e58c33bd08f671f6bdb274e1ae52a48f633ee99b31e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ba3daeba9830f55e36c36f6f42d43f661b13ca07c4fa8bf70f2ed1f8474c96d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comalexellisarkadepkg.Version=#{version}
      -X github.comalexellisarkadepkg.GitCommit=#{Utils.git_head}
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