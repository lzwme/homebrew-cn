class K3d < Formula
  desc "Little helper to run CNCF's k3s in Docker"
  homepage "https:k3d.io"
  url "https:github.comk3d-iok3darchiverefstagsv5.7.5.tar.gz"
  sha256 "dca2348cfc1f6a08d8d4d6a93a2cca6a77289f373a76b9f6119512ba7d66f496"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92022f262c5d0a84c49e2d8357934720a86e37b44a9eb758090211ef86ee705e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92022f262c5d0a84c49e2d8357934720a86e37b44a9eb758090211ef86ee705e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "92022f262c5d0a84c49e2d8357934720a86e37b44a9eb758090211ef86ee705e"
    sha256 cellar: :any_skip_relocation, sonoma:        "afa4787a7bdcabfa4464c543e942b68da07913d612719a0126102cc087073534"
    sha256 cellar: :any_skip_relocation, ventura:       "afa4787a7bdcabfa4464c543e942b68da07913d612719a0126102cc087073534"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "311ae9dce37bd64ec04f58255636be23248473d2a8929627c7b6ab3ac6e09ca5"
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