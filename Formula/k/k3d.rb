class K3d < Formula
  desc "Little helper to run CNCF's k3s in Docker"
  homepage "https:k3d.io"
  url "https:github.comk3d-iok3darchiverefstagsv5.7.1.tar.gz"
  sha256 "48603a11be7f546cbc1dafdd9f02e5f3eb97e5e54d8992792ca3974d762f950a"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a0ba80c52cc93ac9c97bf9ddb45cdbb8a6d8c5fda4d016535559ada9a9641817"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08f76e9e79186d02bd2b0c638415d49d86223daf5aaa29b0d08a9008d328b890"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe52e0dd1f9d860e55c676fab325efcdcfb0cdb1ba8fd49964fb5d1bd7d39324"
    sha256 cellar: :any_skip_relocation, sonoma:         "28adf64d16b6cd33aa6aecc8ddc18e6c70054a8b1a72673a61a13510cb071367"
    sha256 cellar: :any_skip_relocation, ventura:        "e7f978e6507f7139e4596196a30ab7682aae48b95d1afe428773e162fb244e5e"
    sha256 cellar: :any_skip_relocation, monterey:       "913027a81eeefe4934759873a61aa0ea750d285f29fa5846aabb27e919660aba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c361b7178583f64a9bc78e636852ef782663ccfb8aa2407182776b7f29d95801"
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