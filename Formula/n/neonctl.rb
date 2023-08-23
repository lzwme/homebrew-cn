require "language/node"

class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-1.21.2.tgz"
  sha256 "ba71d6a0c24f2cc05752ee3b7593588b7ce8e9ff06ad7947d8c98ceb407a9465"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "52d7dbe7708f33c8f94217e359f62259c5553fb2133b34ae14a434a15a1389f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52d7dbe7708f33c8f94217e359f62259c5553fb2133b34ae14a434a15a1389f1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "52d7dbe7708f33c8f94217e359f62259c5553fb2133b34ae14a434a15a1389f1"
    sha256 cellar: :any_skip_relocation, ventura:        "6680b9b6a5b90fc40a1787d1f5a2aa7449f5e4fa5f2d3036b9397b00fc00ff2b"
    sha256 cellar: :any_skip_relocation, monterey:       "6680b9b6a5b90fc40a1787d1f5a2aa7449f5e4fa5f2d3036b9397b00fc00ff2b"
    sha256 cellar: :any_skip_relocation, big_sur:        "6680b9b6a5b90fc40a1787d1f5a2aa7449f5e4fa5f2d3036b9397b00fc00ff2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52d7dbe7708f33c8f94217e359f62259c5553fb2133b34ae14a434a15a1389f1"
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