class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-2.4.1.tgz"
  sha256 "bd8b3ad23c587824725d6dd3a4ad8f78b23dc926f256b6206e490f7f468e8b3b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "90cfe5a77594b871ac72339bfe57c25dcb74297aac0ba764e63d0d1b900eed5b"
    sha256 cellar: :any,                 arm64_sonoma:  "90cfe5a77594b871ac72339bfe57c25dcb74297aac0ba764e63d0d1b900eed5b"
    sha256 cellar: :any,                 arm64_ventura: "90cfe5a77594b871ac72339bfe57c25dcb74297aac0ba764e63d0d1b900eed5b"
    sha256 cellar: :any,                 sonoma:        "9c2ec2cf2a06de9d9d3ff3d6622339c94c7a02b6e844e9a3c468b2b898e64881"
    sha256 cellar: :any,                 ventura:       "9c2ec2cf2a06de9d9d3ff3d6622339c94c7a02b6e844e9a3c468b2b898e64881"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59370ff82350e180bf3deb361fa87077eeefe52724416fabbdbb5fad3de2ffcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36d9ef7223122749bb67d979cd497b750435e844901d5c7f858462710298f28a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jsrepo --version")

    system bin/"jsrepo", "build"
    assert_match "\"categories\": []", (testpath/"jsrepo-manifest.json").read
  end
end