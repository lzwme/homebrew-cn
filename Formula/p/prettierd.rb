class Prettierd < Formula
  desc "Prettier daemon"
  homepage "https:github.comfsouzaprettierd"
  url "https:registry.npmjs.org@fsouzaprettierd-prettierd-0.26.0.tgz"
  sha256 "4e99452dd2fb62971f8bf035d76af38d0af9a10ce9166f82b9a42d86b9ce0d7c"
  license "ISC"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7267f5166526478255bba5330f289d8d62640495d32ae6799fec9ac81465e569"
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