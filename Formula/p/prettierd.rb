class Prettierd < Formula
  desc "Prettier daemon"
  homepage "https:github.comfsouzaprettierd"
  url "https:registry.npmjs.org@fsouzaprettierd-prettierd-0.25.4.tgz"
  sha256 "3150e6d3502855632dc259a717e3833d321db6915d57c958cab6463e292cc033"
  license "ISC"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c6bff9b787b92531aa1acbd522ddbd8215c377717ef1f69466922bd846f3cc0b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    output = pipe_output("#{bin}prettierd test.js", "const arr = [1,2];", 0)
    assert_equal "const arr = [1, 2];", output.chomp
  end
end