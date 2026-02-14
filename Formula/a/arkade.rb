class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://ghfast.top/https://github.com/alexellis/arkade/archive/refs/tags/0.11.80.tar.gz"
  sha256 "f5806d52089ddd92360e7d1e546b8be20e52fa6b593ffb82f0728c95ca5cdf8e"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27439feca4956a71d265ba7d6bf2bc459a347d1dd524a230d0ed9a1c44755fb4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27439feca4956a71d265ba7d6bf2bc459a347d1dd524a230d0ed9a1c44755fb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27439feca4956a71d265ba7d6bf2bc459a347d1dd524a230d0ed9a1c44755fb4"
    sha256 cellar: :any_skip_relocation, sonoma:        "6bc5889a8a17561d033045ddd7bd48c9d923b83917093dc8c7a1029dbecb27f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3a2919196c40eb94d5d023b06a5c5b93c139252f7cf21c527c118446cc2fad8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbb246f7a485c32b9877eb73ffffc3bbe1474aefaadc7ec6b37b8c12edf12993"
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