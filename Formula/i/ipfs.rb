class Ipfs < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https:ipfs.tech"
  url "https:github.comipfskuboarchiverefstagsv0.33.0.tar.gz"
  sha256 "f58da2d4e8552b0d76c95715ec86bf868216fdd539669ea060827a527458cc5f"
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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0cba91012fdd5851f5cf19272b0e2dfd3cfa8c00ad4e064811edc63ccd48c6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e97d3b417066f176dba54774b161459191e78758b484936c7e80399827dc502"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a66f4eb5d588fdbbe2a934fdd12bcb78be95ce38c9bd25f138f93e066726a622"
    sha256 cellar: :any_skip_relocation, sonoma:        "df5963b38d0ccfa2d6e88b487f0fec4523b099776a06deefc50a4eda78187600"
    sha256 cellar: :any_skip_relocation, ventura:       "52f1c4f80e03d426e6840fe8683b16b0944e7eeac1817317076e8a30753825eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a14fd5610a22fbadc9fca0d76f844e3a87166919297ae7031681a8db0ca99028"
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