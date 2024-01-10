require "language/node"

class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-1.25.3.tgz"
  sha256 "47de7ed1a01e038b06dc832455f83860032a70bfedf6048381430c50f5b35a02"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "41b32e8c32661ae95d48f0a456b1da3d1b9c281a37c89860e8c5e4d7f579fea6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41b32e8c32661ae95d48f0a456b1da3d1b9c281a37c89860e8c5e4d7f579fea6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41b32e8c32661ae95d48f0a456b1da3d1b9c281a37c89860e8c5e4d7f579fea6"
    sha256 cellar: :any_skip_relocation, sonoma:         "4e4a8b3fdf5855e6008ba27337c05f1bbf2f6f913ae04d5ec4e054ff1d4a372c"
    sha256 cellar: :any_skip_relocation, ventura:        "4e4a8b3fdf5855e6008ba27337c05f1bbf2f6f913ae04d5ec4e054ff1d4a372c"
    sha256 cellar: :any_skip_relocation, monterey:       "4e4a8b3fdf5855e6008ba27337c05f1bbf2f6f913ae04d5ec4e054ff1d4a372c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41b32e8c32661ae95d48f0a456b1da3d1b9c281a37c89860e8c5e4d7f579fea6"
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