class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://ghfast.top/https://github.com/alexellis/arkade/archive/refs/tags/0.11.85.tar.gz"
  sha256 "8580f495e7ce4d955dcbc9a24fb06baa096c2e195692309932babd8cf48e8779"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23fa40a7b37b4be5639dca2970605106e4d06e927aac39feb238d1a309360405"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23fa40a7b37b4be5639dca2970605106e4d06e927aac39feb238d1a309360405"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23fa40a7b37b4be5639dca2970605106e4d06e927aac39feb238d1a309360405"
    sha256 cellar: :any_skip_relocation, sonoma:        "8225b2bce70f353acf255665c73b6079af79bcffd77657d294d3451855ab4d92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "072511f6823eabac96e70587785f157a411c8896b87d4d8899db094ef94b2867"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91ef4cdfaa2ae1ca316c5be3f62b494b7c1ad3914fcd6faea082859b6b80aed4"
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