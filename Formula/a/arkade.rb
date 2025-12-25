class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://ghfast.top/https://github.com/alexellis/arkade/archive/refs/tags/0.11.60.tar.gz"
  sha256 "cc4f7279a39c46cbd1af5f62bf5fbca40d5365a19fc511cafec26053b6a39ebd"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c162d5bd6b34c570c70b257bd6e71a2312949810691b95ac6a6d31426cf3634"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c162d5bd6b34c570c70b257bd6e71a2312949810691b95ac6a6d31426cf3634"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c162d5bd6b34c570c70b257bd6e71a2312949810691b95ac6a6d31426cf3634"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f900cc8ef1aa45e01b6d6ef0708af1dd04fe9c2510fabe442cc884a58c19383"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4a8d50dd023d1f13f183dbe2fb77e85b3f9071e8226a4e164c798ac332fbb77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c18e0bb08c0868acc2af34d7d6998e492dfa0cc491065a0631bf2031d30f417"
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