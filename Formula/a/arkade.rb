class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://ghfast.top/https://github.com/alexellis/arkade/archive/refs/tags/0.11.84.tar.gz"
  sha256 "3849d9bed7f12cf568225b708ea94d488c60b516207c50b435658507d5a4a10f"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74fd30047fa96a12f5ed7f3f27e8f0675cbc4142bdb22e04de241ba8ad72fa02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74fd30047fa96a12f5ed7f3f27e8f0675cbc4142bdb22e04de241ba8ad72fa02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74fd30047fa96a12f5ed7f3f27e8f0675cbc4142bdb22e04de241ba8ad72fa02"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e4346aa010efe5061c1b76db3f6fbe783f04f1127d78ca8385b0f7dc178581f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d27c853891e708c7e0b418351b118403d0ecb6e6882e49830a091c4c373474c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c32b60198578cd54613a534dbd974adb15c0b6417726a771534390510a8b05b"
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