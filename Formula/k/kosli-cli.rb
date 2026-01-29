class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.11.41.tar.gz"
  sha256 "47a45063b8d93204fc3869665f8552dbf34d9143d6505d551ba0469d15d7afab"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "694cf313c8ebedcfc488a86508720af644122ccdc5b9a3dac6620091d0f289f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff4d5bf950a0904cac4990b717287e16f211028231ee203eeeffbe886b65f916"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8442b4db7714cd2cb5615afe7ab91abd824aa9a3bb6267d133d5f67faa752a91"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ea0e97db6aaab98d9c7e3f42973fe279c081624d5a7a13cbb184e5ab4dcf004"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "539f912c4e7e351b32687fdde0e7b79ffd58daec479a86ea18599af5ba1f7887"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28a2f381693c04a2be88fa51ed305033371a3fa42b84e86e1576e6259e6b5106"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags:), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end