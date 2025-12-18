class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.64.0.tar.gz"
  sha256 "27f17ac0e3ed4c4bca8ec3293134a4e81feda3937a17e15df6e2c5dd287b62de"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ee8da1074e43194d4601da73a7dbd8ecfd10384a5b498f07f1596734a573425"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f3a227db141674beec3d39b617cdb900546b4de32082d191c928f21c3d5e9a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8d739d1a6b39e228d361a98db6c21172bf8775bd5fc82e212aea40431061da1"
    sha256 cellar: :any_skip_relocation, sonoma:        "62b0617a3b55cb5071942965356608f993b35d5b8f364509643ab81d45c6d566"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1d23b612fc24c48649760a7addaa8f1cf5b227baadcbce4c4b11f8f6e2a8ade"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b12307ff2fbf2930f34dc66be1b81ade3e566cc16321fdd12af2476933860a71"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "run chainloop auth login", output
  end
end