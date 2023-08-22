require "language/node"

class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-1.21.1.tgz"
  sha256 "5875c358b0de0c0fe02c51a9f97891064ed2210db0b2ad279aae056ad48fb3f7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e3598d8b3248798eee00cc693a1b18106de5924e98cc57baf57fb3b65661029"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e3598d8b3248798eee00cc693a1b18106de5924e98cc57baf57fb3b65661029"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e3598d8b3248798eee00cc693a1b18106de5924e98cc57baf57fb3b65661029"
    sha256 cellar: :any_skip_relocation, ventura:        "9de2c7c61967de4e2dbdaeea31b3db8c2be56b000a319c8ad11fee7c5f4a92e4"
    sha256 cellar: :any_skip_relocation, monterey:       "9de2c7c61967de4e2dbdaeea31b3db8c2be56b000a319c8ad11fee7c5f4a92e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "9de2c7c61967de4e2dbdaeea31b3db8c2be56b000a319c8ad11fee7c5f4a92e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e3598d8b3248798eee00cc693a1b18106de5924e98cc57baf57fb3b65661029"
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