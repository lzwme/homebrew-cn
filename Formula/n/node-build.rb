class NodeBuild < Formula
  desc "Install NodeJS versions"
  homepage "https://github.com/nodenv/node-build"
  url "https://github.com/nodenv/node-build/archive/refs/tags/v4.9.150.tar.gz"
  sha256 "ffde33b4d6f57f9b821fbc2b7cc39f70d5ee4b408f2c5a226c26416d4cf644d5"
  license "MIT"
  head "https://github.com/nodenv/node-build.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b5f7e902a6063f110a3e203feb76e4c9af110bda0249db5e9fcb371d1f4b21a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0c05ec614a43025cb17cfcb715798767ee5ed8d9bbb9eaf0ec8af193e6e10289"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7e2894f2d3f78ac88d3a5f1fc8bbfc64351ab248c2b1fab31deebdec4fe03e3"
    sha256 cellar: :any_skip_relocation, sonoma:         "51da16922fcaf100fb3da26ab53d26e5dc560c970b864099d5d39fff1aa1cc35"
    sha256 cellar: :any_skip_relocation, ventura:        "1287d28e84752e1fa414cb8d368a5ffe9608e003a102fef540769d2d3573302c"
    sha256 cellar: :any_skip_relocation, monterey:       "3c8861b61c0c5475b43c274c8bacc0d68854a6d3259069b317692b56f11c7459"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0f53bb87de5147a9d31078e820b87678499143e96d6004f03517fa4b4ac181b"
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