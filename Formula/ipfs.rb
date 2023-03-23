class Ipfs < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://ipfs.tech/"
  url "https://github.com/ipfs/kubo.git",
      tag:      "v0.19.0",
      revision: "196321958696175e253aef856d9467aacdd6f987"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "27bbec672fe4f7acd569ff29d65b297668a0f6256d789c7449fe38c1f73829d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35506cda1574a3f0155389d8424fed2248ffea63d72cb162d8a13fe59971ebb5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c938cd9fac5a2febfef6430db1d2e49a627165196b7e30a84668cdf8f0c5a720"
    sha256 cellar: :any_skip_relocation, ventura:        "f64b3d47d679e621ef4a331a6d3c766839b8c3646d64ec3137046d15bd2d3c64"
    sha256 cellar: :any_skip_relocation, monterey:       "c9ef53f1398a6a7e727c1cb921281c107e314ed166b187bba11e449fc4d22b39"
    sha256 cellar: :any_skip_relocation, big_sur:        "52ad9121d18d93190b3e4f9c7207901ae08580ffa405877bf157cff20989c7d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fda2429466fef0ec31fe851402329399e012a0b5d09ad2bfaa88d03ca2e1a7ff"
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