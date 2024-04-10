class K3d < Formula
  desc "Little helper to run CNCF's k3s in Docker"
  homepage "https:k3d.io"
  url "https:github.comk3d-iok3d.git",
    tag:      "v5.6.2",
    revision: "b2c790b51fa038e9804395fcf914df7d00128605"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d05197446de6993804a786572d86109aca8c49a93b3bc6b3e5567ded2bfc67bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "def6b2fb67e8570c371b1c895fac178c0f171862dc3636998a53c7025da6a38a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81558169668784163691b436569203d7593b6de95041872a3e4de1942e05d6ac"
    sha256 cellar: :any_skip_relocation, sonoma:         "13ce6d4f71a8902175ed9fe65e981441d02208c759903f91a7c81e13503c242c"
    sha256 cellar: :any_skip_relocation, ventura:        "bcd6110bc388633efdb327d247c849633799f1b7949606c3e83059ecfa01071e"
    sha256 cellar: :any_skip_relocation, monterey:       "2a17b744ca3d82acb6cb29299a176cb780832acd8d445e5f488bebde14cc959c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9e7047ce3dd4a5634e2d7818d6ca58599db6238fde5a4fbc22ed2850405a303"
  end

  depends_on "go" => :build

  def install
    require "nethttp"
    uri = URI("https:update.k3s.iov1-releasechannels")
    resp = Net::HTTP.get(uri)
    resp_json = JSON.parse(resp)
    k3s_version = resp_json["data"].find { |channel| channel["id"]=="stable" }["latest"].sub("+", "-")

    ldflags = %W[
      -s -w
      -X github.comk3d-iok3dv#{version.major}version.Version=v#{version}
      -X github.comk3d-iok3dv#{version.major}version.K3sVersion=#{k3s_version}
    ]

    system "go", "build", "-mod=readonly", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"k3d", "completion")
  end

  test do
    assert_match "k3d version v#{version}", shell_output("#{bin}k3d version")
    # Either docker is not present or it is, where the command will fail in the first case.
    # In any case I wouldn't expect a cluster with name 6d6de430dbd8080d690758a4b5d57c86 to be present
    # (which is the md5sum of 'homebrew-failing-test')
    output = shell_output("#{bin}k3d cluster get 6d6de430dbd8080d690758a4b5d57c86 2>&1", 1).split("\n").pop
    assert_match "No nodes found for given cluster", output
  end
end