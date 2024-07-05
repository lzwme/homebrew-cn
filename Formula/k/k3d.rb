class K3d < Formula
  desc "Little helper to run CNCF's k3s in Docker"
  homepage "https:k3d.io"
  url "https:github.comk3d-iok3darchiverefstagsv5.7.0.tar.gz"
  sha256 "f608bcb487b39aa39b8b075c0c998e6abbc6dd3be74fd354b70e1991f5aa591c"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aeb15d75a95d39f8008f38701c99e271e52e6fe1299fc6c32ffe2b9cb7f8cbe8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7fb12c9a97bae9f954cf1e5babd9dd61bf4ddf4822f9423af9f1786077593ead"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42623b00c7b5838d654ac77387e0afca3ccbbc81488523310a4d84bf8e494d25"
    sha256 cellar: :any_skip_relocation, sonoma:         "0ee306c8944b9049911af2c7337923eba76f2d386dcfece20dbdfc29711e6430"
    sha256 cellar: :any_skip_relocation, ventura:        "102569b81e0ed6571a56a8f900e04d6df77cb5c31e619fd0f16449be03a756d6"
    sha256 cellar: :any_skip_relocation, monterey:       "e82fea34b472acc252c20408a70ceeb87dc6d45600fc20d648fca412a03ae7d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "347ca916150108f59e7928778e33aff826f4e464729503a7b3ba75f7e7234e9e"
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