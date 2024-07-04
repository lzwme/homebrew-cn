require "language/node"

class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-1.31.0.tgz"
  sha256 "5a4193385ccb9d8a1f6461dfd3ceaa594e4c797b0046ec6a760986275b4d1768"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9f3cf900c0ea86a28bf23cc71a7e8bbfaf6c1044a4ad59218d7598c254d5da09"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f3cf900c0ea86a28bf23cc71a7e8bbfaf6c1044a4ad59218d7598c254d5da09"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f3cf900c0ea86a28bf23cc71a7e8bbfaf6c1044a4ad59218d7598c254d5da09"
    sha256 cellar: :any_skip_relocation, sonoma:         "7a8781aa494e4ec76253a42d7e6ddd500d545975eefae8eaef90b4d1f570f2ad"
    sha256 cellar: :any_skip_relocation, ventura:        "7a8781aa494e4ec76253a42d7e6ddd500d545975eefae8eaef90b4d1f570f2ad"
    sha256 cellar: :any_skip_relocation, monterey:       "7a8781aa494e4ec76253a42d7e6ddd500d545975eefae8eaef90b4d1f570f2ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa34a64fca327aea13783463fc4b3dbd3e3e970c72c573ffc82dadf2674c24fb"
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