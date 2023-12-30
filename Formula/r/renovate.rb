require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.112.0.tgz"
  sha256 "0e0b24b5be0add451bfe6da08aacae72a7f9090abfca834966d6471537a54905"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and page the `Npm` strategy
  # checks is several MB in size and can time out before the request resolves.
  # This checks the "latest" release, which doesn't have the same issues.
  livecheck do
    url "https:registry.npmjs.orgrenovatelatest"
    regex(v?(\d+(?:\.\d+)+)i)
    strategy :json do |json, regex|
      json["version"]&.scan(regex) { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "83f37396eee7144b76914fdfd936cdaae84d118dadb4a117d0366f787ed5d6d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "88121a7ecd6e6e9c0cf2ea403c3f3690daafcf2c20178708c62886d1e6751181"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "673b182f94fd91b19c77bfbc3a1a579f982c48c8e42488ab736db86514e125df"
    sha256 cellar: :any_skip_relocation, sonoma:         "155ee9682e07819088b14d4d4dbddf7993b91d130c7f06ee4a62290c88cd0222"
    sha256 cellar: :any_skip_relocation, ventura:        "eb72b588b5cf568c649171eb0e3294fc4cd8bda0af839da553a81acf7fd319ee"
    sha256 cellar: :any_skip_relocation, monterey:       "349950ce1d8467db6a450f96319a3bb15b481bd45591d61b909abc9a107c293e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1194e91e2e4ba60bfee349625e4262b1fd500a5832a6fe0e33329dae759553a4"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}renovate 2>&1", 1)
  end
end