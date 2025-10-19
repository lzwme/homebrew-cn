class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-3.7.0.tgz"
  sha256 "00d16561d42ee40ad4b9921d87b4cab997177203738a4ab0f55efcfc02e7b16b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e07d22f2b68f7a150711d16024c97ee7cffcec7290bdf7e88fd7cf09dea4b9b0"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rulesync --version")

    output = shell_output("#{bin}/rulesync init")
    assert_match "rulesync initialized successfully", output
    assert_match "Project overview and general development guidelines", (testpath/".rulesync/rules/overview.md").read
  end
end