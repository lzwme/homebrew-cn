class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-42.8.0.tgz"
  sha256 "b30493f6451b1db49ee9e0b7aff0bceb58ec4b7a56e1f4a68e349db032a3cb07"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "15e5468d07bad542b8b387f61ae9d65f87ccb74da63becc31a280ba3b2be6674"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d96c9bbe5544c2c606953681224d58565cd8ce844de5a76e97856759b25e9ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9cb845037c410ea8f80457ed33cf337fce3f63ebdb5a7ca8aef824636fa583dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "3102573c2ea2f99b96a405cfddd6e94afb936608326453a3868c66bc5fbcdc59"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7986e7366a8ee6fd42806baf9c5decec4c4a0591bfc0e7291dde808a9eef0df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "467598a1941f407090bff87b0e78787ad33cd77e012f4146d858bfa2d1a11bce"
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