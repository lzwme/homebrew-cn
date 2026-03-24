class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://ghfast.top/https://github.com/alexellis/arkade/archive/refs/tags/0.11.89.tar.gz"
  sha256 "f9592b1671a964d02e3aca98691cead9f512b229fbaf43bbad314af297aa9900"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "484e02a9093ff0fa3ee07fc40ff4a7fd4227eff71a6423c6ca4f7dff112b1e99"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "484e02a9093ff0fa3ee07fc40ff4a7fd4227eff71a6423c6ca4f7dff112b1e99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "484e02a9093ff0fa3ee07fc40ff4a7fd4227eff71a6423c6ca4f7dff112b1e99"
    sha256 cellar: :any_skip_relocation, sonoma:        "70bd31b9e115eaf21f1b06d17b172d831bdd254e6f97555c6a2b2a5ceee644dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce6a398bc8db8c7c95869d612127858e36e6ecfb7ebe6de1ffc2a893e607ed42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52e634503642cc142a23de71e8ac4b418ee75e6c61d4909391e784a403b6d159"
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