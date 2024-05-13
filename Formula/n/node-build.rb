class NodeBuild < Formula
  desc "Install NodeJS versions"
  homepage "https://github.com/nodenv/node-build"
  url "https://github.com/nodenv/node-build/archive/refs/tags/v4.9.148.tar.gz"
  sha256 "895b48a7afe10c8cb243f5a064fd89af6a09b1d0b3873274cee0224d7d1a6b20"
  license "MIT"
  head "https://github.com/nodenv/node-build.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "12bdbc2bce0422891795e45bb32dea5e2f2e417c38e5da1d2a5020499eb774db"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b0f6c782319b5ed82657586b028580814be7d144bdf4941b5de01538c4f5b842"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cdd1c4e336f8d6a990049c80776456f4bedbd1c7d94ddfaa7128a0bbbfeef841"
    sha256 cellar: :any_skip_relocation, sonoma:         "0271e30709eb8ce4cd45301d5267898a859955c44b173cc39fabcef7bb28f8f2"
    sha256 cellar: :any_skip_relocation, ventura:        "3b54b37f0922f4f1a204e0244dfb95bc26c6935691f6ea23c229ae8ed2d86e6d"
    sha256 cellar: :any_skip_relocation, monterey:       "6a1bd01d5aea1d434d56d1b56bd6e367d190002ebebb7afb8b1c8b928b5774cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23b28eaa4aa4cb311ffe3b322d8dfb5052b4730fda220a1094d7873fe2cdf362"
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