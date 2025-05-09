class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-40.10.0.tgz"
  sha256 "24d4a423520a2e3fef97148a79292dc16bd3679bb3ab149eaa8b4fc366efb025"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fcead4b40bdebac34f6fb7f26e01a7847f194865521b41618ce3dd5b22b912b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55d58a4b1195e419330b5337be66ccce61f9003c2ab11c162e0416a08641c250"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3a59bfab73c8bc6c0de529e52f06816cb6ceda225305a8fbb7e7ea5e36336bf8"
    sha256 cellar: :any_skip_relocation, sonoma:        "e78d052d211e7d76e033d041d4a1be284bba50789b53885d54d53172c194d763"
    sha256 cellar: :any_skip_relocation, ventura:       "7891058a4a467c24208e230cc065d32b80df2d91d60c11139166facc9e6f37c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8de081c06bfb3e57552d0957875045743b60c703c9d0a405b034618a37e87f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cab83d5ddf91cebf4dbc3754756469fa9ba0245d78bd800b1ec704ff2a96d086"
  end

  depends_on "node@22"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    system bin"renovate", "--platform=local", "--enabled=false"
  end
end