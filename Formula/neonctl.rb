require "language/node"

class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-1.20.0.tgz"
  sha256 "5eff816e04a3e82fe80d10234bfc8a3399ad8be400812dea076c339da91cf88a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7ae5302953b57206adac5e7c76398713402bb0fdf796ed4e60e8cd1ac02fa4b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7ae5302953b57206adac5e7c76398713402bb0fdf796ed4e60e8cd1ac02fa4b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f7ae5302953b57206adac5e7c76398713402bb0fdf796ed4e60e8cd1ac02fa4b"
    sha256 cellar: :any_skip_relocation, ventura:        "271af472fd6d469c7cd207f6c06cd4c46b561b62286840a5b8b418bd5d7666c2"
    sha256 cellar: :any_skip_relocation, monterey:       "271af472fd6d469c7cd207f6c06cd4c46b561b62286840a5b8b418bd5d7666c2"
    sha256 cellar: :any_skip_relocation, big_sur:        "271af472fd6d469c7cd207f6c06cd4c46b561b62286840a5b8b418bd5d7666c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7ae5302953b57206adac5e7c76398713402bb0fdf796ed4e60e8cd1ac02fa4b"
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