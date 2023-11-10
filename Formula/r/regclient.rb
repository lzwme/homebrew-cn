class Regclient < Formula
  desc "Docker and OCI Registry Client in Go and tooling using those libraries"
  homepage "https://github.com/regclient/regclient"
  url "https://ghproxy.com/https://github.com/regclient/regclient/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "55f5eca392ca2f9c1b7a55a4ae89de7d88c0bc18e4c2d29d38940f2a386abec6"
  license "Apache-2.0"
  head "https://github.com/regclient/regclient.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8d82da7b91b02bbbd0f968fd658a24be9c064531d6f7f3d53cbf5d0f94432b7e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea9839907af0e5da33385031074d4ec4a736b358ff3e5a27356aa27465c3b2c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b57d318d97b3152897bebc5fe54c802bfccbdd5efd3638c66a0233aa5e77baff"
    sha256 cellar: :any_skip_relocation, sonoma:         "f235eba58c76df837f6990ced3f78f8b91554b2567300e3887c37d97aacc48a8"
    sha256 cellar: :any_skip_relocation, ventura:        "07cc812358f7ea254697fdcb8c3cfeb3ca3d2af673a72ac5c746817239a67429"
    sha256 cellar: :any_skip_relocation, monterey:       "8e78dd2f15aaaea52ed53888969726af7a2b9da9d040a937ae75994a7491fc0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7063413369e58f910f8f5ba31e926e903c2aa3b5f44470927ee7d08819ea27ce"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/regclient/regclient/internal/version.vcsTag=#{version}"
    ["regbot", "regctl", "regsync"].each do |f|
      system "go", "build", *std_go_args(ldflags: ldflags, output: bin/f.to_s), "./cmd/#{f}"

      generate_completions_from_executable(bin/f.to_s, "completion")
    end
  end

  test do
    output = shell_output("#{bin}/regctl image manifest docker.io/library/alpine:latest")
    assert_match "application/vnd.docker.distribution.manifest.list.v2+json", output

    assert_match version.to_s, shell_output("#{bin}/regbot version")
    assert_match version.to_s, shell_output("#{bin}/regctl version")
    assert_match version.to_s, shell_output("#{bin}/regsync version")
  end
end