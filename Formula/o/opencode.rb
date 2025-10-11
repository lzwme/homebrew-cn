class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-0.14.7.tgz"
  sha256 "8a67628d6ff2bf2f054001122cef06da81750999ce4801ace88500569ed0d9ac"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "1a16fb3c72bdc19c470660eb4f9ba9e2cfeeae1acc3879fb2792e5623b1fbfe4"
    sha256                               arm64_sequoia: "1a16fb3c72bdc19c470660eb4f9ba9e2cfeeae1acc3879fb2792e5623b1fbfe4"
    sha256                               arm64_sonoma:  "1a16fb3c72bdc19c470660eb4f9ba9e2cfeeae1acc3879fb2792e5623b1fbfe4"
    sha256 cellar: :any_skip_relocation, sonoma:        "32aa2f7d3ceed421afa76b89231dfc2f8daf4212a841493b50e738ca3b5aec1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1391ed6de4ea12d8d9ba02b2fdb68d6f630d4fa3e937375e1407db8c6b8c25e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3ed97fe19a017dfd5d5403af6ab64602ce0030cbb0b46fd184abbd95f506a92"
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