require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.131.0.tgz"
  sha256 "324d2cf0ba78a41465c1f5e78836dfca03a2ec4b746366aeb749b06a0957f360"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "68e78a3cc81f105e1f1cc1718afcb3cd4ac0d1b02e5d19c469344bf8bda8a05d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fffb126636fbb62d96f9d63d4f746010296c36a378bfdf5ce81e85a312405099"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "758ad2158735e1e72d6bbec7021de44fd0464726599389572915af4888172872"
    sha256 cellar: :any_skip_relocation, sonoma:         "6e58d2a08091ad4e0e68ab811db52375db7f7ef18a5a6ac33fc94c5d564b30f2"
    sha256 cellar: :any_skip_relocation, ventura:        "6b709da51955dad0017b0e9c88c59c86e9ac18929867c9bf1b0ba80996ec5eef"
    sha256 cellar: :any_skip_relocation, monterey:       "8a19c5ed892c8e4ce6e209c5ced7c5ea2fe62bd102b93b6d731d6bb4fc3e822a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20553a06114e91a2d7ef6a49c6dfcc6d2cc3c9a1a7373b7bed8303feb1334b5f"
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