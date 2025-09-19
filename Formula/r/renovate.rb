class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.117.0.tgz"
  sha256 "8c80fc92a8e99606527d6ac55fe30e7934506a47f4ecdf6039b0c1d20f91d4f5"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "362797a683cf9071c0ab5412bb6fe8dbcd8929dc4191843bc9de04e49ed6436f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7161f9faa662c233db721f5b4407b488631c1eceb98c2dc8d7aa34ac4036ce3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f769ece5a1d1340ecc431e25f1b05c1921e75954a813e82ca2874d81dfe3ba3"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef4b8390c6a2fbd795d85243396e24e682b7f65bff7da42bda4dbe5d79f42c0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81c4910ceb22c53fc5c7ff5c3329ac601c08a94e5f3bd92be394f142e8f8ee37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0285196b0a4638f2c392ed1e20e0b1d11e1d7be03cc760b3588ff0eeb16bbd0"
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