class Codeburn < Formula
  desc "See where your AI coding tokens go - by task, tool, model, and project"
  homepage "https://github.com/getagentseal/codeburn"
  url "https://registry.npmjs.org/codeburn/-/codeburn-0.9.10.tgz"
  sha256 "ce8f37bf6144b6dc8b9b35c4bc17024f12b15a2346e499ce77c5dcd2e1553cea"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff0a629196a76138b36cdfd0b122ba6b0d8e7555c23cd521090efa46f55da042"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff0a629196a76138b36cdfd0b122ba6b0d8e7555c23cd521090efa46f55da042"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff0a629196a76138b36cdfd0b122ba6b0d8e7555c23cd521090efa46f55da042"
    sha256 cellar: :any_skip_relocation, sonoma:        "e412138acd106028ab69d3743d0c58d990dea80d7b3b50cef38ebe08a198066d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e412138acd106028ab69d3743d0c58d990dea80d7b3b50cef38ebe08a198066d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e412138acd106028ab69d3743d0c58d990dea80d7b3b50cef38ebe08a198066d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/codeburn report --period today --format json")
    assert_match "\"generated\"", output
    assert_match "\"period\":", output
    assert_match "\"overview\"", output
  end
end