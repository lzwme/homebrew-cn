class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-1.45.0.tgz"
  sha256 "d850da698f3da6a7ea62601c195407f4037b9a8e6e10921984d26013722bf29c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7a3392d223678e374165e4b039c1a0e78ab7e95d55b368820108ab08dc8e2c6e"
    sha256 cellar: :any,                 arm64_sonoma:  "7a3392d223678e374165e4b039c1a0e78ab7e95d55b368820108ab08dc8e2c6e"
    sha256 cellar: :any,                 arm64_ventura: "7a3392d223678e374165e4b039c1a0e78ab7e95d55b368820108ab08dc8e2c6e"
    sha256 cellar: :any,                 sonoma:        "2b76736c8fc594a12e2e350c68d476d34f3fef39a61b17ce8bf64966b8556d45"
    sha256 cellar: :any,                 ventura:       "2b76736c8fc594a12e2e350c68d476d34f3fef39a61b17ce8bf64966b8556d45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "759f037ed8fc2e3bfdaf384db72209a37098d54d0565ffa064fe8ed072d83dfb"
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