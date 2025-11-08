class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.44.tgz"
  sha256 "11f041b5af678e9b8e054821ce9b2158d362d3231045c3312bbabd8641cbaefd"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "48b1928b8affedd2f251da4a5060a0f1a5c4d863561fffa0a4c9c573267aa8b1"
    sha256                               arm64_sequoia: "48b1928b8affedd2f251da4a5060a0f1a5c4d863561fffa0a4c9c573267aa8b1"
    sha256                               arm64_sonoma:  "48b1928b8affedd2f251da4a5060a0f1a5c4d863561fffa0a4c9c573267aa8b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "16da5766d9b0606028c93246f621ec949b8d2190312e7365a9eb647985004bbd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2760bfbb9c7c5cc9b5656b8c9deef60be91c7222211dca54d4cb57b7e5d7025"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76e571e6f8fd5126db17b00613d50d9c7c014f9c5b30abe7a2e31e21e5e51aa5"
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