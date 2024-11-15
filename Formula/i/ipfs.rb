class Ipfs < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https:ipfs.tech"
  url "https:github.comipfskubo.git",
      tag:      "v0.32.0",
      revision: "ad1055c1aa9b293ae951e3a29f0b06a90af843f4"
  license all_of: [
    "MIT",
    any_of: ["MIT", "Apache-2.0"],
  ]
  head "https:github.comipfskubo.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "957900ead07b73c4d7be48349e00c1114931fa0df42c4810c30c06f5d11a7607"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5d7a77f61999d11a3a592852437713aacddd924be96f31abf34358378babc49"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c28ddad2704d61bc2fb15006ece14b21f4b7a680bc72b0d5b219a548efbe12dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "813616dd99ad19fb4ae8664cbc8c4809543286adf34cee446e12e1a18a7ce4f1"
    sha256 cellar: :any_skip_relocation, ventura:       "714bd054d2690822dfb4d8580413c7e310c490e23910e669c4016da524ccc66e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b729fc05397210620f9dcfb890dad9909add702eae8a0b6f12dc21c355f87118"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "cmdipfsipfs"

    generate_completions_from_executable(bin"ipfs", "commands", "completion", shells: [:bash])
  end

  service do
    run [opt_bin"ipfs", "daemon"]
  end

  test do
    assert_match "initializing IPFS node", shell_output(bin"ipfs init")
  end
end