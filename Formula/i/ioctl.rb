class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://ghfast.top/https://github.com/iotexproject/iotex-core/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "230e7485d61aa1cfa29f76702ebe1f1e017b32ad647f3bfc8aee4da3d0a68aa6"
  license "Apache-2.0"
  head "https://github.com/iotexproject/iotex-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e5583dbc974420dcf684ef369f2c12a140f84fcca36251a3c5b1b891abb122d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93274fa777ab6649562a910df7a487ee624b3686fa80caec8c1ff0520884b006"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40cd1011c58b5760f1a828c7ccefb30c80b07df3bbb7f16ade9d0772c24c9632"
    sha256 cellar: :any_skip_relocation, sonoma:        "13835dd5f741334d456f03fdca5784e1eacf376c64da41e27371211a717b1ac6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5210ccb36d2640a97169e0f59df211ec256b9aff632f4b0839b98bbb706bbdf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e26a461c2adbb4307aeced1bbf1390e9c5c5af9794aec07633089fb2a4cf2a7"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"
    ldflags = %W[
      -s -w
      -X github.com/iotexproject/iotex-core/v2/pkg/version.PackageVersion=#{version}
      -X github.com/iotexproject/iotex-core/v2/pkg/version.PackageCommitID=#{tap.user}
      -X github.com/iotexproject/iotex-core/v2/pkg/version.GitStatus=clean
      -X github.com/iotexproject/iotex-core/v2/pkg/version.GoVersion=#{Formula["go"].version}
      -X github.com/iotexproject/iotex-core/v2/pkg/version.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "nosilkworm"), "./tools/ioctl"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ioctl version")

    output = shell_output("#{bin}/ioctl config set endpoint api.iotex.one:443")
    assert_match "Endpoint is set to api.iotex.one:443", output
  end
end