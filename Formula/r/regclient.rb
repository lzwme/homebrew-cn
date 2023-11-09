class Regclient < Formula
  desc "Docker and OCI Registry Client in Go and tooling using those libraries"
  homepage "https://github.com/regclient/regclient"
  url "https://ghproxy.com/https://github.com/regclient/regclient/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "2ea493c3ed6fe24416e8174e0298886cc0c05155e7258365848b7566e807bc19"
  license "Apache-2.0"
  head "https://github.com/regclient/regclient.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b14db501827fb412909e8924c8fdc8166319e646d583339e93abe69d3271ee74"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e196258ef4885cfb22cf405e1f866213bdda8bd6735ded1a7bf75cd1e32b65ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58349cc8d95219efe8b60156b4f89016faa2a1840748530c4619c75a98da7c39"
    sha256 cellar: :any_skip_relocation, sonoma:         "7e0ac9b65ab90d09e73a41794a945704e8e84ea9ea2fee9d2e6a17628428d3e7"
    sha256 cellar: :any_skip_relocation, ventura:        "ec10d2f8aa37def225550f41ebf2aeaa9d99964f905708715db767fbc7d91892"
    sha256 cellar: :any_skip_relocation, monterey:       "b0e935b629928393a2685ccd3017d660f40a6fafede2a1f11dfec4889384990c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d92529090fce0a67cdd800d821505c3b750b5021fbe72c6a14d519ee1fa14cc2"
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