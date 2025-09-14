class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://ghfast.top/https://github.com/alexellis/arkade/archive/refs/tags/0.11.46.tar.gz"
  sha256 "014d889986e57fe77daf9a8f6fabb15337db5b9156666a1e78d8a52513723102"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb7f68145574cbccad7e3ab8f96546d7e9660bab2a6b579dacfe7afc12c278a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb7f68145574cbccad7e3ab8f96546d7e9660bab2a6b579dacfe7afc12c278a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb7f68145574cbccad7e3ab8f96546d7e9660bab2a6b579dacfe7afc12c278a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fb7f68145574cbccad7e3ab8f96546d7e9660bab2a6b579dacfe7afc12c278a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "ddb101e18fb9e364b3134fc54c03d72da31b5861dedd871535e5ff43ec3eae84"
    sha256 cellar: :any_skip_relocation, ventura:       "ddb101e18fb9e364b3134fc54c03d72da31b5861dedd871535e5ff43ec3eae84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e289c0d8e801a34d21facaf6198aa992fcc4b98a09c08cd56339677e2e0cb734"
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

    generate_completions_from_executable(bin/"arkade", "completion")
    # make zsh completion also work for `ark` symlink
    inreplace zsh_completion/"_arkade", "#compdef arkade", "#compdef arkade ark=arkade"
  end

  test do
    assert_match "Version: #{version}", shell_output("#{bin}/arkade version")
    assert_match "Info for app: openfaas", shell_output("#{bin}/arkade info openfaas")
  end
end