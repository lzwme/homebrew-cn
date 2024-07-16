class K3d < Formula
  desc "Little helper to run CNCF's k3s in Docker"
  homepage "https:k3d.io"
  url "https:github.comk3d-iok3darchiverefstagsv5.7.2.tar.gz"
  sha256 "981d5bd0707d9be1313ce35b2dd62d9b93815adb1480944aacd62696aed4af6b"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "12467a65740f97e0b5ad4a9ec6af61a8b6a579d9c96f8b1ce4d5b3c9a69412b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "772db7d3a69e662aea235bd3b2938a66d617ada4f62e1fc958804badba47f401"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3bb54834a53386dbebf5f90185828370989153d836e97795557a627dec2463eb"
    sha256 cellar: :any_skip_relocation, sonoma:         "ae51f4e2e746ed18fff58f8ab0d14d9adf76f0eab5e08e3044fd09103cb047a6"
    sha256 cellar: :any_skip_relocation, ventura:        "166016a5f98dab6bf19ad09f6c4cb886a22e01c1400d4411440df811140b73ef"
    sha256 cellar: :any_skip_relocation, monterey:       "27fda4b7b55c47c34104732a0549759688ca49c1700a7e6a956fce50bf217211"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db179c0d8ffac73cee3db242de8e72c4e0283ceadcb1e4f5d3cba4d03d86e6d5"
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