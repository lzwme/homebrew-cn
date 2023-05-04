class Ipfs < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://ipfs.tech/"
  url "https://github.com/ipfs/kubo.git",
      tag:      "v0.19.2",
      revision: "afb27ca17433bbf278fc7939c3d58ec2e8804e92"
  license all_of: [
    "MIT",
    any_of: ["MIT", "Apache-2.0"],
  ]
  head "https://github.com/ipfs/kubo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d198638fcaf47c4f2d37ce90544f9570ce775b859aa42bf06786e0f051b400d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85e13d3cc09d6f9e2e6cdcfa0ce0cff4f8e37f5b7cf56010215a989d3cf2e4e8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a2f9677bcfcd07111da0e549f9a2c650163abf5cfcf56b5526fbb77876f49eca"
    sha256 cellar: :any_skip_relocation, ventura:        "796d36e5e90fccd1bb0ab804c3d464341eb3e2177d46e89c446282fd04fb7888"
    sha256 cellar: :any_skip_relocation, monterey:       "2b828139bc964949341bf037487f800542229fdd38a0aafe0a9cde2a00eb4327"
    sha256 cellar: :any_skip_relocation, big_sur:        "e9f041ef9937b96ee4686990ba2c8c21be1c989fa6d34c2c8a3ada77ec8908fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d919e4faec64d7dcfec674a82c3eddea29fac3434c65614f139a9dc7faf962a"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "cmd/ipfs/ipfs"

    generate_completions_from_executable(bin/"ipfs", "commands", "completion", shells: [:bash])
  end

  service do
    run [opt_bin/"ipfs", "daemon"]
  end

  test do
    assert_match "initializing IPFS node", shell_output(bin/"ipfs init")
  end
end