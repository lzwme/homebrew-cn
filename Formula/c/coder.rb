class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https:coder.com"
  url "https:github.comcodercoderarchiverefstagsv2.11.3.tar.gz"
  sha256 "e0f03bf11b26305531b8f2d0b15185ef4c443e764ade8c79be9daed5bf30c360"
  license "AGPL-3.0-only"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e702be0b9faa45445c75a15b16f018a0c05c2d56760f75c15be3d61336b9f3c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce73921825f37f797979ce5d0b753742c3f8fdc4cfe1c0848ca149ccf55d4b41"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67e2484eb112d5ca511eb4d68cc68acbb94c5c2e4e946d69e0fc310be7aa8bb3"
    sha256 cellar: :any_skip_relocation, sonoma:         "9c11e12f856c43b224fec9e9f12ee52502ec04231dd61edcccce382ca31f6d9e"
    sha256 cellar: :any_skip_relocation, ventura:        "7a224cd86fb046f3c62b00cb97b963dc078dd39ea21e7a03fffea67c348abd43"
    sha256 cellar: :any_skip_relocation, monterey:       "2e165b6e3b836f7e4b4dad34132acae49dbb4c1e5bf4133ca292e310b28f98be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86833b5dce00a59303258bdd205bc09e26351452ad3591739c05b67985a39c03"
  end

  depends_on "go@1.21" => :build # see https:github.comcodercoderissues11342

  def install
    ldflags = %W[
      -s -w
      -X github.comcodercoderv2buildinfo.tag=#{version}
      -X github.comcodercoderv2buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags:), "-tags", "slim", ".cmdcoder"
  end

  test do
    version_output = shell_output("#{bin}coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}coder netcheck 2>&1", 1)
  end
end