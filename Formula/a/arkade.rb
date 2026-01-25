class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://ghfast.top/https://github.com/alexellis/arkade/archive/refs/tags/0.11.66.tar.gz"
  sha256 "e26d5909ce39c00b828f0510d628431081d8eacb38cde04db1c06d1f3117d438"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce153c833ede008dcbaf66edf2a948dc99d03841670c41270f1af08ca6458537"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce153c833ede008dcbaf66edf2a948dc99d03841670c41270f1af08ca6458537"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce153c833ede008dcbaf66edf2a948dc99d03841670c41270f1af08ca6458537"
    sha256 cellar: :any_skip_relocation, sonoma:        "2dac124364a7e0335b3a8064ac3c3a1e8e5562be98c14afed03ce68745d8f01c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c44506aef2e9cf53812f9a96df24b726d9642e1ac4c4ee277278aa26ed76426e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61890dff993faac54734c163e1bfa0c279a024f80b27ec62428c56e862552114"
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