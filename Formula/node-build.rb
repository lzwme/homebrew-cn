class NodeBuild < Formula
  desc "Install NodeJS versions"
  homepage "https://github.com/nodenv/node-build"
  url "https://github.com/nodenv/node-build/archive/v4.9.119.tar.gz"
  sha256 "fe319aa93412c3f41ebc4acfbaffe19b0cd8417d94c3c52bb3cba58cfcac5cb3"
  license "MIT"
  head "https://github.com/nodenv/node-build.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e81bcf30ecbdaf63aca5a428104167d506bcb670c3251454eee825f82d3e33a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e81bcf30ecbdaf63aca5a428104167d506bcb670c3251454eee825f82d3e33a6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e81bcf30ecbdaf63aca5a428104167d506bcb670c3251454eee825f82d3e33a6"
    sha256 cellar: :any_skip_relocation, ventura:        "e81bcf30ecbdaf63aca5a428104167d506bcb670c3251454eee825f82d3e33a6"
    sha256 cellar: :any_skip_relocation, monterey:       "e81bcf30ecbdaf63aca5a428104167d506bcb670c3251454eee825f82d3e33a6"
    sha256 cellar: :any_skip_relocation, big_sur:        "e81bcf30ecbdaf63aca5a428104167d506bcb670c3251454eee825f82d3e33a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4f460b87c0762e26dbf0f74ce87091f5a7264e25847a3251e50fe4114d365a0"
  end

  depends_on "autoconf"
  depends_on "openssl@3"
  depends_on "pkg-config"

  def install
    ENV["PREFIX"] = prefix
    system "./install.sh"
  end

  test do
    system "#{bin}/node-build", "--definitions"
  end
end