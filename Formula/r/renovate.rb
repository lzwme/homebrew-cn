require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.54.0.tgz"
  sha256 "ce1a67fdf0b7514a134952dd8c754ec23174cc2ec788b0cce2ad68bd433dfe31"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74dde368343c8b25f13c8d01785682cc20791d817698c96ee4a21324fdbb04d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0f776c81ca10e52edcfd16a77d00516cd08264c2e4137b9c749090ba4a8db29"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8563c3d5d4c228274a0e772a9d1edde276f642c640c2bf4c6880d12b8c6cd21f"
    sha256 cellar: :any_skip_relocation, ventura:        "3738297bd7520b242be2d02ab9f109954d73a5d2ff1714586f9c74eb07079862"
    sha256 cellar: :any_skip_relocation, monterey:       "9694deab509958f29d89421cda88c0f1eb651d69b7604e5e67854d4873c024cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "58c11abbca317388d5c3a6fa4f1c2691b05f870faadabbe9ef0ec63f4794f8be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff03dc308214600f70c8968d7e5a9e8dccc7f47cbc8e7184b9f5d830174b85b4"
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