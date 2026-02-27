class Kubo < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://docs.ipfs.tech/how-to/command-line-quick-start/"
  url "https://ghfast.top/https://github.com/ipfs/kubo/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "0640c0721a9e34688a8c16d793818dbae4d27f94a83534806fd7c332d7cafed2"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a57ff83aa1fd88ff3e5653747e38907595ef3d835b851cb7b6abd7ef351ee8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef39f07a46dda4f31c9245d61969c33e29d7a351f132a866e1a2c2a8a4ab2f99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42dac9e9c97b2cc4f4ca8516dc4f30252496fd6e0e83099d94473f6917d96906"
    sha256 cellar: :any_skip_relocation, sonoma:        "847d1975c8eb3944bda94605f38788855abdf1fcb6eae0171aff976e67e0d3be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f7e36b3f3984a21054501b24f4434a0942e436f5a64e138bcab7799a8949205"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3aeac66fd695aa76cde284dbd6863e3f7ba7fc4999aa97eefbc2112c4f3bb5fd"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/ipfs/kubo.CurrentCommit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"ipfs"), "./cmd/ipfs"

    generate_completions_from_executable(bin/"ipfs", "commands", "completion")
  end

  service do
    run [opt_bin/"ipfs", "daemon"]
  end

  test do
    assert_match "initializing IPFS node", shell_output("#{bin}/ipfs init")
  end
end