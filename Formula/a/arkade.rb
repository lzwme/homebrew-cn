class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://ghfast.top/https://github.com/alexellis/arkade/archive/refs/tags/0.11.110.tar.gz"
  sha256 "4d5493aacbe11584ab0eae61fe2b97cfb370ad1f35ae8e05574c1de595abe5f7"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8329c6d3eb3647fe794c73f1576371b59a14ca7ac65a3c2ea56a9ac4841521d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8329c6d3eb3647fe794c73f1576371b59a14ca7ac65a3c2ea56a9ac4841521d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8329c6d3eb3647fe794c73f1576371b59a14ca7ac65a3c2ea56a9ac4841521d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf577d2559c559d24dee368320d16e5acb1f7b29104cf53b2ad909154997fdda"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6cd2db203009ba24b66ffd3d9d9f3f5122fe69f08d3680adc40b12be290d3336"
    sha256 cellar: :any,                 x86_64_linux:  "83b3b5b215661a1628e0ce8214f15f3a88addea079ef4faf290053da7e721091"
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
    assert_match version.to_s, shell_output("#{bin}/arkade version")
    assert_match "Info for app: openfaas", shell_output("#{bin}/arkade info openfaas")
  end
end