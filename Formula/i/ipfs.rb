class Ipfs < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https:ipfs.tech"
  url "https:github.comipfskuboarchiverefstagsv0.33.2.tar.gz"
  sha256 "0dcab7d932a7c613fe0421ba1a5a0c71138709c151610f57666a15d163c982b2"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d8402630fe2e3525db8d312c948f517dbe53bea144b820edc395af7335e04c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f78d388fc0212cf8ae3312810ffd4791c9e21de5abb36bdf3da41e8b1833362"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "023544a2e99ea0fbb51fafc223ae7f118e4e9416bf36efc00e6dda8c6fcbc0ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "299dde4379e501d00353e2848c8b85800b513bfcc3e105b54c6fb8ef4e3586db"
    sha256 cellar: :any_skip_relocation, ventura:       "ff9825ca14eaa62e0c24c0c17acb0db345e22d9c752666c96fe4e9a0b33d3235"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3bad6f1dd371c42957eebd2aaa9edd91edec4cb37e70236558888ba2a705e1ca"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comipfskubo.CurrentCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdipfs"

    generate_completions_from_executable(bin"ipfs", "commands", "completion")
  end

  service do
    run [opt_bin"ipfs", "daemon"]
  end

  test do
    assert_match "initializing IPFS node", shell_output("#{bin}ipfs init")
  end
end