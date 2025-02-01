class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.153.0.tgz"
  sha256 "f7bc39661c89730c870258a718226e8e88e6e04e9440ce2d75e79d51b0fce7a4"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de21de1cfa77fe32633cecae826e915d76a71cf849c28e646c552c0c69874fd5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d8d679d4e0fba019c686ff4a806b23838a140561b11fb4128ad793846366c72"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2f9aa2e58c69891b8d4bc6e1e8bc0ce5ffa16a5b6f5045312558e7df5807d2bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "95125920e6ca922ac93980419e198d9a4b462967c2cf352979f081a4c0c840ac"
    sha256 cellar: :any_skip_relocation, ventura:       "af3c9c80604a19c79acdb47f2090a6e3c09f4e9e59d08f7b3328375c49f57f28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "299335e57b0bc7aea87bf720b9b9fa997e5294fca3a8332e1db5d006eea6ae61"
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