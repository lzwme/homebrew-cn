class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.34.0.tgz"
  sha256 "549827fdc059aea4ffce08778f0c55fea50ad7465c065dd2033a1a561542ce9f"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and the page the `Npm`
  # strategy checks is several MB in size and can time out before the request
  # resolves. This checks the first page of tags on GitHub (to minimize data
  # transfer).
  livecheck do
    url "https:github.comrenovatebotrenovatetags"
    regex(%r{href=["']?[^"' >]*?tagv?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "91e19261106b6845dbe4b14bd6ef67106f84ed630ee4e86061819b3355da7f2c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "163d33a1e68b33a42059520e92b72dc8d2f6c7eda4fc9e26ef0fe03a222c858f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f13c2c2586c33255b71d1b4b9b982e52273f065b252acd5e703d6c09aa4cee2f"
    sha256 cellar: :any_skip_relocation, sonoma:         "b677a31b439405326fd00d7b5fb0b6b308ed2d08ce86068c5adeb83d20400440"
    sha256 cellar: :any_skip_relocation, ventura:        "1a3d07a22fe87df536efb4929902cf15e20994c49a3e35b7808843837c05a726"
    sha256 cellar: :any_skip_relocation, monterey:       "902612089c785f4e201f8d75c888e4318ff83909293e655018fa955027f1ee9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2185eb06c54ba89281a9a996f42066973f0d3f5e993e8611b56849b6970cc24b"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}renovate 2>&1", 1)
  end
end