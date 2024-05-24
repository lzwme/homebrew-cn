class NodeBuild < Formula
  desc "Install NodeJS versions"
  homepage "https://github.com/nodenv/node-build"
  url "https://github.com/nodenv/node-build/archive/refs/tags/v4.10.0.tar.gz"
  sha256 "c09591f99ebb00863881db2e73bc3990e0e5aad3f3f947664e91d1c15984ee0f"
  license "MIT"
  head "https://github.com/nodenv/node-build.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "608c00e350b1b3716bf9afae937ead57d671936fa6e21dc483e3e76639d17fff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "78ca9c7ff26b075b2125d1a772dc952bf431b01186e431d7ab8313f53962d01e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f7cddc4a2ecb6208ae427f8c2233311d23728afca5ad77f6acd1256800b923e"
    sha256 cellar: :any_skip_relocation, sonoma:         "4dd7386e54b2703fc00bccf30d4542ad4fdf5c9a0cf40a8097e5ba291586b8f0"
    sha256 cellar: :any_skip_relocation, ventura:        "97c52fd528a94eb25474e5df99090a48d7bde40f900d5ddf9399814031e16dd8"
    sha256 cellar: :any_skip_relocation, monterey:       "28734ab4d26a47cfdf8e23fbe2d44aae79e49a262e407cd256cb092ac8db72f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d96b17cba1823c1efaa89c2c59f3114d8d7882adc52f5757140b597837bae5f2"
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