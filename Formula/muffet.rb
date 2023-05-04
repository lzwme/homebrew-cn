class Muffet < Formula
  desc "Fast website link checker in Go"
  homepage "https://github.com/raviqqe/muffet"
  url "https://ghproxy.com/https://github.com/raviqqe/muffet/archive/v2.8.0.tar.gz"
  sha256 "70e95dc6005f9ac9c4f064074641a12b9215746976e5c0a16a581e7365577ae3"
  license "MIT"
  head "https://github.com/raviqqe/muffet.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8dcaba91e3603093e135610ce5b78f54aad45f8aeb90ad21333ec8c552fb2800"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8dcaba91e3603093e135610ce5b78f54aad45f8aeb90ad21333ec8c552fb2800"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8dcaba91e3603093e135610ce5b78f54aad45f8aeb90ad21333ec8c552fb2800"
    sha256 cellar: :any_skip_relocation, ventura:        "218b7408a293d3840646345212f5a7c7184226543fe96422e18ea874d3790f41"
    sha256 cellar: :any_skip_relocation, monterey:       "218b7408a293d3840646345212f5a7c7184226543fe96422e18ea874d3790f41"
    sha256 cellar: :any_skip_relocation, big_sur:        "218b7408a293d3840646345212f5a7c7184226543fe96422e18ea874d3790f41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8180932d42318d0cd0018f8ca3b52b4077748dcae3c20accb519510e1ec8746f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match(/failed to fetch root page: lookup does\.not\.exist.*: no such host/,
                 shell_output("#{bin}/muffet https://does.not.exist 2>&1", 1))

    assert_match "https://httpbin.org/",
                 shell_output("#{bin}/muffet https://httpbin.org 2>&1", 1)
  end
end