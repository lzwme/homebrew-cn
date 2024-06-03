class NodeBuild < Formula
  desc "Install NodeJS versions"
  homepage "https://github.com/nodenv/node-build"
  url "https://github.com/nodenv/node-build/archive/refs/tags/v5.2.0.tar.gz"
  sha256 "b5483c5ec5548abdeb991f3f098350671a1e0a196798a41ccc9e522c997b22db"
  license "MIT"
  head "https://github.com/nodenv/node-build.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "402dc7d3e177087d7864342803d85601a46f4bd1065e943880d4dea4baf6aa74"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "402dc7d3e177087d7864342803d85601a46f4bd1065e943880d4dea4baf6aa74"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "402dc7d3e177087d7864342803d85601a46f4bd1065e943880d4dea4baf6aa74"
    sha256 cellar: :any_skip_relocation, sonoma:         "402dc7d3e177087d7864342803d85601a46f4bd1065e943880d4dea4baf6aa74"
    sha256 cellar: :any_skip_relocation, ventura:        "402dc7d3e177087d7864342803d85601a46f4bd1065e943880d4dea4baf6aa74"
    sha256 cellar: :any_skip_relocation, monterey:       "402dc7d3e177087d7864342803d85601a46f4bd1065e943880d4dea4baf6aa74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7008dc8a5267a8d78b8b5f5869847ee722ccabecf9b3fe50083123bc1850581e"
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