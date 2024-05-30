class NodeBuild < Formula
  desc "Install NodeJS versions"
  homepage "https://github.com/nodenv/node-build"
  url "https://github.com/nodenv/node-build/archive/refs/tags/v5.0.2.tar.gz"
  sha256 "cbf51858c3222b2b83fbed128893814cee456ab26a663648e42e43e1074a7af1"
  license "MIT"
  head "https://github.com/nodenv/node-build.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b8fb75fded686ae8a3a7f2bc3fa7c4df07545495cae9b76ce526d9c0d9c71cac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b8fb75fded686ae8a3a7f2bc3fa7c4df07545495cae9b76ce526d9c0d9c71cac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8fb75fded686ae8a3a7f2bc3fa7c4df07545495cae9b76ce526d9c0d9c71cac"
    sha256 cellar: :any_skip_relocation, sonoma:         "5f9882984eb3b7a45b26033a8f8db9937a3d8ae91183abaa2eafd0b3359b557b"
    sha256 cellar: :any_skip_relocation, ventura:        "5f9882984eb3b7a45b26033a8f8db9937a3d8ae91183abaa2eafd0b3359b557b"
    sha256 cellar: :any_skip_relocation, monterey:       "5f9882984eb3b7a45b26033a8f8db9937a3d8ae91183abaa2eafd0b3359b557b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82db7bbf5cb7223754af7927aafa5f13da7fa4c2520cba55401e3e3d14439611"
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