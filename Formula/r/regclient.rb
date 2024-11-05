class Regclient < Formula
  desc "Docker and OCI Registry Client in Go and tooling using those libraries"
  homepage "https:github.comregclientregclient"
  url "https:github.comregclientregclientarchiverefstagsv0.7.2.tar.gz"
  sha256 "eb8b3253b6fbb95032386cdd05c6fe9ada723c0aa9971c47190e5e967b46e754"
  license "Apache-2.0"
  head "https:github.comregclientregclient.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "efc75b0e3422221ed96a2e0d0f78bdbb665669b8c0d200f215b8195e75a93085"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "efc75b0e3422221ed96a2e0d0f78bdbb665669b8c0d200f215b8195e75a93085"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "efc75b0e3422221ed96a2e0d0f78bdbb665669b8c0d200f215b8195e75a93085"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b94e6e43abe500432c18bed82e454bc37e65e2bb52865abbe4f8fe8b2c9d69c"
    sha256 cellar: :any_skip_relocation, ventura:       "0b94e6e43abe500432c18bed82e454bc37e65e2bb52865abbe4f8fe8b2c9d69c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "067440dea43634f6caabc9937e97cb4e81d611c6be33206fbc6c6c5518303583"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comregclientregclientinternalversion.vcsTag=#{version}"
    ["regbot", "regctl", "regsync"].each do |f|
      system "go", "build", *std_go_args(ldflags:, output: binf), ".cmd#{f}"

      generate_completions_from_executable(binf, "completion", base_name: f)
    end
  end

  test do
    output = shell_output("#{bin}regctl image manifest docker.iolibraryalpine:latest")
    assert_match "applicationvnd.docker.distribution.manifest.list.v2+json", output

    assert_match version.to_s, shell_output("#{bin}regbot version")
    assert_match version.to_s, shell_output("#{bin}regctl version")
    assert_match version.to_s, shell_output("#{bin}regsync version")
  end
end