class Docmd < Formula
  desc "Minimal Markdown documentation generator"
  homepage "https://docmd.mgks.dev/"
  url "https://registry.npmjs.org/@mgks/docmd/-/docmd-0.2.5.tgz"
  sha256 "89b6b3b18a466b8851f61b1353f688df00ef793a5261fefaa0fb1d7b4c498935"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "24267b6f7303375c652bfa77b8a1267b21d4f137ed2accd0e7b559ea878eab14"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docmd --version")

    system bin/"docmd", "init"
    assert_path_exists testpath/"docmd.config.js"
    assert_match "title: \"Welcome\"", (testpath/"docs/index.md").read
  end
end