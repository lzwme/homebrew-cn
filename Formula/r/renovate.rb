class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.83.0.tgz"
  sha256 "1cfc1969334b288564739c9f9683919f26c114250c8156d62c99f9792117c188"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "898c44878d80c407df5cd7340f60dbb39b58a21616ea4ba9c1d6f490dd1028e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56de58a0b1b7b108bc5a664fa8a95999ff680699ba1c139292b8d28687140a05"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4df4b84ff1147c10a8fa4b63ad235722f57b25acc1b086502794af5fcf719e66"
    sha256 cellar: :any_skip_relocation, sonoma:        "dac6e0552a21e547195caf73d1841b8f4a99b6c7a0a61ca4b0d6af9c567c6070"
    sha256 cellar: :any_skip_relocation, ventura:       "ce712dd1a961bde606f7305119d868d2aa03789733d7012833d9619c1d438934"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "058a5efc37a959a4ed96d5de4fddf280520938be8a234e4336dac61757f85240"
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