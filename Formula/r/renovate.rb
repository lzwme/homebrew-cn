class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.169.0.tgz"
  sha256 "ada1666a9e0111185331b998659025e206ee129c51e10e53df2225f74adec882"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and the page the `Npm`
  # strategy checks is several MB in size and can time out before the request
  # resolves. This checks the first page of tags on GitHub (to minimize data
  # transfer).
  livecheck do
    url "https://github.com/renovatebot/renovate/tags"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b5c887fb8d2ed0e3104d24c29487f864f9a0bed5fcf4e6a5f63ff666e93af86b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "adf3c32bebddb8743be970f0faf04fae622efd0cec46c6f1f2d8ed34e50c0c3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99c1916c963c72796c4ad5443299443697ebdbbb1407fe513dd83438db9a253b"
    sha256 cellar: :any_skip_relocation, sonoma:        "bbd5baa6f6a9793deb65b1917d2134445044b016db6c488988373c5704ce7742"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98cc1a11ef37b027e9ee9c46fcf3d389c8ba3c4b7d8c1b83d85cd275a362c142"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21fbbd991eec20cf6a8c8dafa9e59fa83535074c2f56dadb6f074c6cd81ad912"
  end

  depends_on "node@22"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"renovate", "--platform=local", "--enabled=false"
  end
end