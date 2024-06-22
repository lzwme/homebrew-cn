class NodeBuild < Formula
  desc "Install NodeJS versions"
  homepage "https://github.com/nodenv/node-build"
  url "https://github.com/nodenv/node-build/archive/refs/tags/v5.3.2.tar.gz"
  sha256 "4df3fa11ab85b6b65fab98891a2150cf8d4de59b1e36d5f3226e93354c1c035d"
  license "MIT"
  head "https://github.com/nodenv/node-build.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "50735c3541491e51ad134bce29fc3f39b7df6e5a4bbfb22d790084d8b713c0de"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "50735c3541491e51ad134bce29fc3f39b7df6e5a4bbfb22d790084d8b713c0de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50735c3541491e51ad134bce29fc3f39b7df6e5a4bbfb22d790084d8b713c0de"
    sha256 cellar: :any_skip_relocation, sonoma:         "50735c3541491e51ad134bce29fc3f39b7df6e5a4bbfb22d790084d8b713c0de"
    sha256 cellar: :any_skip_relocation, ventura:        "50735c3541491e51ad134bce29fc3f39b7df6e5a4bbfb22d790084d8b713c0de"
    sha256 cellar: :any_skip_relocation, monterey:       "50735c3541491e51ad134bce29fc3f39b7df6e5a4bbfb22d790084d8b713c0de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31d0eb02ce0342af34b2d3efcf783e7f289039a8b5d609bc1047166f9e99b70b"
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