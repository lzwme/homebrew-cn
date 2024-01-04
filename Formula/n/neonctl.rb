require "language/node"

class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-1.25.2.tgz"
  sha256 "bc2c1ff170c84a3ba9ea0e03116bb191336c12b512116d94e609679dbe88494c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "284faf44ab2c2647122b75f6f56c751b05fa7b5646082651d558ab603032d24d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "284faf44ab2c2647122b75f6f56c751b05fa7b5646082651d558ab603032d24d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "284faf44ab2c2647122b75f6f56c751b05fa7b5646082651d558ab603032d24d"
    sha256 cellar: :any_skip_relocation, sonoma:         "d26a10e13ad6113ebdd7824b518e790a1700680e8e0c83a18326c5552fe418ac"
    sha256 cellar: :any_skip_relocation, ventura:        "d26a10e13ad6113ebdd7824b518e790a1700680e8e0c83a18326c5552fe418ac"
    sha256 cellar: :any_skip_relocation, monterey:       "d26a10e13ad6113ebdd7824b518e790a1700680e8e0c83a18326c5552fe418ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "284faf44ab2c2647122b75f6f56c751b05fa7b5646082651d558ab603032d24d"
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