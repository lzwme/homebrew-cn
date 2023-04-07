class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://ghproxy.com/https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.214.tar.gz"
  sha256 "1854854029fa02ff5b7d88eee709b78b9458fdd3f5efca0e33887dacc6dfec60"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "091e48bc9043bb42e08b281b89ae3e927426eaa073b9dfd2fe28d7b866e1d12d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7cc8a274161a839bf25a2966033874f1c87273eb1c20d25d23990ff0b0d42da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e12e93347136f17ea0fd6d5e5e5399b99ccb5fdd4f42f242fa738976949fab01"
    sha256 cellar: :any_skip_relocation, ventura:        "9bdf7b6475a03128e614879414452e2cf81f40e492526fd8972e5eeab84fc54b"
    sha256 cellar: :any_skip_relocation, monterey:       "327d7c348b25bf5d38c84f3d88c04ba0967d4b7a99c61f373c35592cec663be3"
    sha256 cellar: :any_skip_relocation, big_sur:        "e9e2dd476bfa54ad0b1dab0bb73848ac59a90e440824f0fc753e4927425c68a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbd05ca88005ac0338f4d415576f1c0782e01777bd4fcef06746c1afaed03012"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"brev", "completion")
  end

  test do
    system bin/"brev", "healthcheck"
  end
end