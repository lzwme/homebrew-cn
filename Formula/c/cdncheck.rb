class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://ghfast.top/https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.2.22.tar.gz"
  sha256 "98a167bf7099e4750c21e14045919a138878f6f48a6ef0c067c598732d1b63b1"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ee46aaf7e442311a51dba9cc5f8a15b8d4b87e0e4348e38b89e0234e24e9df53"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cee551faa066e81657544d493e648dd42c02f28ffe786258b7f2252f87d2fb93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8671396571f53c2109ec49b697e839c587d2679521110636ff22a9f059b23a36"
    sha256 cellar: :any_skip_relocation, sonoma:        "2fa8a5588aefef6c247913b8dc9e4f1f4901a32ea4773c67f6298984706c0421"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3acda01206605744e6a7ba329b37917edea078397159af16715e729df622da0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1a45eb9e309c8c0385412a1345be87fbb550100db6ee5f644edada525989129"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cdncheck -version 2>&1")

    assert_match "Found result: 1", shell_output("#{bin}/cdncheck -i 173.245.48.12/32 2>&1")
  end
end