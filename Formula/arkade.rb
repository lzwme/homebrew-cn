class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.9.16",
      revision: "2af4a1dd8f29cd1392fb309d416cdf7cc54e7895"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b209a576a7b7ee5e1e60cbb522ba5a7341c8a8374f49725181c501ea53b886e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b209a576a7b7ee5e1e60cbb522ba5a7341c8a8374f49725181c501ea53b886e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b209a576a7b7ee5e1e60cbb522ba5a7341c8a8374f49725181c501ea53b886e"
    sha256 cellar: :any_skip_relocation, ventura:        "6527a799220cf36bbe21421cc35a2feafe6c4c986f137668f335e26f16ace6d8"
    sha256 cellar: :any_skip_relocation, monterey:       "6527a799220cf36bbe21421cc35a2feafe6c4c986f137668f335e26f16ace6d8"
    sha256 cellar: :any_skip_relocation, big_sur:        "6527a799220cf36bbe21421cc35a2feafe6c4c986f137668f335e26f16ace6d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fa1cfce223f69ed17e26973f4b770d30b55066f128f1d7e7f7246dd9dc74650"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alexellis/arkade/pkg.Version=#{version}
      -X github.com/alexellis/arkade/pkg.GitCommit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bin.install_symlink "arkade" => "ark"

    generate_completions_from_executable(bin/"arkade", "completion")
    # make zsh completion also work for `ark` symlink
    inreplace zsh_completion/"_arkade", "#compdef arkade", "#compdef arkade ark=arkade"
  end

  test do
    assert_match "Version: #{version}", shell_output(bin/"arkade version")
    assert_match "Info for app: openfaas", shell_output(bin/"arkade info openfaas")
  end
end