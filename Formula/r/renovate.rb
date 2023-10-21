require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.31.0.tgz"
  sha256 "f4e8341d196a3fc95b1f45ae83fda6b5ab12a57f8d1522ba87ba4e6b4edf9dee"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and page the `Npm` strategy
  # checks is several MB in size and can time out before the request resolves.
  # This checks the "latest" release, which doesn't have the same issues.
  livecheck do
    url "https://registry.npmjs.org/renovate/latest"
    regex(/v?(\d+(?:\.\d+)+)/i)
    strategy :json do |json, regex|
      json["version"]&.scan(regex) { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "10411a8517980f591a29bcc288c3bc04e19da3cbe2a912c4b0644f9820c9a618"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4cceb67c740e61e7157c7ca2a3b83d12c8729258841ed32f551b77b885763db1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ddfe2cbc47224d255bab20a0f4e812f1b6688e1b257d807b14bb552e0f88be1"
    sha256 cellar: :any_skip_relocation, sonoma:         "f15a0f500421cfc77a12c18f1c9c051bf446c2517165e3547fb1819d58018661"
    sha256 cellar: :any_skip_relocation, ventura:        "63fc279eec826b45cfa3ac3c0432227439408174c73495a7ad1b8c62f9ad2fce"
    sha256 cellar: :any_skip_relocation, monterey:       "3bf3b4f8ce367a692cbadfe250ec670528cf7cb05d1801f66bab4a69795c594a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a21e366d5601fb06126a8ce8deefb5ea306abed7a2b6a4e7be10576f600e5932"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}/renovate 2>&1", 1)
  end
end