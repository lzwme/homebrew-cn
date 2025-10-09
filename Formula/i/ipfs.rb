class Ipfs < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://docs.ipfs.tech/how-to/command-line-quick-start/"
  url "https://ghfast.top/https://github.com/ipfs/kubo/archive/refs/tags/v0.38.1.tar.gz"
  sha256 "d8f0133a9c49c7dff6df1e04633bc0757d1663982f3b6f4ea01d54381f643d5e"
  license all_of: [
    "MIT",
    any_of: ["MIT", "Apache-2.0"],
  ]
  head "https://github.com/ipfs/kubo.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b46f615ddad2f3d354b045dc15162da141acd157b762d48c7f25935eaafc034"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f08412a1fe66d9ff587ac9091aba5f5b4af25137a86f121c3702d7e090cc650"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4e21e688a40a28b8b464c823478a03698cfe273c4ba932f7d8f30866cd8d92c"
    sha256 cellar: :any_skip_relocation, sonoma:        "dcb3b1a50f66eb4cf5b0be4266b7800f3abf2f48cc7a0be2bd7ef96e3b7cadde"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50f6cf70532b7d444b30ddf80ed63ab21f041de1f2d8ae6a4088b325b398f667"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6612f6dafcfc0285566e996b8b35ce52528b37c7a14548b00bfb42bae25d80fc"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/ipfs/kubo.CurrentCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ipfs"

    generate_completions_from_executable(bin/"ipfs", "commands", "completion")
  end

  service do
    run [opt_bin/"ipfs", "daemon"]
  end

  test do
    assert_match "initializing IPFS node", shell_output("#{bin}/ipfs init")
  end
end