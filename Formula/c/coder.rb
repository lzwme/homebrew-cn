class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://ghfast.top/https://github.com/coder/coder/archive/refs/tags/v2.28.9.tar.gz"
  sha256 "45d952255cdab8a5de0133909cb3983754b7917cef2131f3d6173128ac46f7d0"
  license "AGPL-3.0-only"
  head "https://github.com/coder/coder.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d51b396afddb635d62e76fa3656a1576976801645292b88b0323301864aec599"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11969e0581404b45e3bed05cbaba93655d05c23a866a268073dc2933bd8823a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c56105d46e58373a5e4a3f629e4b442e9960ac7772693cf0c516548980f69564"
    sha256 cellar: :any_skip_relocation, sonoma:        "399deef29f4ed5fbc3b75043ad14d377921f4e4d3ae7175f5119213629921f3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e93385b164d9533529d42101482c0b1e659f8f0ba6e54f3c68c187954b3624c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f054c4796d515c480c9ff37970f40c3ea01d55249b3a9e366eb7391c6349c743"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/coder/coder/v2/buildinfo.tag=#{version}
      -X github.com/coder/coder/v2/buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "slim"), "./cmd/coder"
  end

  test do
    version_output = shell_output("#{bin}/coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}/coder netcheck 2>&1", 1)
  end
end