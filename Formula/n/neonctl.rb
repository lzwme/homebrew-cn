require "language/node"

class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-1.23.3.tgz"
  sha256 "45ee26207037b41d53fda54e4a0b21b50fb68d246cb02e91a9b43364a7fcb1f9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "05145fb2f38fae81725ed91156c8ca2c3291c859c32eb7a5eb82018f7b037c42"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "05145fb2f38fae81725ed91156c8ca2c3291c859c32eb7a5eb82018f7b037c42"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05145fb2f38fae81725ed91156c8ca2c3291c859c32eb7a5eb82018f7b037c42"
    sha256 cellar: :any_skip_relocation, sonoma:         "93492f4c878ffe513e61fd6d46eabed8fa675d3705d50f33e396c30a4de1e943"
    sha256 cellar: :any_skip_relocation, ventura:        "93492f4c878ffe513e61fd6d46eabed8fa675d3705d50f33e396c30a4de1e943"
    sha256 cellar: :any_skip_relocation, monterey:       "93492f4c878ffe513e61fd6d46eabed8fa675d3705d50f33e396c30a4de1e943"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05145fb2f38fae81725ed91156c8ca2c3291c859c32eb7a5eb82018f7b037c42"
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