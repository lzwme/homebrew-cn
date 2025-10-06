class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-0.14.3.tgz"
  sha256 "79e22652542054e1db6697279cc058e3b298a1901780f944dd4d95639de20664"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "8894db7e5c6b977872bcf692d9c44916fe119b0d79d07e17788ec3dd1bc09570"
    sha256                               arm64_sequoia: "8894db7e5c6b977872bcf692d9c44916fe119b0d79d07e17788ec3dd1bc09570"
    sha256                               arm64_sonoma:  "8894db7e5c6b977872bcf692d9c44916fe119b0d79d07e17788ec3dd1bc09570"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7b429fe47041f67cdf4d76f9d3068630f32d92fac39fee2a4c30b7966e86a98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20ddb955a85f59be712d36316a37a20971ad3ad54ab5071371576b8834a2f78d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a366894f00d58d4f5d48ccbf7f154f482ba8f0186923d518d9cf6cf1c7d92e4a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end