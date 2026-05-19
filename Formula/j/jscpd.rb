class Jscpd < Formula
  desc "Copy/paste detector for programming source code"
  homepage "https://github.com/kucherenko/jscpd"
  url "https://registry.npmjs.org/jscpd/-/jscpd-4.2.3.tgz"
  sha256 "0959ffae9f17fe34d4ee7dcce404b524cadc3eed480d577dd47d4610f0659e69"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "891e42b7c28a3732190fc4c81db2fa5e9581dc9fe018e85dbdf0502a7477c623"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    test_file = testpath/"test.js"
    test_file2 = testpath/"test2.js"
    test_file.write <<~EOS
      console.log("Hello, world!");
    EOS
    test_file2.write <<~EOS
      console.log("Hello, brewtest!");
    EOS

    output = shell_output("#{bin}/jscpd --min-lines 1 #{testpath}/*.js 2>&1")
    assert_match "Found 0 clones", output

    assert_match version.to_s, shell_output("#{bin}/jscpd --version")
  end
end