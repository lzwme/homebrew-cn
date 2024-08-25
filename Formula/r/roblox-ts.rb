class RobloxTs < Formula
  desc "TypeScript-to-Luau Compiler for Roblox"
  homepage "https://roblox-ts.com/"
  url "https://registry.npmjs.org/roblox-ts/-/roblox-ts-2.3.0.tgz"
  sha256 "3ae2ba96ec389eacf1d29cef2e825fae91b45aef1c395dfa1d023b7aa73f0f3f"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "4c48e8c7de899e5c1ea2f50bdc8d15b34498c66891008caec0af899f911e3e26"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/rbxtsc 2>&1", 1)
    assert_match "Unable to find tsconfig.json", output

    assert_match version.to_s, shell_output("#{bin}/rbxtsc --version")
  end
end