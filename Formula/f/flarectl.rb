class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https:github.comcloudflarecloudflare-gotreemastercmdflarectl"
  url "https:github.comcloudflarecloudflare-goarchiverefstagsv0.108.0.tar.gz"
  sha256 "c543e40bae0e131130553e7776bb4b0a0c1a3f667f8765efd9e7c99e06f73c7e"
  license "BSD-3-Clause"
  head "https:github.comcloudflarecloudflare-go.git", branch: "master"

  livecheck do
    url :stable
    # track v0.x releases
    regex(^v?(0(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8539bb944b647ee4b60094df470ae12f4020b55d98187716542d5c15c49cdd7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8539bb944b647ee4b60094df470ae12f4020b55d98187716542d5c15c49cdd7f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8539bb944b647ee4b60094df470ae12f4020b55d98187716542d5c15c49cdd7f"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f117778c4a8b64d0c44e9e66e78f6aaca3c4ebeb1434adb32fd40e13d91e990"
    sha256 cellar: :any_skip_relocation, ventura:       "4f117778c4a8b64d0c44e9e66e78f6aaca3c4ebeb1434adb32fd40e13d91e990"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b034f38e96ba95071d7758c4f7dc045392c29748b0e96638fbb4c1aa832ec145"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdflarectl"
  end

  test do
    ENV["CF_API_TOKEN"] = "invalid"
    assert_match "Invalid request headers (6003)", shell_output("#{bin}flarectl u i", 1)
  end
end