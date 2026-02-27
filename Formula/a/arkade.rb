class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://ghfast.top/https://github.com/alexellis/arkade/archive/refs/tags/0.11.82.tar.gz"
  sha256 "5cbe135f56422eb9a9e3096d7c51b70baa4e701d1211f89fa903bb5e5dee3809"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ea4a8c7143a6e6d5e313e461d670d90d5e7fcad0470c1a880acb071c00c3d54"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ea4a8c7143a6e6d5e313e461d670d90d5e7fcad0470c1a880acb071c00c3d54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ea4a8c7143a6e6d5e313e461d670d90d5e7fcad0470c1a880acb071c00c3d54"
    sha256 cellar: :any_skip_relocation, sonoma:        "feb74726c37e086ff88a89e84a823d465549f0c6d5d9d98a11b90a39e7ed856b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "810b5f8f6159ffbfc93cd76e82be8a57e279b919bd6b049b03ac9e86997686ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1be7bb1ed7058694a00b7ce7f4df5fd4c323108ee1064e83e36f71ccaa093756"
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