class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.71.0.tgz"
  sha256 "e0db30e360fe84820a2df980856f765bf5f2a85d40217d662fd75bd9f71a0ccc"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e76e40df59188b90ec102b4d877f071ac1b96a5d8bc37b10570cdfd6be11ae46"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c11f74cecd378ad5a258307e8313f70613bc606b85ee4aa4be5f60ff89488d00"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "acbf694b2b0db50f8dbc137306b8636c3a9e2ef82b984044e35ee9df77b9f757"
    sha256 cellar: :any_skip_relocation, sonoma:         "a7ab82e7f7e630022421618921d464d5efca5cbc68288566c8f2d8343bb374c5"
    sha256 cellar: :any_skip_relocation, ventura:        "20f3a13407d008d97080e5e92a726f79ce640b3ff4923e1c9ec2aaea28d9e610"
    sha256 cellar: :any_skip_relocation, monterey:       "2bd8dc7d3a041b6cda96a70530a1b911dd70d826e833f1099576cb6dd75ce61b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3d3d713074e710cfe34a8dd111b84d0c77f50cbe654d1739d0af400d96da00c"
  end

  depends_on "node@20"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    system bin"renovate", "--platform=local", "--enabled=false"
  end
end