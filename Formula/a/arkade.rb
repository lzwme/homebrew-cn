class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://ghfast.top/https://github.com/alexellis/arkade/archive/refs/tags/0.11.72.tar.gz"
  sha256 "8cbe7beb8fc9c27c5a6e4cc062640279e83a2cd4cb09d54fe8c8236cb53f7e0e"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ad1125c5dc26b49b5fe85f41c576f6574ec3e2408f7490d9ae9ce1863c1f1fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ad1125c5dc26b49b5fe85f41c576f6574ec3e2408f7490d9ae9ce1863c1f1fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ad1125c5dc26b49b5fe85f41c576f6574ec3e2408f7490d9ae9ce1863c1f1fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b35b86f4f42e2b40faf524545043019768317b877e476ef07470bcf86ccf73f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90b4ddf9a2200b3d10dbaf904e631f1bc418cf201619146a0ed8554ace7d9aba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af38a5c566e8fdffd440d08e08386a6ce72b86ef410cf3294cd48a919599ff5d"
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