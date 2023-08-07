require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.34.0.tgz"
  sha256 "e2cc7a810d9b06eff0c7eae3e2738c8a6d4e0bafca06de9a8ddba4f97b95d16e"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f71ff2000a975f31d5eaa5a972eab4617cf18a0cd0916c60b04423dd140590de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bdf435d8ecf29bb8d18f5aa2d01011be9399eb1acec907fcb8fdbe0b784f4e01"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "58ed22167b6d04cd7b801526aca200da90aa0aedf392273799b5b8cb44d505c4"
    sha256 cellar: :any_skip_relocation, ventura:        "f6a4ff8efd00fe7b39f1a2840ef270ce32b56a4b32fcfe373c419b360a4970b5"
    sha256 cellar: :any_skip_relocation, monterey:       "0da3950b67116b98359626c06100269e1efd6667cec157d07ac435dc0b53f397"
    sha256 cellar: :any_skip_relocation, big_sur:        "0ba3c1a8ee13ae1bdd5440e69286761b4cd498d1a7c23bdc0aa911e880903fe7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "029d626d8f4eb1651f04d1c5a32e52ba74f00ab842cbe3b3e174367d61f4a328"
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