require "language/node"

class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-1.33.0.tgz"
  sha256 "220e4eb63cd0fe44176d588e6f6e2e0b906f0f373ecc1a8bfb96a1ded89f6861"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4ade773541114966df2bbcb824cd10e1ddba5902b1e5aadab4b14235aad527e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ade773541114966df2bbcb824cd10e1ddba5902b1e5aadab4b14235aad527e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ade773541114966df2bbcb824cd10e1ddba5902b1e5aadab4b14235aad527e9"
    sha256 cellar: :any_skip_relocation, sonoma:         "2d629de88a372c380fe396db76dc4f8a9f05cee9c2a48d777439da43c67b0ed4"
    sha256 cellar: :any_skip_relocation, ventura:        "2d629de88a372c380fe396db76dc4f8a9f05cee9c2a48d777439da43c67b0ed4"
    sha256 cellar: :any_skip_relocation, monterey:       "0731b3cd65cddcb2fc9e2efcba71eb2a7f13d3ec1ded7740cce272b4ba67bc03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a84f881dba5272c6038d9f76d9d23e02a36465ac543ca94f61d074c94c70845"
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