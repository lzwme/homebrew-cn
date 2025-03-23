class ImmichGo < Formula
  desc "Alternative to the official immich-CLI command written in Go"
  homepage "https:github.comsimulotimmich-go"
  url "https:github.comsimulotimmich-goarchiverefstagsv0.25.0.tar.gz"
  sha256 "a4c819c96cb32f4534caec5c692477c9af95763fcebcf3fadcb5750226943c74"
  license "AGPL-3.0-only"
  head "https:github.comsimulotimmich-go.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c77df9af83ab818bc2d1bd4ff68b644ee6a3bab4e05349dd70aa8bb78ddac903"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8bd14807b207baad6d35980f175dfa99706955af9b594df3c691e02b60a34c31"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3b485e96622bb704bf3a4081eee029c6f5cfbc9ce91dc635cb0b813ed9f80da1"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a7335768b33fe45ad78a84f665822b9baf3400aad8cba369fc53e3b1a7f1cd7"
    sha256 cellar: :any_skip_relocation, ventura:       "84dc6781753a72c3647d5b64a97103f45c91f0b3fabb8310045613da93f3fac9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea0a3c7912ba02158e52365ac6848ea82d42b9526ac5e6683835550a8515da21"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comsimulotimmich-goapp.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"immich-go", "completion")
  end

  test do
    output = shell_output("#{bin}immich-go --server http:localhost --api-key test upload from-folder . 2>&1", 1)
    assert_match "Error: unexpected response to the immich's ping API at this address", output

    assert_match version.to_s, shell_output("#{bin}immich-go --version")
  end
end