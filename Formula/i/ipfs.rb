class Ipfs < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https:docs.ipfs.techhow-tocommand-line-quick-start"
  url "https:github.comipfskuboarchiverefstagsv0.34.0.tar.gz"
  sha256 "0294057f8b6c1246773b17eabbbfe68d76073df9809d0eb3c19cf238c0175e0b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8317f25311e67877f662a2044bd432703645e9ab2372fd990f19724970b0e22d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da2886c935dda907ddb4842c2f2a4d10863a614b6dada22752aed515a8f6701a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3e9578300561388b99c5ad7df004c154ed6b65c71ee93cac68820376858dab12"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4c1e505832c8da0508cc371ddb16e32710e03b6e4c7713d82d79d7f1191a11b"
    sha256 cellar: :any_skip_relocation, ventura:       "41aa87a0984c910ea3e8fdbbb5523901cb3e9d15a9255a40cecab411c09fbfee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f19129b64d516a3a26aa2c4187177fa29f146a6b9ec3e6b081624982c7d3f11"
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