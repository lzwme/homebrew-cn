class Countdown < Formula
  desc "Terminal countdown timer"
  homepage "https://github.com/antonmedv/countdown"
  url "https://ghproxy.com/https://github.com/antonmedv/countdown/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "a7b037988a4602196bffaa2cae0fa7d03b27197ccc1c6f96d258777472b76d87"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9392e145b4c081d92bf9720b026cc567a3e786a017f6dcc906cfbcd4b5fc69d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9392e145b4c081d92bf9720b026cc567a3e786a017f6dcc906cfbcd4b5fc69d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9392e145b4c081d92bf9720b026cc567a3e786a017f6dcc906cfbcd4b5fc69d8"
    sha256 cellar: :any_skip_relocation, ventura:        "a25dc9e917876f4ce2afe1b7284a91cac135f6f17364bba1bc724234e6e99daa"
    sha256 cellar: :any_skip_relocation, monterey:       "a25dc9e917876f4ce2afe1b7284a91cac135f6f17364bba1bc724234e6e99daa"
    sha256 cellar: :any_skip_relocation, big_sur:        "a25dc9e917876f4ce2afe1b7284a91cac135f6f17364bba1bc724234e6e99daa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a11d3a722a0676cbfd8f37df645d881b2783eb666f53445cc202ac8c859e0955"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    pipe_output bin/"countdown", "0m0s"
  end
end