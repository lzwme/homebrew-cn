class Ipfs < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://ipfs.tech/"
  url "https://github.com/ipfs/kubo.git",
      tag:      "v0.24.0",
      revision: "e70db6531a88ee5e2ea36981281503848ceb85d3"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "349d3b5c81d43f0ec8b477bcde2f39334ace9884b631b566bdf3a40e601ca68b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f0640fea1bc223141054fc51eb90379b93c79feb78370486c002b4852c88e92d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca695a81f6332047055868d17b0192b72c143241095219721e09df3d8af1268e"
    sha256 cellar: :any_skip_relocation, sonoma:         "a7ee7d60bece96af2ddf0fc126d1097e5f3b29341a359e15bc46a2950cf2b4c8"
    sha256 cellar: :any_skip_relocation, ventura:        "4a41fcfdf688ad53bd9e63ea5f0b9dda7258bff7f0e23692f9f56a88578ed986"
    sha256 cellar: :any_skip_relocation, monterey:       "f53eb52fc9870dd12ea41a708c42e637344fe588b58c5044c0f1410ea5fa8cd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44b842d6930a0d173bc0ae9e9c05d7800251c77d451a497f0ea454c160e8ea59"
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