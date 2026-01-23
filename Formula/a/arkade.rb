class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://ghfast.top/https://github.com/alexellis/arkade/archive/refs/tags/0.11.65.tar.gz"
  sha256 "ca88d086c6d7433c76ee0d6fc1ceca339ae0614ccbd748df0067835d8e0495c0"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd9bf9a287a28a50e66e6ba9e90dbff761374db008ff32406e275744fd4f5089"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd9bf9a287a28a50e66e6ba9e90dbff761374db008ff32406e275744fd4f5089"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd9bf9a287a28a50e66e6ba9e90dbff761374db008ff32406e275744fd4f5089"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa88f9efe1bbb1698f3199afce7743365baa99e3b4ff57eb6dabc2578ecea9fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "832136786383abfbccaecaf2c8e8e886b7f27db9c7fd6c7b572ed1c22a573b14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2ce4466a32059392ee50dba64261fef856bce5453524432fbe1c2a8c5f97a2f"
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