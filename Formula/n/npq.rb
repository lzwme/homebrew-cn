class Npq < Formula
  desc "Audit npm packages before you install them"
  homepage "https://github.com/lirantal/npq"
  url "https://registry.npmjs.org/npq/-/npq-3.16.7.tgz"
  sha256 "6e41adb381474520013e8c95997210b13692dcad2c103d6f7aeaedb142769552"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "79f5a35ac35ab28c0b32952257a044159d23d48eb1c9822877579d8e7be0276e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/npq --version")

    output = shell_output("#{bin}/npq install npq@3.5.3 --dry-run")
    assert_match "Package Health - Detected an old package", output
  end
end