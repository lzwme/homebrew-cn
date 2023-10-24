require "language/node"

class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-1.23.2.tgz"
  sha256 "1cbe758a5ae54f10af8b4d76de9fb95bd779361d2d3c719484a24326d94833a7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1a4c795cebfcada5854211bf758dba888bd811675f0895a9dfb74e468706c3ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a4c795cebfcada5854211bf758dba888bd811675f0895a9dfb74e468706c3ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a4c795cebfcada5854211bf758dba888bd811675f0895a9dfb74e468706c3ec"
    sha256 cellar: :any_skip_relocation, sonoma:         "9a6b3477542c607e316296fae7479b188279a6d39e93d8ce616b8eeadec60444"
    sha256 cellar: :any_skip_relocation, ventura:        "9a6b3477542c607e316296fae7479b188279a6d39e93d8ce616b8eeadec60444"
    sha256 cellar: :any_skip_relocation, monterey:       "9a6b3477542c607e316296fae7479b188279a6d39e93d8ce616b8eeadec60444"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a4c795cebfcada5854211bf758dba888bd811675f0895a9dfb74e468706c3ec"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    %w[neonctl neon].each do |cmd|
      generate_completions_from_executable(bin/cmd, "completion")
    end
  end

  test do
    output = shell_output("#{bin}/neonctl --api-key DOES-NOT-EXIST projects create 2>&1", 1)
    assert_match("Authentication failed", output)
  end
end