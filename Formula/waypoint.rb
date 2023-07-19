class Waypoint < Formula
  desc "Tool to build, deploy, and release any application on any platform"
  homepage "https://www.waypointproject.io/"
  url "https://ghproxy.com/https://github.com/hashicorp/waypoint/archive/v0.11.3.tar.gz"
  sha256 "cd150448b0720e6b0009d38226c9736fba27c102d76820203f876f9715e69a2d"
  license "MPL-2.0"
  head "https://github.com/hashicorp/waypoint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ece073f61133592bbc9126cffabbdd82e283d5ee5e00683608e856717f3d4a85"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac709d96b55824af5ff625970cc86bef5f98d6f8e8b2cd4a7f57d0915a8a689a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d13a6270bb21a79316b54206df71bf8e7cf3916c0bebc275086ffcc73c78a505"
    sha256 cellar: :any_skip_relocation, ventura:        "74080a7a24b398b90d5754c569937296f1912530d071bbbbbc3408d011607442"
    sha256 cellar: :any_skip_relocation, monterey:       "488802106f5616a2d1539b5bf8f8b3deb3bc52cef0b35e08295fb0c0d7191a56"
    sha256 cellar: :any_skip_relocation, big_sur:        "e9a09531b1de65de58ec98cb86703afca7686e919238846c32578a3ae6a3b758"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f57fdf51ef8c6da96157ecb5ef2127342394fb16c56776136c74fad816c374c6"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
    system "make", "bin"
    bin.install "waypoint"
  end

  test do
    output = shell_output("#{bin}/waypoint context list")
    assert_match "No contexts. Create one with `waypoint context create`.", output

    assert_match "! failed to create client: no server connection configuration found",
      shell_output("#{bin}/waypoint server bootstrap 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/waypoint version")
  end
end