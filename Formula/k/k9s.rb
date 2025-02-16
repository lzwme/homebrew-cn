class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https:k9scli.io"
  url "https:github.comderailedk9s.git",
      tag:      "v0.40.0",
      revision: "35c2b6c509a3c4cb0d6aabc94e4c13eb53ef740d"
  license "Apache-2.0"
  head "https:github.comderailedk9s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9aae1c7dac4a84c796dd6a07e10a115296b24d8d50e2a777aba93b83ea529b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02516b9ff56056c22dbaed2fe52fe2ec8d901435f61f61f4ca96aab0c0a78a10"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c0150bd6586ffe925d4f141c9078e953b5f0b442c3dd5f616f09148992f3e31a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e20caa6e8d2b3e0d596bd728e3ce5223721ad9abd7b8388ba78779af66915940"
    sha256 cellar: :any_skip_relocation, ventura:       "b7c80481f394a7fcb60b67edcdc7e4e2119700fabbb4d9a1bb2415594e6bd5ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0b88c0cdef467198a26cb7b52a91ee0ce0755eb699c64cf7f0cb59a32797608"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comderailedk9scmd.version=#{version}
      -X github.comderailedk9scmd.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"k9s", "completion")
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}k9s --help")
  end
end