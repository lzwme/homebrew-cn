class Kubo < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://docs.ipfs.tech/how-to/command-line-quick-start/"
  url "https://ghfast.top/https://github.com/ipfs/kubo/releases/download/v0.43.1/kubo-source.tar.gz"
  sha256 "470f90d551f34ff65b533299e8f55ed3d2f2d062fd15c998ea53d095bac3ed26"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9f09108941ec17295e9f8fd21e3c92aee0731c6574b3d0a2a1bbec99bced7a6a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "605f2cd4ce9f1faf43fcff8f499caec18fbb591702b22f53ce5343fb8ee0f300"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "20f33a3a0693e4b54ad7b0a9f51cdbd977eb40a8547e733801bc88f04e62ecc2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a8d650d217b4226f97e1ee582be9630f37f2a7769093c8c14995dd63a5be8b44"
    sha256 cellar: :any,                 x86_64_linux:      "b08fc046d2b512e44ae90b29768460d5ced944bee74280cd77fef8c8d4aae47c"
  end

  # TODO: unpin go@1.26 when kubo supports go 1.27
  depends_on "go@1.26" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/ipfs/kubo.CurrentCommit=#{tap.user}"
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