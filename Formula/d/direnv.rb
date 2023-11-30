class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://ghproxy.com/https://github.com/direnv/direnv/archive/refs/tags/v2.33.0.tar.gz"
  sha256 "8ef18051aa6bdcd6b59f04f02acdd0b78849b8ddbdbd372d4957af7889c903ea"
  license "MIT"
  head "https://github.com/direnv/direnv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d2462d29201f40e3853f26b8c15b29ea52a00243f3f9f79ae53133765ee0705a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e37b11fc5c949733d0e9079dcd17d5598470bca6af190c47cf9e869f07f275b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b37836d26591533e50dbbeee156b452b97112f9ccbc74c2f096a8231184b4a87"
    sha256 cellar: :any_skip_relocation, sonoma:         "06a78fd113bf7ea455ad85634557c3d4b495007ad84cc41b0ae52f2bdcc456cf"
    sha256 cellar: :any_skip_relocation, ventura:        "1a6f00f9700aa772920191f73d4bdbb280a5fded43f1f0285f50d1886ff96164"
    sha256 cellar: :any_skip_relocation, monterey:       "692223528502596606e66fc9ebd64694a16745416619962824a1eb70e99c570d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53335b6c365d3b35cfeea061b7f314eb47aef731fe82cb9560d04c0e5d30bf16"
  end

  depends_on "go" => :build

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"direnv", "status"
  end
end