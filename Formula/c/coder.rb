class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https:coder.com"
  url "https:github.comcodercoderarchiverefstagsv2.12.4.tar.gz"
  sha256 "f80df079e83eed6740d4c3056f545caa9a749d8cf5bab53b3e57bb9de4a5757c"
  license "AGPL-3.0-only"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8f1f7341e3b9c5033507dc29920124a7dddd696532419604de9717c7909906b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34d622561a37518e0fd21fbe874b0bd6ca8372586c4eacfa933669b2d94d5dd7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "661e299c28818c4eed7f00a9d68f74c1e37f72a8cc824340769155e09568b259"
    sha256 cellar: :any_skip_relocation, sonoma:         "64a5f682a49ac9c1f07d505c5341b1c49949922fb3e6a7c94fe4d14a766cecfa"
    sha256 cellar: :any_skip_relocation, ventura:        "19e48a6b32d1a64372d5b59a5838892b8e2493055fd837a705e006b67babe0d3"
    sha256 cellar: :any_skip_relocation, monterey:       "424b0f18af6f5523677cb019f437a6d6f74cfbf407cf108cd0906a34d5732003"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ee8b4307aa1169164709cec48b48017d88c39788a3beb5a7adbb708946ff98e"
  end

  depends_on "go" => :build

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