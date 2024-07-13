class Regclient < Formula
  desc "Docker and OCI Registry Client in Go and tooling using those libraries"
  homepage "https:github.comregclientregclient"
  url "https:github.comregclientregclientarchiverefstagsv0.7.0.tar.gz"
  sha256 "66520c4283334732aeffde2d6a06da527695c60ce86af5aaefd3a7f1a6fb4481"
  license "Apache-2.0"
  head "https:github.comregclientregclient.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c4ceec1044313dd8f9ea0da84bfc7f15a301b4b06dc2cfda453fffef351d4aab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "829295940229ed1f48227dbea9d96b53813401625112bfd73be376e142a0dc95"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "789a93c561f54fe2e0d4e6f16cdb64c3a5da442e9bee6e53454767cb65992c10"
    sha256 cellar: :any_skip_relocation, sonoma:         "d7987cb3d9599a3718df9bde5e78a76ecb06bf77a7919da5ec9b45d71e0f9797"
    sha256 cellar: :any_skip_relocation, ventura:        "8bd6aa9b3c1fe868dfe27e700021fe5cdf61168e2b5c9d9ba3607cd3c4644eef"
    sha256 cellar: :any_skip_relocation, monterey:       "7fa96cb1e7bb998b527782ea151c878a8d31122b655bd607da8fd0b519f5670e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e807a78b8c998144b554601561c19ad949a9044f86b16d68d5119d98c035c4b"
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