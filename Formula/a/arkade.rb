class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://ghfast.top/https://github.com/alexellis/arkade/archive/refs/tags/0.11.119.tar.gz"
  sha256 "563918636a83f977ec6b2ed7e6768f709d7c377a572cb4e8307ad330700f1841"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b16210b6431ca333ad28be45461f497e522fd3a4a3726da779e8d51c705a086b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b16210b6431ca333ad28be45461f497e522fd3a4a3726da779e8d51c705a086b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b16210b6431ca333ad28be45461f497e522fd3a4a3726da779e8d51c705a086b"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d832f51ed815658edea85b77de1ee599bd98b74a7676baf50d335396c12fd95"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5dafd6dc3f525c90304c8ba25b2847c6bc5be1099de19a38c4348154e5502c39"
    sha256 cellar: :any,                 x86_64_linux:  "178ff08b883dab63d987097a966ce8fa11926909b82024d8d6109b7f528c2522"
  end

  depends_on "go" => :build

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