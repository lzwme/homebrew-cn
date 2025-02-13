class K3d < Formula
  desc "Little helper to run CNCF's k3s in Docker"
  homepage "https:k3d.io"
  url "https:github.comk3d-iok3darchiverefstagsv5.8.2.tar.gz"
  sha256 "666c6666be63baea6f574c83a61ffcf323d7a1949780ee42775e934b6e352948"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d870a75c145eba14049a1d4ca95a0f7b692cd2d22e95164ccce9b878e5d8ab29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d870a75c145eba14049a1d4ca95a0f7b692cd2d22e95164ccce9b878e5d8ab29"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d870a75c145eba14049a1d4ca95a0f7b692cd2d22e95164ccce9b878e5d8ab29"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c49e125bf15670f4c4cdd120e42c663c807e9a333ee3822268d736570df4471"
    sha256 cellar: :any_skip_relocation, ventura:       "5c49e125bf15670f4c4cdd120e42c663c807e9a333ee3822268d736570df4471"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15b9277ca60355e4786ce7bb7804959420e796930bb232a3eceb7d1f146241f0"
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