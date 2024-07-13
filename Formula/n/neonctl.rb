require "language/node"

class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-1.32.1.tgz"
  sha256 "bd14cade36baaaaad00b6e256f9011db10eecba0e03864bf2bb73882da92bcb0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "108102bc7cd6e6834872b8c11a5af82142c88b5815b2cddd95dbaed0601403b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "108102bc7cd6e6834872b8c11a5af82142c88b5815b2cddd95dbaed0601403b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "108102bc7cd6e6834872b8c11a5af82142c88b5815b2cddd95dbaed0601403b0"
    sha256 cellar: :any_skip_relocation, sonoma:         "1458b2a3bc2677ab2c70bedf6c1964c8b83446d1da5720810bd8ce46ff84c139"
    sha256 cellar: :any_skip_relocation, ventura:        "1458b2a3bc2677ab2c70bedf6c1964c8b83446d1da5720810bd8ce46ff84c139"
    sha256 cellar: :any_skip_relocation, monterey:       "1458b2a3bc2677ab2c70bedf6c1964c8b83446d1da5720810bd8ce46ff84c139"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afa8ef00d55918931a58b5a6ca286647a39a7f28f210d10caa77804630dffdc8"
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