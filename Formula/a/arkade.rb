class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://ghfast.top/https://github.com/alexellis/arkade/archive/refs/tags/0.11.133.tar.gz"
  sha256 "340217f9dbd4f0b68ba3ccf446e616ec0bd9505e2985efa8affe730fdc02ae68"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "896513a6011b68d77372cc97f4b6b94bf384a8943ce633127effa743b398500c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "896513a6011b68d77372cc97f4b6b94bf384a8943ce633127effa743b398500c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "896513a6011b68d77372cc97f4b6b94bf384a8943ce633127effa743b398500c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "019c56b964d69364ba3ca27ba1a154814fb46fe5d9e2e0fdb71229a18e00ab71"
    sha256 cellar: :any,                 x86_64_linux:      "1e93c820fae1c63b0d6b65cff1d312cf04542ecb0bc07f8d2cefa477e97cf5a8"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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
    assert_match version.to_s, shell_output("#{bin}/arkade version")
    assert_match "Info for app: openfaas", shell_output("#{bin}/arkade info openfaas")
  end
end